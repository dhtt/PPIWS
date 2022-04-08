package com.webserver;

import framework.ConstructedNetworks;
import framework.DataQuery;
import framework.NetworkBuilder;
import framework.PPIN;

import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

import static standalone_tools.PPIXpress_Tomcat.*;

public class PPIXpressRun {
    private boolean gene_level_only = false;
    private boolean output_DDINs = false;
    private boolean STRING_weights = false;
    private boolean output_major_transcripts = false;
    private boolean norm_transcripts = false;
    private boolean report_gene_abundance = false;
    private boolean compress_output = false;
    private boolean update_UniProt = false;
    private boolean include_ELM = false;
    private boolean report_reference = false;
    private boolean remove_decay_transcripts = true;
    private boolean up2date_DDIs = true;
    private double threshold = 1.0;
    private double percentile = -1;
    private List<String> argList = new ArrayList<String>();
    Hashtable<String, String> arg_to_name = new Hashtable<>();

    public PPIXpressRun(){
        arg_to_name.put("-w", "Add STRING weights");
        arg_to_name.put("-u", "Update UniProt accessions");
        arg_to_name.put("-l", "Only local DDI data");
        arg_to_name.put("-elm", "Include ELM data");
        arg_to_name.put("-g", "Gene-level only");
        arg_to_name.put("-n", "Normalize transcripts");
        arg_to_name.put("-x", "Remove decay transcripts");
        arg_to_name.put("-d", "Output DDINs");
        arg_to_name.put("-m", "Output major transcripts");
        arg_to_name.put("-c", "Compress output");
        arg_to_name.put("-reference", "Output reference network");
        arg_to_name.put("-mg", "Report gene abundance");
        arg_to_name.put("-t", "Threshold");
        arg_to_name.put("-tp", "Percentile");
    }


    /**
     * Create HTML element
     * @param Tag a HTML tag starts and closes without <>
     * @param Content Content
     * @return HTML element
     */
    static String createElement(String Tag, String Content){
        return ("<" + Tag + ">" + Content + "</" + Tag + ">");
    }


    public void parseInput(String[]... arg_lists_){

        for (String[] arg_list_ : arg_lists_){

            for (String arg:arg_list_) {
                if (arg.startsWith("-t=") || arg.startsWith("-tp=")){
                    // set manual threshold
                    if (arg.startsWith("-t=")){
                        threshold = Double.parseDouble(arg.split("=")[1]);
                        argList.add(arg_to_name.get("-t") + ": " + threshold);
                    }

                    // set percentile threshold
                    else if (arg.startsWith("-tp=")){
                        percentile = Double.parseDouble(arg.split("=")[1]);
                        argList.add(arg_to_name.get("-tp") + ": " + percentile);
                    }
                }
                else {
                    argList.add(arg_to_name.get(arg));

                    // gene level only
                    switch (arg) {
                        case "-g":
                            gene_level_only = true;
                            break;

                        // gene level only
                        case "-x":
                            remove_decay_transcripts = false;
                            break;

                        // output domain-domain interaction networks
                        case "-d":
                            output_DDINs = true;
                            break;

                        // output domain-domain interaction networks
                        case "-w":
                            STRING_weights = true;
                            break;

                        // output major transcript per protein
                        case "-m":
                            output_major_transcripts = true;
                            break;

                        // normalize transcripts
                        case "-n":
                            norm_transcripts = true;
                            break;

                        // output major transcript per protein with each ones abundance as the sum of all its expressed coding transcripts
                        case "-mg":
                            output_major_transcripts = true;
                            report_gene_abundance = true;
                            break;

                        // compress output
                        case "-c":
                            compress_output = true;
                            break;

                        // update outdated UniProt accessions
                        case "-u":
                            update_UniProt = true;
                            break;

                        // turn off retrieval of iPfam domain-domain interaction data
                        case "-l":
                            up2date_DDIs = false;
                            DataQuery.localDDIsOnly();
                            break;
                    }
                }
            }
        }
    }

    public String[] getArgs(){
        return argList.stream().filter(s -> (s != null && s.length() > 0)).toArray(String[]::new);
    }

    public static void updateAtomicString(AtomicReference<String> runMessage_, String newMessage_){
        runMessage_.getAndSet(runMessage_.get() + newMessage_);
    }

    public void runAnalysis(AtomicBoolean updatingStop, AtomicReference<String> runMessage) {
        //gathering even more data if necessary

        runMessage.set(createElement("li", "Switch Server GRCh37"));
        DataQuery.switchServerGRCh37();


        updateAtomicString(runMessage, createElement("li", "Retrieving UCSC mapping-data"));
        DataQuery.getUCSChg19toTranscriptMap();

        updateAtomicString(runMessage, "<li>Reading network (may take some time if ID conversion is necessary)");
        PPIN original_network = new PPIN("/Users/trangdo/IdeaProjects/Webserver/src/main/resources/input/human_ppin.sif.gz");
        updateAtomicString(runMessage, "<ul>" +
                createElement("li", "Complete network: " + original_network.getSizesStr()) +
                "</ul></li>");
/*
        // gathering data that will always be needed
        updateAtomicString(runMessage, "<li>Get Ensembl organism database from proteins</li>");
        String organism_database = DataQuery.getEnsemblOrganismDatabaseFromProteins(original_network.getProteins());
        String ensembl_version = organism_database.split("_")[organism_database.split("_").length-2];

        updateAtomicString(runMessage, "<li>Retrieving ENSEMBL " + ensembl_version + " data from database " + organism_database + " (may take some minutes)<br>");
        updateAtomicString(runMessage, "<ul><li>Get genes transcripts proteins</li>");
        DataQuery.getGenesTranscriptsProteins(organism_database);
        updateAtomicString(runMessage, "<li>Get isoform protein domain map</li></ul>");
        DataQuery.getIsoformProteinDomainMap(organism_database);

        // start preprocessing
        updateAtomicString(runMessage,"<li>Initializing PPIXpress with original network</li>");
        NetworkBuilder builder = new NetworkBuilder(original_network, true, false);
        updateAtomicString(runMessage,"<ul><li>" + Math.round(builder.getMappingDomainPercentage() * 10000)/100.0 +
                "% of proteins could be annotated with at least one non-artificial domain</li>" );
        updateAtomicString(runMessage, "<li>" + Math.round(builder.getMappingPercentage() * 10000)/100.0 +
                "% of protein interactions could be associated with at least one non-artificial domain interaction.</li></ul>" );

//        construct isoform network
        updateAtomicString(runMessage,"<li>Constructing associated isoform networks</li>");
//        ConstructedNetworks constr = NetworkBuilder.constructAssociatedIsoformNetworks(original_network);*/

//        write output files
        updateAtomicString(runMessage, "... Building output data for reference network ");
//        updateAtomicString(runMessage, "a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>" +
//                "a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>a<br>");
//        String file_suffix = "_ppin.txt";
//        constr.getPPIN().writePPIN("example" + file_suffix);
//
//        updateAtomicString(runMessage, "-> " + constr.getPPIN().getSizesStr());
//
//        file_suffix = "_ddin.txt";
//        constr.getDDIN().writeDDIN("example" + file_suffix);
//
//        file_suffix = "_major-transcripts.txt";
//        constr.writeProteinToAssumedTranscriptMap( "example" + file_suffix);


        updateAtomicString(runMessage, "<br>");
        updatingStop.set(true);
    }

    public static void main(String[] args) {
        System.out.println("Initialize");
        PPIXpressRun new_pipeline = new PPIXpressRun();
        System.out.println("Initial args");
        System.out.println(Arrays.toString(new_pipeline.getArgs()));
        System.out.println("After parsing");
        new_pipeline.parseInput(new String[]{"-g"});
        System.out.println(Arrays.toString(new_pipeline.getArgs()));

//        new_pipeline.runAnalysis();
    }
}

package com.webserver;

import framework.DataQuery;
import framework.NetworkBuilder;
import framework.PPIN;

import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

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
    public void parseArgs(String[]... arg_lists_){
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

    public void runAnalysis(AtomicInteger progressByPercent, AtomicReference<String> message){
//        Test database connection
        //gathering even more data if necessary
//        out.println("Switch Server GRCh37 ...<br>");
        message.set("... Switch Server GRCh37<br>");
        DataQuery.switchServerGRCh37();
        progressByPercent.incrementAndGet(); //1

//        out.println("Retrieving UCSC mapping-data ...");
        message.getAndSet(message.get() + "... Retrieving UCSC mapping-data<br>");
//        message.set(message.get() + "... Retrieving UCSC mapping-data<br>");
//        DataQuery.getUCSChg19toTranscriptMap();
        progressByPercent.incrementAndGet(); //2

//        out.println("Reading network (may take some time if ID conversion is necessary) ...<br>");
        message.getAndSet(message.get() + "... Reading network (may take some time if ID conversion is necessary)<br>");
        PPIN original_network = new PPIN("/Users/trangdo/Documents/BIOINFO/PPIXpress/example_data/human_ppin.sif.gz");
//        out.println("Complete network: " + original_network.getSizesStr() + "<br>");
        message.getAndSet(message.get() + "...... Complete network: " + original_network.getSizesStr() + "<br>");
        progressByPercent.incrementAndGet(); //3

        // gathering data that will always be needed
//        out.println("Get Ensembl Organism Database From Proteins<br>");
        message.getAndSet(message.get() + "... Get Ensembl organism database from proteins<br>");
        String organism_database = DataQuery.getEnsemblOrganismDatabaseFromProteins(original_network.getProteins());
        String ensembl_version = organism_database.split("_")[organism_database.split("_").length-2];
        progressByPercent.incrementAndGet(); //4

//        out.print("Retrieving ENSEMBL " + ensembl_version + " data from database " + organism_database + " (may take some minutes) ...<br>");
        message.getAndSet(message.get() + "... Retrieving ENSEMBL " + ensembl_version + " data from database " + organism_database + " (may take some minutes)<br>");
        message.getAndSet(message.get() + "...... Get genes transcripts proteins<br>");
        DataQuery.getGenesTranscriptsProteins(organism_database);
        message.getAndSet(message.get() + "...... Get isoform protein domain map<br>");
        DataQuery.getIsoformProteinDomainMap(organism_database);
        progressByPercent.incrementAndGet(); //5

        // start preprocessing
//        out.println("Initializing PPIXpress with original network ... <br>");
        message.getAndSet(message.get() + "... Initializing PPIXpress with original network<br>");
        NetworkBuilder builder = new NetworkBuilder(original_network, true, false);
//        message.getAndSet(message.get() + Math.round(builder.getMappingDomainPercentage() * 10000)/100.0 +"% of proteins could be annotated with at least one non-artificial domain," );
//        message.getAndSet(message.get() + Math.round(builder.getMappingPercentage() * 10000)/100.0 +"% of protein interactions could be associated with at least one non-artificial domain interaction.<br>" );
//        out.flush();
        message.getAndSet(message.get() + "<h4>PPIXpress pipeline finished!</h4>");
        progressByPercent.incrementAndGet(); //6

//        Testing Pool connection
       /* PoolProperties p = new PoolProperties();
        p.setUrl("jdbc:mysql://localhost:3306/javatest");
        p.setDriverClassName("com.mysql.cj.jdbc.Driver");
        p.setUsername("root");
        p.setPassword("Cats4Life!");
        p.setLogAbandoned(true);
        p.setRemoveAbandoned(true);
        DataSource datasource = new DataSource();
        datasource.setPoolProperties(p);

        Connection connection = null;
        try {
            out.println("datasource is being used");
            connection = datasource.getConnection();
            Statement st = connection.createStatement();
            st.setQueryTimeout(10);
            out.println("DONE");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("EXCEPTION OCCURRED");
        }*/
    }
    public static void main(String[] args) {
        System.out.println("Initialize");
        PPIXpressRun new_pipeline = new PPIXpressRun();
        System.out.println("Initial args");
        System.out.println(Arrays.toString(new_pipeline.getArgs()));
        System.out.println("After parsing");
        new_pipeline.parseArgs(new String[]{"-g"});
        System.out.println(Arrays.toString(new_pipeline.getArgs()));

//        new_pipeline.runAnalysis();
    }
}

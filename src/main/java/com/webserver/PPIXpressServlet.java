package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.Objects;

import framework.PPIN;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void printList(PrintWriter out, String[] list){
        for (String i : list){
            if (!Objects.equals(i, "null")) out.println(i + "<br>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h4>Data submitted!<br><br>Uploaded files:</h4>");
//        Show uploaded files
        for (Part part : request.getParts()) {
            if (part.getSubmittedFileName() != null) {
                out.println(part.getName() + ": " + part.getSubmittedFileName() + "<br>");
            }
        }

//        Show run options
//        boolean gene_level_only, remove_decay_transcripts, output_DDINs, STRING_weights, output_major_transcripts,
//                norm_transcripts, report_gene_abundance, compress_output, update_UniProt,
//                up2date_DDIs, include_ELM = false;
//        boolean remove_decay_transcripts, up2date_DDIs = true;

        Double threshold, percentile;
        String[] PPI_Options = request.getParameterValues("PPIOptions");
        out.println("<br><h4> PPI Options </h4>");
        printList(out, PPI_Options);

        String[] Exp_Options = request.getParameterValues("ExpOptions");
        out.println("<br><h4> Exp Options </h4>");
        printList(out, Exp_Options);

        String[] Run_Options = request.getParameterValues("RunOptions");
        out.println("<br><h4> Run Options </h4>");
        printList(out, Run_Options);

//        Show run options
        out.println("<br><h4>Begin PPIXpress from Servlet...</h4>");

//        Run PPIXpress
        out.println("<h5>Creating PPIN</h5>");
        PPIN original_network = new PPIN("/Users/trangdo/Documents/BIOINFO/PPIXpress_1.23/example_data/human_ppin.sif");
        out.println("Complete network:" + original_network.getSizesStr() + "<br>");
//        String organism_database = DataQuery.getEnsemblOrganismDatabaseFromProteins(original_network.getProteins());
//        out.println("Organism database:" + organism_database + "<br>");
//        String ensembl_version = organism_database.split("_")[organism_database.split("_").length-2];
//        out.println("Ensembl version" + ensembl_version);

//        out.println("<h5>Building network... This might take a while</h5>");
//        NetworkBuilder builder = new NetworkBuilder(original_network);
//        out.println(builder);
//        out.println("<h5>Building output data for reference network</h5>");
//        ConstructedNetworks constr = NetworkBuilder.constructAssociatedIsoformNetworks(original_network);
//        out.print("Last step: Generating downloadable files");
//        String file_suffix = "_ppin.txt";
//        constr.getPPIN().writePPIN("src/data" + file_suffix);
//        out.println("Done");
    }
    public static void main(String[] args){
    }
}

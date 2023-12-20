package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static com.webserver.Utils.*;
import static standalone_tools.PPIXpress_Tomcat.createElement;

@WebServlet(name = "DownloadServlet", value = "/DownloadServlet")
@MultipartConfig()

public class DownloadServlet extends HttpServlet {
    protected String PROGRAM;
    protected String USER_ID;
    protected String OUTPUT_PATH;
    protected String OUTPUT_FILENAME;
    protected String LOCAL_STORAGE_PATH;
    protected String SAMPLE_FILENAME;
    protected String resultFileType;
    protected ServletContext context;
    protected ArrayList<String> proteinList;
    protected Map<String, String[]> proteinAttributeList;
    protected PrintWriter out;

    /**
     * Initilize ServletContext log to localhost log files
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        context = getServletContext();
    }

    /**
     * Zip output files in the result folder
     * 
     * @param sourceDirPath_ path to folder to be zipped
     * @param zipPath_       path to zipped folder
     * @throws IOException
     * Source: https://stackoverflow.com/a/68439125/9798960
     */
    public static void zip(String sourceDirPath_, String zipPath_) throws IOException {
        Files.deleteIfExists(Paths.get(zipPath_));
        Path zipFile = Files.createFile(Paths.get(zipPath_));

        Path sourceDirPath = Paths.get(sourceDirPath_);
        try (
                ZipOutputStream zipOutputStream = new ZipOutputStream(Files.newOutputStream(zipFile));
                Stream<Path> paths = Files.walk(sourceDirPath)) {
            paths
                    .filter(path -> !Files.isDirectory(path))
                    .forEach(path -> {
                        if (path.toString().endsWith(".gz") || path.toString().endsWith(".txt")) {
                            ZipEntry zipEntry = new ZipEntry(sourceDirPath.relativize(path).toString());
                            try {
                                zipOutputStream.putNextEntry(zipEntry);
                                Files.copy(path, zipOutputStream);
                                zipOutputStream.closeEntry();
                            } catch (IOException e) {
                                System.out.println(e.getMessage());
                            }
                        }
                    });
            zipOutputStream.finish();
        }
    }

    public static void writeFile(HttpServletResponse response_, String OutputFilePath) {
        File outputFile = new File(OutputFilePath);
        response_.setContentLength((int) outputFile.length());

        try {
            FileInputStream InStream = new FileInputStream(outputFile);
            try (BufferedInputStream BufInStream = new BufferedInputStream(InStream)) {
                ServletOutputStream ServletOutStream = response_.getOutputStream();
                int readBytes = 0;

                // read from the file; write to the ServletOutputStream
                while ((readBytes = BufInStream.read()) != -1) {
                    ServletOutStream.write(readBytes);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // Define a data local storage on the local server
            LOCAL_STORAGE_PATH = session.getAttribute("LOCAL_STORAGE_PATH") == null ? ""
                : session.getAttribute("LOCAL_STORAGE_PATH").toString();
                
            String[] splitPath = LOCAL_STORAGE_PATH.split("/");
            USER_ID = splitPath[splitPath.length - 1];
            // PROGRAM shows if PPIXpress or PPICompare is being called
            PROGRAM = session.getAttribute("PROGRAM") == null ? ""
                : session.getAttribute("PROGRAM").toString();

            OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
            OUTPUT_FILENAME = "ResultFiles.zip"; 
            SAMPLE_FILENAME = "SampleTable.html"; // This file name must be the same as defined for sample_table in PPIXpress_tomcat.java

            resultFileType = request.getParameter("resultFileType");
            proteinList = new ArrayList<String>();
            proteinAttributeList = new HashMap<String, String[]>(); 
            context.log(USER_ID + ": DownloadServlet: All info\n" + LOCAL_STORAGE_PATH + "\n" + PROGRAM + "\n" + OUTPUT_PATH + "\n" + resultFileType);
            
        } catch(Exception e){
            context.log(USER_ID + ": DownloadServlet: Fail to retrieve session information. ERROR:\n" + e);
        }

        switch (resultFileType) {
            case "output":
                response.setHeader("Content-Disposition", "attachment; filename=\"" + OUTPUT_FILENAME + "\"");
                response.setContentType("application/zip");
                response.setHeader("Cache-Control", "max-age=60");
                response.setHeader("Cache-Control", "must-revalidate");

                try {
                    zip(OUTPUT_PATH, OUTPUT_PATH + OUTPUT_FILENAME);
                } catch (IOException e) {
                    context.log(USER_ID + ": DownloadServlet: Fail to compress output. ERROR:\n" + e);
                }

                writeFile(response, OUTPUT_PATH + OUTPUT_FILENAME);
                break;

            case "sample_summary":
                out = response.getWriter();

                try {
                    File HTMLText = new File(OUTPUT_PATH + SAMPLE_FILENAME);
                    Scanner file = new Scanner(HTMLText);

                    while (file.hasNext()) {
                        String s = file.nextLine();
                        out.println(s);
                    }

                    file.close();
                } catch (Exception e) {
                    context.log(USER_ID + ": DownloadServlet: Fail to retrieve sample summary. ERROR:\n" + e);
                    out.println("Fail to retrieve sample summary. Please contact authors using the ID:\n" + USER_ID);
                }

                break;

            case "graph":
                out = response.getWriter();

                try {
                    if (PROGRAM.equals("PPIXpress")){
                        String proteinQuery = request.getParameter("proteinQuery");
                        String expressionQuery = request.getParameter("expressionQuery");
                        boolean showDDIs = Boolean.parseBoolean(request.getParameter("showDDIs"));
                        context.log(proteinQuery + " " + expressionQuery + " " + showDDIs);
                        JSONArray subNetworkData = filterProtein(OUTPUT_PATH, proteinQuery, expressionQuery, showDDIs);
                        out.println(subNetworkData);
                    }
                    else if (PROGRAM.equals("PPICompare")){
                        // Get graph data for cytoscape.js to display on NVContent_Graph
                        Scanner s = new Scanner(new File(OUTPUT_PATH + "protein_attributes.txt"));
                        while (s.hasNext()) {
                            String[] attributes = s.nextLine().split(" ");
                            String UniprotID = attributes[0];
                            proteinAttributeList.put(UniprotID, attributes);
                        }

                        JSONArray subNetworkData = filterProtein_PPICompare(OUTPUT_PATH, proteinAttributeList);
                        out.println(subNetworkData);
                    }
                } catch (Exception e) {
                    context.log(USER_ID + ": DownloadServlet: Fail to retrieve data for graphs data. ERROR:\n" + e);
                    out.println("Fail to retrieve graphs data. Please contact authors using the ID:\n" + USER_ID);
                }

                break;

            case "protein_list":
                out = response.getWriter();

                try {
                    if (PROGRAM.equals("PPIXpress")){
                        Scanner s = new Scanner(new File(OUTPUT_PATH + "ProteinList.txt"));
                        while (s.hasNext()) {
                            proteinList.add(createElement("option", s.next()));
                        }
                        out.println(String.join("", proteinList));
                    }
                    else if (PROGRAM.equals("PPICompare")){
                        Scanner s = new Scanner(new File(OUTPUT_PATH + "protein_attributes.txt"));
                        while (s.hasNext()) {
                            s.nextLine();
                            String UniprotID = s.nextLine().split(" ")[0];
                            proteinList.add(createElement("option", UniprotID));
                        }
                        out.println(String.join("", proteinList));
                    }
                    
                } catch (Exception e) {
                    context.log(USER_ID + ": DownloadServlet: Fail to retrieve protein list. ERROR:\n" + e);
                    out.println("Fail to retrieve protein list. Please contact authors using the ID:\n" + USER_ID);
                }
                break;
        }

    }
}

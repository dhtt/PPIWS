package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;

import java.io.*;
import java.util.*;

import static framework.UtilitiesWebserver.createElement;

@WebServlet(name = "DownloadServlet", value = "/DownloadServlet")
@MultipartConfig()

public class DownloadServlet extends HttpServlet {
    protected String PROGRAM;
    protected String USER_ID;
    protected String OUTPUT_PATH;
    protected String OUTPUT_FILENAME;
    protected String LOCAL_STORAGE_PATH;
    protected String SAMPLE_FILENAME;
    protected String SUBMIT_TYPE;
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

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // USER_ID and PROGRAM are retrieved from request parameter
            USER_ID = request.getParameter("USER_ID") == null ? "" : request.getParameter("USER_ID").toString();
            PROGRAM = request.getParameter("PROGRAM") == null ? "" : request.getParameter("PROGRAM").toString();
            resultFileType =  request.getParameter("resultFileType") == null ? "" : request.getParameter("resultFileType").toString();
            
            // Define the path to the folder where INPUT and OUTPUT are stored for each user/example run
            LOCAL_STORAGE_PATH = USER_ID.equals("EXAMPLE_USER") ? 
                "/home/trang/PPIWS/repository/example_run/" + PROGRAM + "/" : "/home/trang/PPIWS/repository/uploads/" + USER_ID + "/" + PROGRAM + "/"; 
            OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
            OUTPUT_FILENAME = "ResultFiles.zip"; 

            // Internal log 
            context.log(USER_ID + ": DownloadServlet: All info:" + 
                "\n-PATH: " + LOCAL_STORAGE_PATH + 
                "\n-PROGRAM: " + PROGRAM + 
                "\n-RESULT FILE TYPE: " + resultFileType);

            switch (resultFileType) {
                case "output":
                    //  Download the zipped output file
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + OUTPUT_FILENAME + "\"");
                    response.setContentType("application/zip");
                    response.setHeader("Cache-Control", "max-age=60");
                    response.setHeader("Cache-Control", "must-revalidate");

                    // Compress output
                    try {
                        Utils.zip(OUTPUT_PATH, OUTPUT_PATH + OUTPUT_FILENAME);
                    } catch (IOException e) {
                        context.log(USER_ID + ": DownloadServlet: Fail to compress output. ERROR:\n" + e.toString());
                    }

                    // Write output to response
                    UtilsServlet.writeFile(response, OUTPUT_PATH + OUTPUT_FILENAME);
                    break;

                case "sample_summary":
                    // Retrieve sample summary for PPIXpress
                    SAMPLE_FILENAME = "SampleTable.html"; // This file name must be the same as defined for sample_table in PPIXpress_tomcat.java
                    out = response.getWriter();
                    
                    // Read and write output to response
                    try (BufferedReader br = new BufferedReader(new FileReader(OUTPUT_PATH + SAMPLE_FILENAME))) {
                        while (br.ready()) {
                            out.println(br.readLine());
                        }
                    } catch (Exception e) {
                        context.log(USER_ID + ": DownloadServlet: Fail to retrieve sample summary. ERROR:\n" + e.toString());
                    }
                    break;

                case "graph":
                    // Retrieve graph data to display on NVContent_Graph
                    out = response.getWriter();
                    try {
                        if (PROGRAM.equals("PPIXpress")){
                            String proteinQuery = request.getParameter("proteinQuery");
                            String expressionQuery = request.getParameter("expressionQuery");
                            boolean showDDIs = Boolean.parseBoolean(request.getParameter("showDDIs"));
                            
                            JSONArray subNetworkData = Utils.filterProtein(OUTPUT_PATH, proteinQuery, expressionQuery, showDDIs);


                            // Write output to response
                            out.println(subNetworkData);                    
                        } else if (PROGRAM.equals("PPICompare")){
                            proteinAttributeList = new HashMap<String, String[]>(); 
                            Scanner s = new Scanner(new File(OUTPUT_PATH + "protein_attributes.txt"));

                            while (s.hasNext()) {
                                String[] attributes = s.nextLine().split(" ");
                                String UniprotID = attributes[0];
                                proteinAttributeList.put(UniprotID, attributes);
                            }
                            s.close();

                            JSONArray subNetworkData = Utils.filterProtein_PPICompare(OUTPUT_PATH, proteinAttributeList);

                            // Write output to response
                            out.println(subNetworkData);
                        }
                    } catch (Exception e) {
                            context.log(USER_ID + ": DownloadServlet: Fail to retrieve data for graphs data. ERROR:\n" + e.toString());
                            out.println("Fail to retrieve graphs data. Please contact authors using the ID:\n" + USER_ID);
                    }
                    break;

                case "protein_list":
                    // Retrieve the protein list for PPIXpress graph query or PPICompare protein highlight
                    out = response.getWriter();
                    proteinList = new ArrayList<String>();
                    
                    // Define protein list source (the same as defined for sample_table in PPIXpress/PPICompare_Tomcat.java)
                    SAMPLE_FILENAME = PROGRAM.equals("PPIXpress") ? "ProteinList.txt" : PROGRAM.equals("PPICompare") ? "protein_attributes.txt" : null; 


                    // Read and write output to response
                    try (BufferedReader br = new BufferedReader(new FileReader(OUTPUT_PATH + SAMPLE_FILENAME))) { 
                        if (PROGRAM.equals("PPIXpress")){
                            while (br.ready()) {
                                proteinList.add(createElement("option", br.readLine()));
                            }
                            out.println(String.join("", proteinList));
                        }
                        else if (PROGRAM.equals("PPICompare")){
                            while (br.ready()) {
                                String UniprotID = br.readLine().split(" ")[0];
                                proteinList.add(createElement("option", UniprotID));
                            }
                            out.println(String.join("", proteinList));
                        }
                    } catch (Exception e) {
                        context.log(USER_ID + ": DownloadServlet: Fail to retrieve protein list. ERROR:\n" + e.toString());
                    }

                    break;
                }
            } catch(Exception e){
                context.log(USER_ID + ": DownloadServlet: Fail to retrieve session information. ERROR:\n" + e.toString());
            }
        }
    }

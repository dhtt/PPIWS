package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;

import java.io.*;
import java.util.*;

import static framework.UtilitiesWebserver.createElement;

@WebServlet(name = "PPICompareDownloadServlet", value = "/PPICompareDownloadServlet")
@MultipartConfig()

public class PPICompareDownloadServlet extends HttpServlet {
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

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // Define a data local storage on the local server
            LOCAL_STORAGE_PATH = session.getAttribute("LOCAL_STORAGE_PATH") == null ? 
                "" : session.getAttribute("LOCAL_STORAGE_PATH").toString();
                
            String[] splitPath = LOCAL_STORAGE_PATH.split("/");
            USER_ID = splitPath[splitPath.length - 2];
            // PROGRAM shows if PPIXpress or PPICompare is being called
            PROGRAM = session.getAttribute("PROGRAM") == null ? 
                "" : session.getAttribute("PROGRAM").toString();

            OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
            OUTPUT_FILENAME = "ResultFiles.zip"; 

            resultFileType = request.getParameter("resultFileType");
            
            context.log(USER_ID + ": PPICompareDownloadServlet: All info:\n" + LOCAL_STORAGE_PATH + "\n" + PROGRAM + "\n" + OUTPUT_PATH + "\n" + resultFileType + "\n" + USER_ID);

            switch (resultFileType) {
                case "output":
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + OUTPUT_FILENAME + "\"");
                    response.setContentType("application/zip");
                    response.setHeader("Cache-Control", "max-age=60");
                    response.setHeader("Cache-Control", "must-revalidate");

                    try {
                        Utils.zip(OUTPUT_PATH, OUTPUT_PATH + OUTPUT_FILENAME);
                    } catch (IOException e) {
                        context.log(USER_ID + ": PPICompareDownloadServlet: Fail to compress output. ERROR:\n" + e);
                    }

                    UtilsServlet.writeFile(response, OUTPUT_PATH + OUTPUT_FILENAME);
                    break;

                case "graph":
                    out = response.getWriter();
                    try {
                            // Get graph data for cytoscape.js to display on NVContent_Graph
                            proteinAttributeList = new HashMap<String, String[]>(); 
                            Scanner s = new Scanner(new File(OUTPUT_PATH + "protein_attributes.txt"));

                            while (s.hasNext()) {
                                String[] attributes = s.nextLine().split(" ");
                                String UniprotID = attributes[0];
                                proteinAttributeList.put(UniprotID, attributes);
                            }
                            s.close();

                            JSONArray subNetworkData = Utils.filterProtein_PPICompare(OUTPUT_PATH, proteinAttributeList);
                            out.println(subNetworkData);
                    } catch (Exception e) {
                            context.log(USER_ID + ": PPICompareDownloadServlet: Fail to retrieve data for graphs data. ERROR:\n" + e);
                            out.println("Fail to retrieve graphs data. Please contact authors using the ID:\n" + USER_ID);
                    }
                    break;

                case "protein_list":
                    out = response.getWriter();
                    proteinList = new ArrayList<String>();
                    SAMPLE_FILENAME = "protein_attributes.txt"; // This file name must be the same as defined for sample_table in PPICompare_tomcat.java
                    
                    try (BufferedReader br = new BufferedReader(new FileReader(OUTPUT_PATH + SAMPLE_FILENAME))) { 
                        while (br.ready()) {
                            String UniprotID = br.readLine().split(" ")[0];
                            proteinList.add(createElement("option", UniprotID));
                        }
                        out.println(String.join("", proteinList));
                    } catch (Exception e) {
                        context.log(USER_ID + ": PPICompareDownloadServlet: Fail to retrieve protein list. ERROR:\n" + e);
                    }

                    break;
                }
            } catch(Exception e){
                context.log(USER_ID + ": PPICompareDownloadServlet: Fail to retrieve session information. ERROR:\n" + e);
            }
        }
    }

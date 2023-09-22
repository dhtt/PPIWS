package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

import standalone_tools.PPIXpress_Tomcat;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
    private static ServletContext context;

    /**
     * Initilize ServletContext log to localhost log files
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        context = getServletContext();
    }


    /**
     * TODO: Write documentation
     */
    static class LongRunningProcess implements Runnable {
        private final AtomicBoolean stopSignal;
        private final PPIXpress_Tomcat pipeline = new PPIXpress_Tomcat();
        private volatile boolean stop;
        private final List<String> argList;

        public LongRunningProcess(List<String> allArgs, AtomicBoolean stopSignal) {
            this.stopSignal = stopSignal;
            this.argList = allArgs;
        }

        @Override
        public void run() {
            try {
                while (!stop) {
                    pipeline.runAnalysis(this.argList, stopSignal);
                    if (stopSignal.get()) {
                        setStop(true);
                    }
                }    
            } catch (Exception e) {
                context.log(e.toString());
            }
            
        }

        public boolean getStop() {
            return stop;
        }

        public void setStop(boolean stop) {
            this.stop = stop;
        }
    }


    private String USER_ID;
    private String LOCAL_STORAGE_PATH;
    private String INPUT_PATH;
    private String OUTPUT_PATH;
    private String FILENAME_PPI;
    private String ORIGINAL_NETWORK_PATH;
    int NO_EXPRESSION_FILE;
    String SUBMIT_TYPE;
    List<String> allArgs = new ArrayList<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Main pipeline
        response.setContentType("text/html");

        // Store uploaded files outside webapp deploy folders (LOCAL_STORAGE_PATH) and
        // output.zip inside deploy folder (WEBAPP_PATH)
        USER_ID = request.getSession().getId(); // Each user has their own ID
        SUBMIT_TYPE = request.getParameter("SUBMIT_TYPE");
        allArgs.clear();
        

        if (SUBMIT_TYPE.equals("RunExample")) {
            try {
                // Define a data local storage on the local server
                LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/example_run/PPIXpress/"; 
                INPUT_PATH = LOCAL_STORAGE_PATH + "INPUT/";
                OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
                FILENAME_PPI = "example_ppi_data.sif";

                // Add path to protein network to arguments set
                ORIGINAL_NETWORK_PATH = INPUT_PATH + FILENAME_PPI;
                allArgs.add(ORIGINAL_NETWORK_PATH);

                // Add output path to arguments set
                allArgs.add(OUTPUT_PATH);

                // Add paths to expression data to argument list
                try {
                    File inputFiles = new File(INPUT_PATH);
                    File[] inputFilesPaths = inputFiles.listFiles();
                    NO_EXPRESSION_FILE = 0;
                    for (File file : inputFilesPaths){
                        if (file.isFile() && file.getName().startsWith("expression") && file.getName().endsWith(".txt")){
                            allArgs.add(file.getAbsolutePath());

                            // Set number of expression files
                            NO_EXPRESSION_FILE += 1;
                        }
                    }
                } catch (Exception e) {
                    context.log(USER_ID + ": PPIXpressServlet: Fail to retrieve example expression files. ERROR:\n" + e);
                }
                context.log(USER_ID + ": PPIXpressServlet: Example process initiated from Servlet\n" + allArgs);
            } catch(Exception e){
                context.log(USER_ID + ": PPIXpressServlet: Fail to initiate example run\n" + e);
             }
        } 
        else if (SUBMIT_TYPE.equals("RunNormal")) {
            try {
                // Define a data local storage on the local server
                LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/uploads/" + USER_ID + "/PPIXpress/"; 

                // Create input directory
                Utils.createUserDir(LOCAL_STORAGE_PATH); 
                INPUT_PATH = LOCAL_STORAGE_PATH + "INPUT/";
                OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
                FILENAME_PPI = "ppi_data.sif";

                String taxonID = request.getParameter("protein_network_web");

                // If taxon = null, use a predefined path to store input PPI
                // network on server, else use taxon to retrieve network from Mentha/IntAct
                // Add path to protein network to arguments set
                ORIGINAL_NETWORK_PATH = taxonID.isEmpty() ? INPUT_PATH + FILENAME_PPI : "taxon:" + taxonID;
                allArgs.add(ORIGINAL_NETWORK_PATH);

                // Add output path to arguments set
                allArgs.add(OUTPUT_PATH);

                // Add paths to expression data to argument list. Meanwhile, store user's PPI
                // network (if uploaded) and expression data to a local storage on server
                try {
                    for (Part part : request.getParts()) {
                        String fileType = part.getName();
                        String fileName = part.getSubmittedFileName();

                        if (fileName != null && !fileName.equals("")) {

                            if (fileType.equals("protein_network_file"))
                                UtilsServlet.writeOutputStream(part, ORIGINAL_NETWORK_PATH);

                            else if (fileType.equals("expression_file")) {
                                String inputFilesPath = INPUT_PATH + fileName.substring(fileName.lastIndexOf("\\") + 1);
                                UtilsServlet.writeOutputStream(part, inputFilesPath);
                                allArgs.add(inputFilesPath);
                            }
                        }
                    }
                } catch(Exception e){
                    context.log(USER_ID + ": PPIXpressServlet: Fail to retrieve uploaded expression files. ERROR:\n" + e);
                }
                
                // Set number of expression files
                NO_EXPRESSION_FILE = Integer.parseInt(request.getParameter("NO_EXPRESSION_FILE"));
                context.log(USER_ID + ": PPIXpressServlet: User-defined process initiated from Servlet\n" + allArgs);
            } catch(Exception e){
                context.log(USER_ID + ": PPIXpressServlet: Fail to initiate user-defined run\n" + e);
            }
           
        }

        // Store and show to screen uploaded files
        allArgs.addAll(List.of(request.getParameterValues("PPIOptions")));
        allArgs.addAll(List.of(request.getParameterValues("ExpOptions")));
        allArgs.addAll(List.of(request.getParameterValues("RunOptions")));
        allArgs.add(request.getParameter("threshold"));
        allArgs.add(request.getParameter("percentile"));
        allArgs.removeIf(n -> (n.equals("null")));

        // Create and execute PPIXpress and update progress periodically to screen
        // If run example, STOP_SIGNAL is set to true so that no process is initiated. The outcome has been pre-analyzed
        AtomicBoolean STOP_SIGNAL = SUBMIT_TYPE.equals("RunNormal") ? new AtomicBoolean(false) : new AtomicBoolean(true);
        request.getSession().setAttribute("PROGRAM", "PPIXpress");
        request.getSession().setAttribute("NO_EXPRESSION_FILE", NO_EXPRESSION_FILE);
        request.getSession().setAttribute("LONG_PROCESS_SIGNAL", STOP_SIGNAL);
        request.getSession().setAttribute("LOCAL_STORAGE_PATH", LOCAL_STORAGE_PATH);

        LongRunningProcess myThreads = new LongRunningProcess(allArgs, STOP_SIGNAL);
        Thread lrp = new Thread(myThreads);
        lrp.start();   
    }

    public static void main(String[] args) throws IOException {
    }
}

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

import standalone_tools.PPICompare_Tomcat;

@WebServlet(name = "PPICompare", value = "/PPICompare")
@MultipartConfig()

public class PPICompareServlet extends HttpServlet {
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
        // private final PPICompare_Tomcat pipeline = new PPICompare_Tomcat();
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
                    PPICompare_Tomcat.runAnalysis(this.argList, stopSignal);
                    if (stopSignal.get()) {
                        setStop(true);
                        }
                    }
                } catch(Exception e){
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
    private String GROUP1_PATH;
    private String GROUP2_PATH;
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
            log("PPICompare is running");
            try {
                // Define a data local storage on the local server
                LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/example_run/PPICompare/"; 
                INPUT_PATH = LOCAL_STORAGE_PATH + "INPUT/";
                OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
                GROUP1_PATH = INPUT_PATH + "HSC/";
                GROUP2_PATH = INPUT_PATH + "MPP/";

                // Add path to input protein network to arguments set
                allArgs.add(GROUP1_PATH);
                allArgs.add(GROUP2_PATH);

                // Add output path to arguments set
                allArgs.add(OUTPUT_PATH);

                context.log(USER_ID + ": PPICompareServlet: Example process initiated from Servlet\n" + allArgs);
            }
             catch(Exception e){
                context.log(USER_ID + ": PPICompareServlet: Fail to initiate example run\n" + e);
             }
        } 
        else if (SUBMIT_TYPE.equals("RunNormal")) {
            try {
                // Define a data local storage on the local server
                LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/uploads/" + USER_ID + "/PPICompare/"; 

                // Create input directory
                Utils.createUserDir(LOCAL_STORAGE_PATH); 
                INPUT_PATH = LOCAL_STORAGE_PATH + "INPUT/";
                OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
                

                // Add paths to expression data to argument list. Meanwhile, store user's PPI
                // network (if uploaded) and expression data to a local storage on server
                try {
                    for (Part part : request.getParts()) {
                        String fileType = part.getName();
                        String fileName = part.getSubmittedFileName();

                        if (fileName != null && !fileName.equals("")) {
                            if (fileType.startsWith("PPIXpress_network_")) {
                                String inputFilesPath = INPUT_PATH + fileName.substring(fileName.lastIndexOf("\\") + 1);
                                UtilsServlet.writeOutputStream(part, inputFilesPath);
                                inputFilesPath = Utils.UnzipFile(inputFilesPath) + '/'; //Extract zip file and remove extension
                                allArgs.add(inputFilesPath);
                            }
                        }
                    }
                }
                catch(Exception e){
                    context.log(USER_ID + ": PPICompareServlet: Fail to retrieve uploaded expression files. ERROR:\n" + e);
                }
                // Add output path to arguments set
                allArgs.add(OUTPUT_PATH);

                context.log(USER_ID + ": PPICompareServlet: User-defined process initiated from Servlet\n" + allArgs);
            }
            catch(Exception e){
                context.log(USER_ID + ": PPICompareServlet: Fail to initiate user-defined run\n" + e);
            }
           
        }

        // Store and show to screen uploaded files
        allArgs.addAll(List.of(request.getParameterValues("RunOptions")));
        allArgs.add(request.getParameter("fdr"));
        allArgs.remove(null);

        // Create and execute PPICompare and update progress periodically to screen
        // // If run example, STOP_SIGNAL is set to true so that no process is initiated. The outcome has been pre-analyzed
        // AtomicBoolean STOP_SIGNAL = SUBMIT_TYPE.equals("RunNormal") ? new AtomicBoolean(false) : new AtomicBoolean(true);
        AtomicBoolean STOP_SIGNAL = new AtomicBoolean(false);
        request.getSession().setAttribute("PROGRAM", "PPICompare");
        request.getSession().setAttribute("LONG_PROCESS_SIGNAL", STOP_SIGNAL);
        request.getSession().setAttribute("LOCAL_STORAGE_PATH", LOCAL_STORAGE_PATH);
       
        LongRunningProcess myThreads = new LongRunningProcess(allArgs, STOP_SIGNAL);
        Thread lrp = new Thread(myThreads);
        lrp.start();   
    }

    public static void main(String[] args) throws IOException {
    }
}

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
    protected static ServletContext context;
    protected String USER_ID;
    protected String LOCAL_STORAGE_PATH;
    protected String INPUT_PATH;
    protected String OUTPUT_PATH;
    protected String GROUP1_PATH;
    protected String GROUP2_PATH;
    String SUBMIT_TYPE;
    List<String> allArgs;


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
        private AtomicBoolean stopSignal;
        // private final PPICompare_Tomcat pipeline = new PPICompare_Tomcat();
        private volatile boolean stop;
        private List<String> argList;

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


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Main pipeline
        response.setContentType("text/html");

        // Store uploaded files outside webapp deploy folders (LOCAL_STORAGE_PATH) and
        // output.zip inside deploy folder (WEBAPP_PATH)
        USER_ID = UUID.randomUUID().toString();
        allArgs = new ArrayList<>();
        SUBMIT_TYPE = request.getParameter("SUBMIT_TYPE");
        

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
                allArgs.add("-group_1=" + GROUP1_PATH);
                allArgs.add("-group_2=" + GROUP2_PATH);

                // Add output path to arguments set
                allArgs.add("-output=" + OUTPUT_PATH);
                allArgs.add("-fdr=0.05");

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
                    int group_i = 1;
                    for (Part part : request.getParts()) {
                        String fileType = part.getName();
                        String fileName = part.getSubmittedFileName();

                        if (fileName != null && !fileName.equals("")) {
                            if (fileType.startsWith("PPIXpress_network")) {
                                String inputFilesPath = INPUT_PATH + fileName.substring(fileName.lastIndexOf("\\") + 1);
                                UtilsServlet.writeOutputStream(part, inputFilesPath);
                                inputFilesPath = Utils.UnzipFile(inputFilesPath) + '/'; //Extract zip file and remove extension
                                allArgs.add("-group_" + group_i + "=" + inputFilesPath);
                                group_i+=1;
                            }
                        }
                    }
                }
                catch(Exception e){
                    context.log(USER_ID + ": PPICompareServlet: Fail to retrieve uploaded PPIXpress networks. ERROR:\n" + e);
                }
                // Add output path to arguments set
                allArgs.add("-output=" + OUTPUT_PATH);


                 // Store and show to screen uploaded files
                allArgs.addAll(List.of(request.getParameterValues("RunOptions")));
                allArgs.add(request.getParameter("fdr"));
                allArgs.remove(null);

                context.log(USER_ID + ": PPICompareServlet: User-defined process initiated from Servlet\n" + allArgs);

            }
            catch(Exception e){
                context.log(USER_ID + ": PPICompareServlet: Fail to initiate user-defined run\n" + e);
            }  
        }
        try {
            // Create and execute PPICompare and update progress periodically to screen
            // If run example, STOP_SIGNAL is set to true so that no process is initiated. The outcome has been pre-analyzed
            AtomicBoolean STOP_SIGNAL = SUBMIT_TYPE.equals("RunNormal") ? new AtomicBoolean(false) : new AtomicBoolean(true);
            request.getSession().setAttribute("PROGRAM", "PPICompare");
            request.getSession().setAttribute("LONG_PROCESS_STOP_SIGNAL", STOP_SIGNAL);
            request.getSession().setAttribute("LOCAL_STORAGE_PATH", LOCAL_STORAGE_PATH);
        
            if (SUBMIT_TYPE.equals("RunNormal")) {
                LongRunningProcess myThreads = new LongRunningProcess(allArgs, STOP_SIGNAL);
                Thread lrp = new Thread(myThreads);
                lrp.start();   
            }
        } catch (Exception e) {
            context.log(USER_ID + ": PPICompareServlet: Fail to initialize PPICompare process.\n" + e);
        }
    } 

    public static void main(String[] args) throws IOException {
    }
}

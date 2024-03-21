package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.JSONObject;

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
    ArrayList<String> allArgs;
    static AtomicBoolean STOP_SIGNAL = new AtomicBoolean(false);
    protected JSONObject POSTData = new JSONObject();


    /**
     * Initilize ServletContext log to localhost log files
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        context = getServletContext();
    }


    /**
     * A long-running process that runs the analysis pipeline in a separate thread.
     */
    static class LongRunningProcess implements Runnable {
        private AtomicBoolean stopSignal;
        // private final PPICompare_Tomcat pipeline = new PPICompare_Tomcat();
        private volatile boolean stop;
        private List<String> argList;


        /**
         * Constructs a LongRunningProcess object with PPICompare arguments
         *
         * @param allArgs the list of arguments for the analysis pipeline
         * @param stopSignal the stop signal to indicate when the pipeline should stop
         */

        public LongRunningProcess(List<String> allArgs, AtomicBoolean stopSignal) {
            this.stopSignal = stopSignal;
            this.argList = allArgs;
        }

        /**
         * Runs the analysis pipeline in a separate thread.
         * This method continuously runs the analysis pipeline until the stop signal is received.
         * If the stop signal is received, it sets the stop flag to true, indicating that the pipeline should stop.
         */
        @Override
        public void run() {
            try {
                while (!stop) {
                    PPICompare_Tomcat.runAnalysis(this.argList, stopSignal);
                    if (stopSignal.get()) {
                        context.log("PPICompare pipeline is finished!");
                        setStop(true);
                    }
                }
            } catch(Exception e){
                context.log(e.toString());
            }
        }

        /**
         * Gets the stop flag value.
         *
         * @return true if the pipeline should stop, false otherwise
         */
        public boolean getStop() {
            return stop;
        }


        /**
         * Sets the stop flag value.
         *
         * @param stop the stop flag value to set
         */
        public void setStop(boolean stop) {
            this.stop = stop;
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Main pipeline
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Store uploaded files outside webapp deploy folders (LOCAL_STORAGE_PATH) and
        // output.zip inside deploy folder (WEBAPP_PATH)
        USER_ID = request.getParameter("USER_ID");
        allArgs = new ArrayList<String>();
        SUBMIT_TYPE = request.getParameter("SUBMIT_TYPE");
        

        if (SUBMIT_TYPE.equals("RunExample")) {
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
                context.log(USER_ID + ": PPICompareServlet: Fail to initiate example run\n" + e.toString());
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
                                inputFilesPath = Utils.UnzipFile(inputFilesPath, "group_" + group_i, ".") + '/'; //Extract zip file and remove extension
                                allArgs.add("-group_" + group_i + "=" + inputFilesPath);
                                group_i+=1;
                            }
                        }
                    }
                }
                catch(Exception e){
                    context.log(USER_ID + ": PPICompareServlet: Fail to retrieve uploaded PPIXpress networks. ERROR:\n" + e.toString());
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
                context.log(USER_ID + ": PPICompareServlet: Fail to initiate user-defined run\n" + e.toString());
            }  
        }
        try {
            // Create and execute PPICompare and update progress periodically to screen
            // If run example, STOP_SIGNAL is set to true so that no process is initiated. The outcome has been pre-analyzed
            STOP_SIGNAL = SUBMIT_TYPE.equals("RunNormal") ? new AtomicBoolean(false) : new AtomicBoolean(true);
            
            // Send Servlet response to PPICompare_functionality.js:$.fn.submit_form. This response is used as request for 
            // ProgressReporter.java in PPICompare_functionality.js:updateLongRunningStatus.
            // Very important as the essential parameters for run/update progress are communicated between this 
            // servlet, PPICompare_functionality.js and ProgressReporter.java 
            POSTData.put("USER_ID", USER_ID);
            POSTData.put("PROGRAM", "PPICompare");
            POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", "");
            POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", STOP_SIGNAL);
            out.println(POSTData);
            
            // Run PPICompare
            if (SUBMIT_TYPE.equals("RunNormal")) {
                LongRunningProcess myThreads = new LongRunningProcess(allArgs, STOP_SIGNAL);
                Thread lrp = new Thread(myThreads);
                lrp.start();   
            }
        } catch (Exception e) {
            context.log(USER_ID + ": PPICompareServlet: Fail to initialize PPICompare process.\n" + e.toString());
        }
    } 

    public static void main(String[] args) throws IOException {
    }
}

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import org.json.JSONObject;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.FileWriter;

@WebServlet(name = "ProgressReporter", value = "/ProgressReporter")

//TODO When fail these step, do not display "PPIXpress pipeline is finished!""
public class ProgressReporter extends HttpServlet {
        private String PROGRAM;
        private String RUN_PROGRESS_LOG;
        private String LOCAL_STORAGE_PATH;
        private Boolean LONG_PROCESS_SIGNAL;
        private int NO_EXPRESSION_FILE;
        private String USER_ID;
        private ServletContext context;

        /**
         * Initilize ServletContext log to localhost log files
         */
        public void init(ServletConfig config) throws ServletException {
                super.init(config);
                context = getServletContext();
        }

        /**
         * TODO: Documentation
         * 
         * @param str
         * @param fileName
         */
        public static void appendStrToFile(String str, String fileName) {
                try {
                        // Open given file in append mode by creating an
                        // object of BufferedWriter class
                        BufferedWriter out = new BufferedWriter(new FileWriter(fileName, true));

                        // Writing on output stream
                        out.write(str);
                        // Closing the connection
                        out.close();
                }
                // Catch block to handle the exceptions
                catch (IOException e) {

                        // Display message when exception occurs
                        System.out.println("Exception occured in ProgressReporter:appendStrToFile: " + e);
                }
        }

        public void doPost(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                HttpSession session = request.getSession(); 

                try {   
                        // PROGRAM shows if PPIXpress or PPICompare is being called
                        PROGRAM = session.getAttribute("PROGRAM") == null ? ""
                                        : session.getAttribute("PROGRAM").toString();

                        // LONG_PROCESS_SIGNAL is a boolean value where "true" will stop PPIXpress process from standalone_tools:PPIXpress
                        // and "false" keeps the process running. At the end of the process, LONG_PROCESS_SIGNAL is switched to true
                        LONG_PROCESS_SIGNAL = session.getAttribute("LONG_PROCESS_SIGNAL") == null ||
                                        Boolean.parseBoolean(session.getAttribute("LONG_PROCESS_SIGNAL").toString());

                        // LOCAL_STORAGE_PATH is the path to the folder where INPUT and OUTPUT are stored for each user/example run
                        LOCAL_STORAGE_PATH = session.getAttribute("LOCAL_STORAGE_PATH") == null ? ""
                                        : session.getAttribute("LOCAL_STORAGE_PATH").toString();
                        String[] splitPath = LOCAL_STORAGE_PATH.split("/");
                        USER_ID = splitPath[splitPath.length - 1];
                        context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS\n" + LOCAL_STORAGE_PATH);
                        
                        // Get the process log stored in "/OUTPUT/PPIXpress_log.html". Log is updated by the process from standalone_tools:PPIXpress or PPIXCompare
                        //The file name must be the same as defined for log_file in PPICompare_Tomcat.java or PPIXpress_Tomcat.java
                        String RUN_PROGRESS_LOG_PATH = LOCAL_STORAGE_PATH + "/OUTPUT/LogFile.html"; 
                        RUN_PROGRESS_LOG = Files.readString(Paths.get(RUN_PROGRESS_LOG_PATH));
                } catch (IOException e) {
                        LONG_PROCESS_SIGNAL = true;
                        context.log(USER_ID + ": ProgressReporter: Fail to retrieve log file. ERROR:\n" + e);
                }


                if (PROGRAM.equals("PPICompare")){
                        context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS\n" + LOCAL_STORAGE_PATH);
                }
                else if (PROGRAM.equals("PPIXpress")){
                        NO_EXPRESSION_FILE = session.getAttribute("NO_EXPRESSION_FILE") == null ? 0
                                                : (int) session.getAttribute("NO_EXPRESSION_FILE");
                        context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS\n" + String.valueOf(NO_EXPRESSION_FILE) + " - "  + LOCAL_STORAGE_PATH);
                }

                // Send response to show on display
                JSONObject POSTData = new JSONObject();
                POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", RUN_PROGRESS_LOG);
                POSTData.put("UPDATE_LONG_PROCESS_SIGNAL", LONG_PROCESS_SIGNAL);
                if (PROGRAM.equals("PPIXpress")){
                        POSTData.put("NO_EXPRESSION_FILE", NO_EXPRESSION_FILE);
                }
                out.println(POSTData);
        }
}

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.*;

@WebServlet(name = "PPIXpressProgressReporter", value = "/PPIXpressProgressReporter")

//TODO When fail these step, do not display "PPIXpress pipeline is finished!""
public class PPIXpressProgressReporter extends HttpServlet {
        protected String PROGRAM;
        protected String RUN_PROGRESS_LOG;
        protected String LOCAL_STORAGE_PATH;
        protected Boolean LONG_PROCESS_STOP_SIGNAL;
        protected int NO_EXPRESSION_FILE;
        protected String USER_ID;
        protected ServletContext context;
        protected JSONObject POSTData = new JSONObject();

        /**
         * Initilize ServletContext log to localhost log files
         */
        public void init(ServletConfig config) throws ServletException {
                super.init(config);
                context = getServletContext();
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
                        // LONG_PROCESS_STOP_SIGNAL is a boolean value where "true" will stop PPIXpress process from standalone_tools:PPIXpress
                        // and "false" keeps the process running. At the end of the process, LONG_PROCESS_STOP_SIGNAL is switched to true
                        LONG_PROCESS_STOP_SIGNAL = session.getAttribute("LONG_PROCESS_STOP_SIGNAL") == null ||
                                        Boolean.parseBoolean(session.getAttribute("LONG_PROCESS_STOP_SIGNAL").toString());
                        
                        // LOCAL_STORAGE_PATH is the path to the folder where INPUT and OUTPUT are stored for each user/example run
                        LOCAL_STORAGE_PATH = session.getAttribute("LOCAL_STORAGE_PATH") == null ? ""
                                        : session.getAttribute("LOCAL_STORAGE_PATH").toString();

                        String[] splitPath = LOCAL_STORAGE_PATH.split("/");
                        USER_ID = splitPath[splitPath.length - 2];

                        
                        // Get the process log stored in "/OUTPUT/PPIXpress_log.html". Log is updated by the process from standalone_tools:PPIXpress or PPIXCompare
                        // The file name must be the same as defined for log_file in PPICompare_Tomcat.java or PPIXpress_Tomcat.java and 
                        // PPICompareServlet and PPIXpressServlet 
                        String RUN_PROGRESS_LOG_PATH = LOCAL_STORAGE_PATH + "/OUTPUT/LogFile.html";
                        Path LOG_FILE = Paths.get(RUN_PROGRESS_LOG_PATH);
                        
                        if (Files.exists(LOG_FILE)){
                                RUN_PROGRESS_LOG = Files.readString(LOG_FILE);
                        }
                        NO_EXPRESSION_FILE = session.getAttribute("NO_EXPRESSION_FILE") == null ? 
                                0 : (int) session.getAttribute("NO_EXPRESSION_FILE");
                        context.log(USER_ID + ": PPIXpressProgressReporter SESSION PARAMETERS\n" + String.valueOf(NO_EXPRESSION_FILE) + " - "  + LOCAL_STORAGE_PATH);
                                        
                        // Send response to show on display
                        
                        POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", RUN_PROGRESS_LOG);
                        POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", LONG_PROCESS_STOP_SIGNAL);
                        POSTData.put("NO_EXPRESSION_FILE", NO_EXPRESSION_FILE);
                        POSTData.put("USER_ID", USER_ID);

                        out.println(POSTData);
                } catch (Exception e) {
                        POSTData.put("USER_ID", USER_ID);
                        POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", true);
                        context.log(USER_ID + ": PPIXpressProgressReporter: ERROR:\n" + e);
                }
        }
}

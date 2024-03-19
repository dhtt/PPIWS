package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.*;

@WebServlet(name = "ProgressReporter", value = "/ProgressReporter")

//TODO When fail these step, do not display "PPIXpress pipeline is finished!""
public class ProgressReporter extends HttpServlet {
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
                
                try {   
                        
                        USER_ID = request.getParameter("USER_ID") == null ? "" : request.getParameter("USER_ID").toString();
                        // LONG_PROCESS_STOP_SIGNAL is a boolean value where "true" will stop PPIXpress process from standalone_tools:PPIXpress
                        // and "false" keeps the process running. At the end of the process, LONG_PROCESS_STOP_SIGNAL is switched to true
                        LONG_PROCESS_STOP_SIGNAL = request.getParameter("LONG_PROCESS_STOP_SIGNAL") == null ||
                                Boolean.parseBoolean(request.getParameter("LONG_PROCESS_STOP_SIGNAL").toString());
                        // PROGRAM shows if PPIXpress or PPICompare is being called
                        PROGRAM = request.getParameter("PROGRAM") == null ? "" : request.getParameter("PROGRAM").toString();

                        // LOCAL_STORAGE_PATH is the path to the folder where INPUT and OUTPUT are stored for each user/example run
                        LOCAL_STORAGE_PATH = USER_ID.equals("example_run") ? 
                                "/home/trang/PPIWS/repository/example_run/PPIXpress/" : "/home/trang/PPIWS/repository/uploads/" + USER_ID + "/PPIXpress/"; 
                
                        // Get the process log stored in "/OUTPUT/PPIXpress_log.html". Log is updated by the process from standalone_tools:PPIXpress or PPIXCompare
                        // The file name must be the same as defined for log_file in PPICompare_Tomcat.java or PPIXpress_Tomcat.java and 
                        // PPICompareServlet and PPIXpressServlet 
                        String RUN_PROGRESS_LOG_PATH = LOCAL_STORAGE_PATH + "/OUTPUT/LogFile.html";
                        Path LOG_FILE = Paths.get(RUN_PROGRESS_LOG_PATH);
                        
                        if (Files.exists(LOG_FILE)){
                                RUN_PROGRESS_LOG = Files.readString(LOG_FILE);
                        }

                        if (PROGRAM.equals("PPICompare")){
                                context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS:\n- PROGRAM: " + PROGRAM + "\n-PATH: " + LOCAL_STORAGE_PATH);
                        } else if (PROGRAM.equals("PPIXpress")){        
                                NO_EXPRESSION_FILE = request.getParameter("NO_EXPRESSION_FILE") == null ? 
                                        0 : Integer.parseInt(request.getParameter("NO_EXPRESSION_FILE"));
                                
                                context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS:\n- PROGRAM: " + PROGRAM + "\n-PATH: " + LOCAL_STORAGE_PATH + "\n-NO_EXP_FILES: " + String.valueOf(NO_EXPRESSION_FILE));
                        }
                   
                        // Send response to show on display
                        POSTData.put("USER_ID", USER_ID);
                        POSTData.put("PROGRAM", "PPIXpress");
                        POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", RUN_PROGRESS_LOG);
                        POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", LONG_PROCESS_STOP_SIGNAL);
                        if (PROGRAM.equals("PPIXpress")){
                                POSTData.put("NO_EXPRESSION_FILE", NO_EXPRESSION_FILE);
                        }

                        out.println(POSTData);
                } catch (Exception e) {
                        POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", true);
                        context.log(USER_ID + ": ProgressReporter: ERROR:\n" + e);
                }
        }
}

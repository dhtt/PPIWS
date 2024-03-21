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
        protected String USER_ID;
        protected String SUBMIT_TYPE;
        protected String RUN_PROGRESS_LOG;
        protected String LOCAL_STORAGE_PATH;
        protected Boolean UPDATE_LONG_PROCESS_STOP_SIGNAL;
        protected int NO_EXPRESSION_FILE;
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
                        // UPDATE_LONG_PROCESS_STOP_SIGNAL is a boolean value where "true" will stop PPIXpress process from standalone_tools:PPIXpress
                        // and "false" keeps the process running. At the end of the process, UPDATE_LONG_PROCESS_STOP_SIGNAL is switched to true

                        // PROGRAM shows if PPIXpress or PPICompare is being called
                        PROGRAM = request.getParameter("PROGRAM") == null ? "" : request.getParameter("PROGRAM").toString();

                        if (PROGRAM.equals("PPIXpress")){   
                                UPDATE_LONG_PROCESS_STOP_SIGNAL = PPIXpressServlet.STOP_SIGNAL.get();
                        } else if (PROGRAM.equals("PPICompare")){
                                UPDATE_LONG_PROCESS_STOP_SIGNAL = PPICompareServlet.STOP_SIGNAL.get();
                        }
                        // UPDATE_LONG_PROCESS_STOP_SIGNAL = request.getParameter("UPDATE_LONG_PROCESS_STOP_SIGNAL") == null ||
                        //         Boolean.parseBoolean(request.getParameter("UPDATE_LONG_PROCESS_STOP_SIGNAL").toString());

                        // LOCAL_STORAGE_PATH is the path to the folder where INPUT and OUTPUT are stored for each user/example run
                        LOCAL_STORAGE_PATH = USER_ID.equals("EXAMPLE_USER") ? 
                                "/home/trang/PPIWS/repository/example_run/" + PROGRAM + "/" : "/home/trang/PPIWS/repository/uploads/" + USER_ID + "/" + PROGRAM + "/"; 

                        // Get the process log stored in "/OUTPUT/PPIXpress_log.html". Log is updated by the process from standalone_tools:PPIXpress or PPIXCompare
                        // The file name must be the same as defined for log_file in PPICompare_Tomcat.java or PPIXpress_Tomcat.java and 
                        // PPICompareServlet and PPIXpressServlet 
                        String RUN_PROGRESS_LOG_PATH = LOCAL_STORAGE_PATH + "/OUTPUT/LogFile.html";
                        Path LOG_FILE = Paths.get(RUN_PROGRESS_LOG_PATH);
                        
                        if (Files.exists(LOG_FILE)){
                                RUN_PROGRESS_LOG = Files.readString(LOG_FILE);
                        }

                        if (PROGRAM.equals("PPIXpress")){
                                NO_EXPRESSION_FILE = request.getParameter("NO_EXPRESSION_FILE") == null ? 
                                        0 : Integer.parseInt(request.getParameter("NO_EXPRESSION_FILE"));
                        
                                context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS:\n-PROGRAM: " + PROGRAM + 
                                        "\n-PATH: " + LOCAL_STORAGE_PATH + 
                                        "\n-NO_EXP_FILES: " + String.valueOf(NO_EXPRESSION_FILE) +
                                        "\n-STOP_SIGNAL: " + UPDATE_LONG_PROCESS_STOP_SIGNAL);
                        } else if (PROGRAM.equals("PPICompare")){
                                context.log(USER_ID + ": ProgressReporter SESSION PARAMETERS:\n-PROGRAM: " + PROGRAM + 
                                        "\n-PATH: " + LOCAL_STORAGE_PATH +
                                        "\n-STOP_SIGNAL: " + UPDATE_LONG_PROCESS_STOP_SIGNAL);
                        }
                   
                        // Send response to show on display
                        POSTData.put("USER_ID", USER_ID);
                        POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", RUN_PROGRESS_LOG);
                        POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", UPDATE_LONG_PROCESS_STOP_SIGNAL);
                        if (PROGRAM.equals("PPIXpress")){
                                POSTData.put("PROGRAM", "PPIXpress");
                                POSTData.put("NO_EXPRESSION_FILE", NO_EXPRESSION_FILE);
                        } else if (PROGRAM.equals("PPICompare")) {
                                POSTData.put("PROGRAM", "PPICompare");
                        }

                        out.println(POSTData);
                } catch (Exception e) {
                        POSTData.put("UPDATE_LONG_PROCESS_STOP_SIGNAL", true);
                        context.log(USER_ID + ": ProgressReporter: ERROR:\n" + e.toString());
                }
        }
}

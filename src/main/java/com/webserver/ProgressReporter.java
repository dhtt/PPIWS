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
        private String runProgress;
        private String USER_ID;
        private Boolean stopSignal;
        private int no_expression_file;
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
                        stopSignal = session.getAttribute("LONG_PROCESS_SIGNAL") == null ||
                                        Boolean.parseBoolean(session.getAttribute("LONG_PROCESS_SIGNAL").toString());
                        no_expression_file = session.getAttribute("no_expression_file") == null ? 0
                                        : (int) session.getAttribute("no_expression_file");
                        USER_ID = session.getAttribute("LONG_PROCESS_ID") == null ? ""
                                        : session.getAttribute("LONG_PROCESS_ID").toString();

                        String LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/uploads/" + USER_ID
                                        + "/OUTPUT/PPIXpress_log.html";
                        runProgress = Files.readString(Paths.get(LOCAL_STORAGE_PATH));
                } catch (IOException e) {
                        stopSignal = true;
                        context.log(USER_ID + ": ProgressReporter: Fail to retrieve log file. Check error message:\n" + e);
                }

                // Send response to show on display
                JSONObject POSTData = new JSONObject();
                POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", runProgress);
                POSTData.put("UPDATE_LONG_PROCESS_SIGNAL", stopSignal);
                POSTData.put("NO_EXPRESSION_FILE", no_expression_file);
                out.println(POSTData);
        }
}

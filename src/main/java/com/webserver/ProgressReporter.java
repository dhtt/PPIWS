package com.webserver;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ProgressReporter", value = "/ProgressReporter")

public class ProgressReporter extends HttpServlet {
    public void doPost(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        String runProgress = session.getAttribute("LONG_PROCESS_MESSAGE") == null ?
                "" : session.getAttribute("LONG_PROCESS_MESSAGE").toString();
        Boolean stopSignal = session.getAttribute("LONG_PROCESS_SIGNAL") == null ||
                Boolean.parseBoolean(session.getAttribute("LONG_PROCESS_SIGNAL").toString());
        int no_expression_file = session.getAttribute("no_expression_file") == null ?
                0 : (int) session.getAttribute("no_expression_file");

        JSONObject POSTData = new JSONObject();

        POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", runProgress);
        POSTData.put("UPDATE_LONG_PROCESS_SIGNAL", stopSignal);
        POSTData.put("NO_EXPRESSION_FILE", no_expression_file);
        out.println(POSTData);
    }
}

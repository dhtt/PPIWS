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
        String runProgress = session.getAttribute("LONG_PROCESS_MESSAGE").toString();
        Boolean stopSignal = Boolean.valueOf(session.getAttribute("LONG_PROCESS_SIGNAL").toString());
        JSONObject POSTData = new JSONObject();

        POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", runProgress);
        POSTData.put("UPDATE_LONG_PROCESS_SIGNAL", stopSignal);
        out.println(POSTData);
    }
}

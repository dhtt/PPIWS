package com.webserver;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ProgressReporter", value = "/ProgressReporter")
public class ProgressReporter extends HttpServlet {
    public void doPost(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        String settingMessage = session.getAttribute("STATIC_PROGRESS_MESSAGE").toString();
        String runProgress = "<ul>" + session.getAttribute("LONG_PROCESS_MESSAGE").toString() + "</ul>";
        Boolean stopSignal = Boolean.valueOf(session.getAttribute("LONG_PROCESS_SIGNAL").toString());
        JSONObject POSTData = new JSONObject();

        POSTData.put("UPDATE_STATIC_PROGRESS_MESSAGE", settingMessage);
        POSTData.put("UPDATE_LONG_PROCESS_MESSAGE", runProgress);
        POSTData.put("UPDATE_LONG_PROCESS_SIGNAL", stopSignal);
        out.println(POSTData);
    }
}

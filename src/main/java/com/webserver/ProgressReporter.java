package com.webserver;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Dictionary;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProgressReporter", value = "/ProgressReporter")
public class ProgressReporter extends HttpServlet {
    public static void printList(PrintWriter out, String[] list){
        for (String i : list) out.println(i + "<br>");
    }

    public void doPost(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h4>| Running PPIXpress with example data...</h4>");
        out.println("<a href='header.html'>Inspect/Download example data</a><br><br>");

        out.println("<h4>| Parsing PPIXpress options... </h4>");
        String[] parsedArgs = (String[]) request.getSession().getAttribute("PARSED_ARGS");
        if (parsedArgs != null){
            printList(out, parsedArgs);
        }

        out.println("<br><h4>| Executing PPIXpress... </h4>");
//        out.println(request.getSession().getAttribute("LONG_RUNNING_PROCESS_STATUS"));
        out.println(request.getSession().getAttribute("LONG_RUNNING_PROCESS_MESSAGE"));

    }
}

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.*;
import java.util.stream.Stream;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    protected void printList(PrintWriter out, String[] list){
        for (String i : list){
            if (!Objects.equals(i, "null")) out.println(i + "<br>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PPIXpressRun pipeline = new PPIXpressRun();

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String submit_type = request.getParameter("submitType");
        if (submit_type.equals("RunExample")) {
            String[] args = {"-w", "-u", "-t=0.3"};

            out.println("<h4>| Running PPIXpress with example data...</h4>");
            out.println("<a href='header.html'>Inspect/Download example data</a><br><br>");
            out.println("<h4>| Parsing PPIXpress options... </h4>");
            pipeline.parseArgs(args);
            printList(out, pipeline.getArgs());
            out.println("<br><h4>| Executing PPIXpress... </h4>");
            pipeline.runAnalysis();
        }
        else if (submit_type.equals("RunNormal")){
            out.println("<h4>Data submitted!<br><br>Uploaded files:</h4>");
//        Show uploaded files
            for (Part part : request.getParts()) {
                if (part.getSubmittedFileName() != null) {
                    out.println(part.getName() + ": " + part.getSubmittedFileName() + "<br>");
                }
            }
//            Show run options
            String[] PPI_Options = request.getParameterValues("PPIOptions");
            String[] Exp_Options = request.getParameterValues("ExpOptions");
            String[] Run_Options = request.getParameterValues("RunOptions");
            String[] numericInput = {request.getParameter("threshold")}; //TODO: Add percentile adjustment
            out.println("<br><h4>| Parsing PPIXpress options... </h4>");
            pipeline.parseArgs(PPI_Options, Exp_Options, Run_Options, numericInput);
            printList(out, pipeline.getArgs());
            out.println("<br><h4>| Executing PPIXpress... </h4>");
        }
    }
    public static void main(String[] args){
    }
}

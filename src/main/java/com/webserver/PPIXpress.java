package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.Iterator;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()
public class PPIXpress extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("Data submitted! Now running PPIXpress from Servlet...<br>");
        String[] PPI_Options = request.getParameterValues("PPIOptions");
        for (String i:PPI_Options){
            out.println(i + "<br>");
        }
//        Part protein_network_file = request.getPart("protein_network_file");
//        out.println("File name: " + protein_network_file.getSubmittedFileName());
//        out.println("To result page");
//        String[] PPIOptions = request.getParameterValues("PPIOptions");
//        for (String i:PPIOptions){
//            out.println(i + "<br>");
//        }
//        String PPI_options = request.getParameter("PPIOptions");
//        String Exp_options = request.getParameter("ExpOptions");
//        String Run_options = request.getParameter("RunOptions");
//        out.printf("%s<br>%s<br>%s<br>%s", PPI_options, Exp_options, Run_options);
    }
//    RunAnalysis()
    public static void main(String[] args){
    }
}

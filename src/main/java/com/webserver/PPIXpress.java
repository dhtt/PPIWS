package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.Objects;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpress extends HttpServlet {
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
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h4>Data submitted!<br><br>Uploaded files:</h4>");
//        Show uploaded files
        for (Part part : request.getParts()) {
            if (part.getSubmittedFileName() != null) {
                out.println(part.getName() + ": " + part.getSubmittedFileName() + "<br>");
            }
        }

//        Show run options
        String[] PPI_Options = request.getParameterValues("PPIOptions");
        out.println("<br><h4> PPI Options </h4>");
        printList(out, PPI_Options);

        String[] Exp_Options = request.getParameterValues("ExpOptions");
        out.println("<br><h4> Exp Options </h4>");
        printList(out, Exp_Options);

        String[] Run_Options = request.getParameterValues("RunOptions");
        out.println("<br><h4> Run Options </h4>");
        printList(out, Run_Options);

//        Show run options
        out.println("<br><h4>Begin PPIXpress from Servlet...</h4><br>");
        out.println(".<br>..<br>..<br>");
        out.println("<a href='header.html'>Show me the result!</a><br>");

//        Run PPIXpress

    }
    public static void main(String[] args){
    }
}

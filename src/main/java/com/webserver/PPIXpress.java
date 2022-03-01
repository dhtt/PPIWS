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

        Part filePart = request.getPart("file");
        out.println(filePart.getName());
        out.println(filePart.getSubmittedFileName());
        out.println(filePart.getContentType());
    }

    public static void main(String[] args){

    }
}

package com.webserver;

import java.io.*;
import jakarta.servlet.http.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class UtilsServlet extends HttpServlet {

    /**
     * Write a file part from JSP request to a local file to store on server
     * 
     * @param filePart_ file part from request
     * @param filePath_ path to store file
     */
    static void writeOutputStream(Part filePart_, String filePath_) {
        try (InputStream in = filePart_.getInputStream();
                OutputStream out = Files.newOutputStream(Paths.get(filePath_))) {
            in.transferTo(out);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}

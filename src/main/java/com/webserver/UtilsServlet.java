package com.webserver;

import java.io.*;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class UtilsServlet extends HttpServlet {
    /**
     * Writes the contents of a file to the servlet response output stream.
     *
     * @param response_ The HttpServletResponse object representing the response to be sent back to the client.
     * @param OutputFilePath The path of the file to be written to the response output stream.
     */
    public static void writeFile(HttpServletResponse response_, String OutputFilePath) {
        File outputFile = new File(OutputFilePath);
        // Do not set the response headers. Source: https://stackoverflow.com/a/14385142
        // response_.setContentLength((int) outputFile.length());

        try {
            FileInputStream InStream = new FileInputStream(outputFile);
            try (BufferedInputStream BufInStream = new BufferedInputStream(InStream)) {
                ServletOutputStream ServletOutStream = response_.getOutputStream();
                int readBytes = 0;

                // read from the file; write to the ServletOutputStream
                while ((readBytes = BufInStream.read()) != -1) {
                    ServletOutStream.write(readBytes);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

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

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static com.webserver.Utils.filterProtein;

@WebServlet(name = "DownloadServlet", value = "/DownloadServlet")
@MultipartConfig()

public class DownloadServlet extends HttpServlet {
    /**
     * Zip output files in the result folder
     * @param sourceDirPath_ path to folder to be zipped
     * @param zipPath_ path to zipped folder
     * @throws IOException
     * Source: https://stackoverflow.com/a/68439125/9798960
     */
    public static void zip(String sourceDirPath_, String zipPath_) throws IOException {
        Files.deleteIfExists(Paths.get(zipPath_));
        Path zipFile = Files.createFile(Paths.get(zipPath_));

        Path sourceDirPath = Paths.get(sourceDirPath_);
        try (
                ZipOutputStream zipOutputStream = new ZipOutputStream(Files.newOutputStream(zipFile));
                Stream<Path> paths = Files.walk(sourceDirPath)
        ) {
            paths
                    .filter(path -> !Files.isDirectory(path))
                    .forEach(path -> {
                        if (path.toString().endsWith(".gz") || path.toString().endsWith(".txt")){
                            ZipEntry zipEntry = new ZipEntry(sourceDirPath.relativize(path).toString());
                            try {
                                zipOutputStream.putNextEntry(zipEntry);
                                Files.copy(path, zipOutputStream);
                                zipOutputStream.closeEntry();
                            } catch (IOException e) {
                                System.out.println(e.getMessage());
                            }
                        }
                    });
            zipOutputStream.finish();
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String USER_ID = "USER_1/"; // Each user has their own ID
        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/" + USER_ID + "OUTPUT/"; // Define a data local storage on the local server

        String OUTPUT_FILENAME = "PPIXPress_Output.zip";
        String SAMPLE_FILENAME = "sample_table.html";

        String resultFileType = request.getParameter("resultFileType");
        PrintWriter out = response.getWriter();

        switch (resultFileType) {
            case "output":
                response.setHeader("Content-Disposition", "attachment; filename=\"" + OUTPUT_FILENAME + "\"");
                response.setContentType("application/zip");
                response.setHeader("Cache-Control", "max-age=60");
                response.setHeader("Cache-Control", "must-revalidate");

                try {
                    zip(LOCAL_STORAGE_PATH, LOCAL_STORAGE_PATH + OUTPUT_FILENAME);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                File outputFile = new File(LOCAL_STORAGE_PATH + OUTPUT_FILENAME);
                response.setContentLength((int) outputFile.length());

                FileInputStream InStream = new FileInputStream(outputFile);
                BufferedInputStream BufInStream = new BufferedInputStream(InStream);
                ServletOutputStream ServletOutStream = response.getOutputStream();
                int readBytes = 0;

                //read from the file; write to the ServletOutputStream
                while ((readBytes = BufInStream.read()) != -1) {
                    ServletOutStream.write(readBytes);
                }
                break;

            case "sample_summary":
                File HTMLText = new File(LOCAL_STORAGE_PATH + SAMPLE_FILENAME);
                Scanner file = new Scanner(HTMLText);
                while (file.hasNext()) {
                    String s = file.nextLine();
                    out.println(s);
                }
                break;

            case "graph":
                String proteinQuery = request.getParameter("proteinQuery");
                String expressionQuery = request.getParameter("expressionQuery");

                JSONArray subNetworkData = filterProtein(LOCAL_STORAGE_PATH, proteinQuery, expressionQuery);
                out.println(subNetworkData);
                break;
        }

    }
}

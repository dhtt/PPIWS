package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static com.webserver.Utils.*;
import static standalone_tools.PPIXpress_Tomcat.createElement;

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

    public static void writeFile(HttpServletResponse response_, String OutputFilePath){
        File outputFile = new File(OutputFilePath);
        response_.setContentLength((int) outputFile.length());

        try {
            FileInputStream InStream = new FileInputStream(outputFile);
            BufferedInputStream BufInStream = new BufferedInputStream(InStream);
            ServletOutputStream ServletOutStream = response_.getOutputStream();
            int readBytes = 0;

            //read from the file; write to the ServletOutputStream
            while ((readBytes = BufInStream.read()) != -1) {
                ServletOutStream.write(readBytes);
            }
        }
        catch(Exception e){
            System.out.println(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String USER_ID = "USER_TEST/"; // Each user has their own ID
        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/" + USER_ID + "OUTPUT/"; // Define a data local storage on the local server

        String OUTPUT_FILENAME = "PPIXPress_Output.zip";
        String SAMPLE_FILENAME = "sample_table.html";
        String SUBNETWORK_FILENAME = "subnetwork.png";

        String resultFileType = request.getParameter("resultFileType");
        PrintWriter out;

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

                writeFile(response, LOCAL_STORAGE_PATH + OUTPUT_FILENAME);
//                File outputFile = new File(LOCAL_STORAGE_PATH + OUTPUT_FILENAME);
//                response.setContentLength((int) outputFile.length());
//
//                try {
//                    FileInputStream InStream = new FileInputStream(outputFile);
//                    BufferedInputStream BufInStream = new BufferedInputStream(InStream);
//                    ServletOutputStream ServletOutStream = response.getOutputStream();
//                    int readBytes = 0;
//
//                    //read from the file; write to the ServletOutputStream
//                    while ((readBytes = BufInStream.read()) != -1) {
//                        ServletOutStream.write(readBytes);
//                    }
//                }
//                catch(Exception e){
//                    System.out.println(e.getMessage());
//                }

                break;
/*
            case "subnetwork":
                response.setHeader("Content-Disposition", "attachment; filename=\"" + OUTPUT_FILENAME + "\"");
                response.setContentType("img/png");
                response.setHeader("Cache-Control", "max-age=60");
                response.setHeader("Cache-Control", "must-revalidate");
                writeFile(response, LOCAL_STORAGE_PATH + SUBNETWORK_FILENAME);
                break;*/

            case "sample_summary":
                out = response.getWriter();
                File HTMLText = new File(LOCAL_STORAGE_PATH + SAMPLE_FILENAME);
                Scanner file = new Scanner(HTMLText);

                while (file.hasNext()) {
                    String s = file.nextLine();
                    out.println(s);
                }
                break;

            case "graph":
                out = response.getWriter();
                String proteinQuery = request.getParameter("proteinQuery");
                String expressionQuery = request.getParameter("expressionQuery");
                boolean showDDIs = true;

                JSONArray subNetworkData = filterProtein(LOCAL_STORAGE_PATH, proteinQuery, expressionQuery, showDDIs);
                out.println(subNetworkData);
                break;

            case "protein_list":
                out = response.getWriter();
                Scanner s = new Scanner(new File(LOCAL_STORAGE_PATH + "protein_list.txt"));
                ArrayList<String> proteinList = new ArrayList<>();
                while (s.hasNext()){
                    proteinList.add(createElement("option", s.next()));
                }
                out.println(String.join("", proteinList));
                break;
        }

    }
}

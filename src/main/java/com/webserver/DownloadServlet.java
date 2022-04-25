package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

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
                            System.out.println("IS RESULT" + path);
                            ZipEntry zipEntry = new ZipEntry(sourceDirPath.relativize(path).toString());
                            try {
                                zipOutputStream.putNextEntry(zipEntry);
                                Files.copy(path, zipOutputStream);
                                zipOutputStream.closeEntry();
                            } catch (IOException e) {
                                System.out.println(e.getMessage());
                            }
                        }
                        else {
                            System.out.println("NOT RESULT" + path);
                        }
                    });
            zipOutputStream.finish();
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String USER_ID = "USER_1/"; // Each user has their own ID
        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/" + USER_ID; // Define a data local storage on the local server

        String OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
        String FILE_NAME = "PPIXPress_Output.zip";
        String FILE_PATH = OUTPUT_PATH + FILE_NAME;

        response.setHeader("Content-Disposition","attachment; filename=\"" + FILE_NAME + "\"");
        response.setContentType("application/zip");
        response.setHeader("Cache-Control", "max-age=60");
        response.setHeader("Cache-Control", "must-revalidate");

        try {
            zip(OUTPUT_PATH, FILE_PATH);
        } catch (IOException e) {
            e.printStackTrace();
        }
        File outputFile = new File(OUTPUT_PATH + FILE_NAME);
        response.setContentLength((int) outputFile.length());

        FileInputStream InStream = new FileInputStream(outputFile);
        BufferedInputStream BufInStream = new BufferedInputStream(InStream);
        ServletOutputStream ServletOutStream = response.getOutputStream();
        int readBytes = 0;

        //read from the file; write to the ServletOutputStream
        while ((readBytes = BufInStream.read()) != -1) {
            ServletOutStream.write(readBytes);
        }


//        File HTMLText = new File(URL);
//        Scanner file = new Scanner(HTMLText);
//        while (file.hasNext())
//        {
//            String s = file.nextLine();
//            out.println(s);
//        }
    }
}

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import standalone_tools.PPIXpress_Tomcat;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
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
        try (ZipOutputStream zipOutputStream = new ZipOutputStream(Files.newOutputStream(zipFile));
             Stream<Path> paths = Files.walk(sourceDirPath)) {
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
        }
    }

    /**
     * TODO: Write documentation
     */
    static class LongRunningProcess implements Runnable{
        private final AtomicBoolean stopSignal;
        private final AtomicReference<String> message;
        private final PPIXpress_Tomcat pipeline = new PPIXpress_Tomcat();
        private volatile boolean stop;
        private final String outputPath;
        private final List<String> argList;

        public LongRunningProcess(List<String> allArgs, AtomicBoolean stopSignal, AtomicReference<String> message, String OUTPUT_PATH_) {
            this.stopSignal = stopSignal;
            this.message = message;
            this.argList = allArgs;
            this.outputPath = OUTPUT_PATH_;
        }

        @Override
        public void run() {
            while (!stop){
                pipeline.runAnalysis(this.argList, stopSignal, message);
                if (stopSignal.get()){
                    try {
                        zip(outputPath, outputPath + "PPIXPress_Output.zip");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    setStop(true);
                }
            }
        }

        public boolean getStop(){
            return stop;
        }
        public void setStop(boolean stop){
            this.stop = stop;
        }
    }


    /**
     * Write a file part from JSP request to a local file to store on server
     * @param filePart_ file part from request
     * @param filePath_ path to store file
     */
    static void writeOutputStream(Part filePart_, String filePath_){
        try (InputStream in = filePart_.getInputStream();
             OutputStream out = Files.newOutputStream(Paths.get(filePath_))) {
            in.transferTo(out);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        Main pipeline
//        TODO: Create random number for each user to replace USER_1 then
//        make DIR for LOCAL_STORAGE_PATH/USER_1/INPUT/, LOCAL_STORAGE_PATH/USER_1/OUTPUT/,
//        LOCAL_STORAGE_PATH/USER_1/OUTPUT/GRAPH, WEBAPP_PATH/USER_1


//         Store uploaded files outside webapp deploy folders (LOCAL_STORAGE_PATH) and
//         output.zip inside deploy folder (WEBAPP_PATH)

        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/";
        String USER_ID = "USER_1/";
        String INPUT_PATH = LOCAL_STORAGE_PATH + USER_ID + "INPUT/";
        String FILENAME_PPI = "ppi_data.sif";

        String WEBAPP_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/webapp/USER_DATA/";
        String OUTPUT_PATH = WEBAPP_PATH + USER_ID;

        response.setContentType("text/html");
        String submit_type = request.getParameter("submitType");
        List<String> allArgs = new ArrayList<>();


        if (submit_type.equals("RunExample")) {
        }
        else if (submit_type.equals("RunNormal")) {
//            Add path to protein network to arguments set.
            String taxon_id = request.getParameter("protein_network_web");

//            If taxon = null, use a predefined path to store input PPI
//            network on server, else use taxon to retrieve network from Mentha/IntAct
            String ORIGINAL_NETWORK_PATH = taxon_id.isEmpty() ? INPUT_PATH + FILENAME_PPI : "taxon:" + taxon_id;
            allArgs.add(ORIGINAL_NETWORK_PATH);


//            Add output path to arguments set
            allArgs.add(OUTPUT_PATH);


//            Add paths to expression data to argument list. Meanwhile, store user's PPI network (if uploaded) and
//            expression data to a local storage on server
            for (Part part : request.getParts()){
                String fileType = part.getName();
                String fileName = part.getSubmittedFileName();


                if (fileName != null && !fileName.equals("")){


                    if (fileType.equals("protein_network_file"))
                        writeOutputStream(part, ORIGINAL_NETWORK_PATH);


                    else if (fileType.equals("expression_file")){
                        String input_files_path = INPUT_PATH + fileName.substring(fileName.lastIndexOf("\\")+1);
                        writeOutputStream(part, input_files_path);
                        allArgs.add(input_files_path);
                    }
                }
            }


//            Store and show to screen uploaded files
            allArgs.addAll(List.of(request.getParameterValues("PPIOptions")));
            allArgs.addAll(List.of(request.getParameterValues("ExpOptions")));
            allArgs.addAll(List.of(request.getParameterValues("RunOptions")));
            allArgs.add(request.getParameter("threshold"));
            allArgs.add(request.getParameter("percentile"));
            allArgs.removeIf(n -> (n.equals("null")));
            System.out.println("From Servlet " + allArgs);


//            Create and execute PPIXpress and update progress periodically to screen
            AtomicBoolean stopSignal = new AtomicBoolean(false);
            AtomicReference<String> runProgress = new AtomicReference<String>("");
            request.getSession().setAttribute("LONG_PROCESS_SIGNAL", stopSignal);
            request.getSession().setAttribute("LONG_PROCESS_MESSAGE", runProgress);

            LongRunningProcess myThreads = new LongRunningProcess(allArgs, stopSignal, runProgress, OUTPUT_PATH);
            Thread lrp = new Thread(myThreads);
            lrp.start();
        }
    }
    public static void main(String[] args){
    }
}

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

import standalone_tools.PPIXpress_Tomcat;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {

    /**
     * TODO: Write documentation
     */
    static class LongRunningProcess implements Runnable{
        private final AtomicBoolean stopSignal;
        private final AtomicReference<String> message;
        private final PPIXpress_Tomcat pipeline = new PPIXpress_Tomcat();
        private volatile boolean stop;
        private List<String> argList;

        public LongRunningProcess(List<String> allArgs, AtomicBoolean stopSignal, AtomicReference<String> message) {
            this.stopSignal = stopSignal;
            this.message = message;
            this.argList = allArgs;
        }

        @Override
        public void run() {
            while (!stop){
                pipeline.runAnalysis(this.argList, stopSignal, message);
                if (stopSignal.get()){
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
            long length = in.transferTo(out);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        Main pipeline
        String SOURCE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/";
        String INPUT_PATH = SOURCE_PATH + "input/";
        String FILENAME_PPI = "ppi_data.sif";

        String WEBAPP_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/webapp/";
        String OUTPUT_PATH = WEBAPP_PATH + "output/";
        String LOGFILE_PATH = OUTPUT_PATH + "log.txt";

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
            String ORIGINAL_NETWORK_PATH = taxon_id.equals("null") ? INPUT_PATH + FILENAME_PPI : "taxon:" + taxon_id;
            allArgs.add(ORIGINAL_NETWORK_PATH);


//            Add output path to arguments set
            allArgs.add(OUTPUT_PATH);


//            Add paths to expression data to argument list. Meanwhile, store user's PPI network (if uploaded) and
//            expression data to a local storage on server
            int expression_file_count = 0;
            for (Part part : request.getParts()){
                String fileType = part.getName();
                String fileName = part.getSubmittedFileName();


                if (fileName != null && !fileName.equals("")){


                    if (fileType.equals("protein_network_file"))
                        writeOutputStream(part, ORIGINAL_NETWORK_PATH);


                    else if (fileType.equals("expression_file")){
                        String fileExtension = fileName.endsWith(".gz") ? ".gz" : ".txt";
                        String input_files_path = INPUT_PATH + "exp_data_" + expression_file_count + fileExtension;
                        writeOutputStream(part, input_files_path);
                        allArgs.add(input_files_path);

                        expression_file_count += 1;
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

            LongRunningProcess myThreads = new LongRunningProcess(allArgs, stopSignal, runProgress);
            Thread lrp = new Thread(myThreads);
            lrp.start();
        }
    }
    public static void main(String[] args){
    }
}

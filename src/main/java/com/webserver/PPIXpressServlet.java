package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;

import standalone_tools.PPIXpress_Tomcat;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
    /**
     * Delete folders and contents recursively
     * 
     * @param Path_ Path to directory
     */
    public static void deleteDir(String Path_) {
        File dirFile = new File(Path_);
        if (dirFile.isDirectory()) {
            File[] dirs = dirFile.listFiles();
            assert dirs != null;
            for (File dir : dirs) {
                deleteDir(String.valueOf(dir));
            }
        }
        dirFile.delete();
    }

    /**
     * Create working directory for user
     * 
     * @param LocalStoragePath_ Path to the user's local storage
     */
    public static void createUserDir(String LocalStoragePath_) throws IOException {
        if (!Files.exists(Paths.get(LocalStoragePath_))) {
            Files.createDirectories(Paths.get(LocalStoragePath_ + "OUTPUT/"));
            Files.createDirectories(Paths.get(LocalStoragePath_ + "INPUT/"));
        } else {
            deleteDir(LocalStoragePath_);
            createUserDir(LocalStoragePath_);
        }
    }

    /**
     * TODO: Write documentation
     */
    static class LongRunningProcess implements Runnable {
        private final AtomicBoolean stopSignal;
        private final AtomicReference<String> message;
        private final PPIXpress_Tomcat pipeline = new PPIXpress_Tomcat();
        private volatile boolean stop;
        private final List<String> argList;

        public LongRunningProcess(List<String> allArgs, AtomicBoolean stopSignal, AtomicReference<String> message) {
            this.stopSignal = stopSignal;
            this.message = message;
            this.argList = allArgs;
        }

        @Override
        public void run() {
            while (!stop) {
                pipeline.runAnalysis(this.argList, stopSignal, message);
                if (stopSignal.get()) {
                    setStop(true);
                }
            }
        }

        public boolean getStop() {
            return stop;
        }

        public void setStop(boolean stop) {
            this.stop = stop;
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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private ServletContext context;
    /**
     * Initilize ServletContext log to localhost log files
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        context = getServletContext();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Main pipeline

        // Store uploaded files outside webapp deploy folders (LOCAL_STORAGE_PATH) and
        // output.zip inside deploy folder (WEBAPP_PATH)

        // Each user has their own ID
        String USER_ID = request.getSession().getId(); 

        // Define a data local storage on the local server
        String LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/uploads/" + USER_ID + "/"; 

        // Create input directory
        createUserDir(LOCAL_STORAGE_PATH); 
        context.log(USER_ID + ": New user created succesfully");

        // TODO: FIND A PLACE TO STORE DATA 
        String INPUT_PATH = LOCAL_STORAGE_PATH + "INPUT/";
        String OUTPUT_PATH = LOCAL_STORAGE_PATH + "OUTPUT/";
        String FILENAME_PPI = "ppi_data.sif";

        response.setContentType("text/html");
        String submit_type = request.getParameter("submitType");
        List<String> allArgs = new ArrayList<>();

        if (submit_type.equals("RunExample")) {
            context.log(USER_ID + ": Initiated with example data");
        } else if (submit_type.equals("RunNormal")) {
            context.log(USER_ID + ": Initiated with user's uploaded data");
            // Add path to protein network to arguments set.
            String taxon_id = request.getParameter("protein_network_web");

            // If taxon = null, use a predefined path to store input PPI
            // network on server, else use taxon to retrieve network from Mentha/IntAct
            String ORIGINAL_NETWORK_PATH = taxon_id.isEmpty() ? INPUT_PATH + FILENAME_PPI : "taxon:" + taxon_id;
            allArgs.add(ORIGINAL_NETWORK_PATH);

            // Add output path to arguments set
            allArgs.add(OUTPUT_PATH);

            // Add paths to expression data to argument list. Meanwhile, store user's PPI
            // network (if uploaded) and expression data to a local storage on server
            for (Part part : request.getParts()) {
                String fileType = part.getName();
                String fileName = part.getSubmittedFileName();

                if (fileName != null && !fileName.equals("")) {

                    if (fileType.equals("protein_network_file"))
                        writeOutputStream(part, ORIGINAL_NETWORK_PATH);

                    else if (fileType.equals("expression_file")) {
                        String input_files_path = INPUT_PATH + fileName.substring(fileName.lastIndexOf("\\") + 1);
                        writeOutputStream(part, input_files_path);
                        allArgs.add(input_files_path);
                    }
                }
            }

            // Store and show to screen uploaded files
            allArgs.addAll(List.of(request.getParameterValues("PPIOptions")));
            allArgs.addAll(List.of(request.getParameterValues("ExpOptions")));
            allArgs.addAll(List.of(request.getParameterValues("RunOptions")));
            allArgs.add(request.getParameter("threshold"));
            allArgs.add(request.getParameter("percentile"));
            allArgs.removeIf(n -> (n.equals("null")));
            context.log(USER_ID + ": " + allArgs);
            int no_expression_file = Integer.parseInt(request.getParameter("no_expression_file"));

            // Create and execute PPIXpress and update progress periodically to screen
            AtomicBoolean stopSignal = new AtomicBoolean(false);
            AtomicReference<String> runProgress = new AtomicReference<String>("");
            request.getSession().setAttribute("no_expression_file", no_expression_file);
            request.getSession().setAttribute("LONG_PROCESS_SIGNAL", stopSignal);
            request.getSession().setAttribute("LONG_PROCESS_ID", USER_ID);

            LongRunningProcess myThreads = new LongRunningProcess(allArgs, stopSignal, runProgress);
            Thread lrp = new Thread(myThreads);
            lrp.start();
        }
    }

    public static void main(String[] args) throws IOException {
    }
}

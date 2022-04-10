package com.webserver;

import com.ibm.wsdl.util.IOUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import standalone_tools.PPIXpress_Tomcat;
import static standalone_tools.PPIXpress_Tomcat.createElement;
import static standalone_tools.PPIXpress_Tomcat.updateAtomicString;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
    public static void printList(PrintWriter out, String[] list){
        for (String i : list) out.println(i + "<br>");
    }

    static class LongRunningProcess implements Runnable{
        private final AtomicBoolean updatingStop;
        private final AtomicReference<String> message;
        private final PPIXpress_Tomcat parsedPipeline;
        private volatile boolean stop;

        public LongRunningProcess(PPIXpress_Tomcat parsedPipeline, AtomicBoolean updatingStop, AtomicReference<String> message) {
            this.updatingStop = updatingStop;
            this.parsedPipeline = parsedPipeline;
            this.message = message;
        }

        @Override
        public void run() {
            while (!stop){
//                parsedPipeline.runAnalysis(updatingStop, message);
                if (updatingStop.get()){
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
     * Add inner text to HTML section
     * @param Element a String starts and ends with <tag></tag>
     * @param Content To be added Content
     * @return Modified HTML content
     */
    static String addInnerText(String Element, String Content){
        String[] splitElement = Element.split("(?=<)|(?<=>)");
        return(splitElement[0] + splitElement[1] + Content + splitElement[2]);
    }


    /**
     * Make a HTML list
     * @param l A list of items
     * @return HTML formatted list
     */
    static String makeList(List<String> l){
        StringBuilder stringList = new StringBuilder();
        if (l.size() != 0) l.forEach(s -> stringList.append(s.equals("") ? "" : createElement("li", s)));
        return(createElement("ul", String.valueOf(stringList)));
    }


    /**
     * Write a file part from JSP request to a local file
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
        String OUTPUT_PATH = SOURCE_PATH + "output/";
        String FILENAME_PPI = "ppi_data.sif";
        String ORIGINAL_NETWORK_PATH = INPUT_PATH + FILENAME_PPI;
        String FILENAME_EXP = "exp_data_";
        List<String> allArgs = new ArrayList<>();
        allArgs.add(ORIGINAL_NETWORK_PATH);
        allArgs.add(OUTPUT_PATH);
//        TODO: Make input accept gzip

        response.setContentType("text/html");
        String submit_type = request.getParameter("submitType");

        PPIXpress_Tomcat pipeline = new PPIXpress_Tomcat();
        AtomicReference<String> staticProgress = new AtomicReference<String>("");
        request.getSession().setAttribute("STATIC_PROGRESS_MESSAGE", staticProgress);

        if (submit_type.equals("RunExample")) {
//            SHOW EXAMPLE DATA
            staticProgress.set(
                    "<h3>Running PPIXpress with example data...</h3>"+
                    "<a href='header.html'>Inspect/Download example data</a><br><br>");

//            PARSE OPTIONS
            updateAtomicString(staticProgress, "<h3>Parsing PPIXpress options...</h3>");
            String[] args = {"-w", "-u", "-t=0.3"};
//            pipeline.parseInput(args);
            String[] parsedArgs = pipeline.getArgs();
            if (parsedArgs != null) updateAtomicString(staticProgress,
                    "<ul><li>" + String.join("</li><li>", parsedArgs) + "</li></ul>");

//            EXECUTE PIPELINE
            updateAtomicString(staticProgress, "<br><br><h3>Executing PPIXpress... </h3>");
            AtomicBoolean updatingStop = new AtomicBoolean(false);
            AtomicReference<String> runMessage = new AtomicReference<String>("");
            request.getSession().setAttribute("LONG_PROCESS_SIGNAL", updatingStop);
            request.getSession().setAttribute("LONG_PROCESS_MESSAGE", runMessage);

            LongRunningProcess myThreads = new LongRunningProcess(pipeline, updatingStop, runMessage);
            Thread lrp = new Thread(myThreads);
            lrp.start();
        }
        else if (submit_type.equals("RunNormal")) {

//            Start PPIPipeline
            staticProgress.set(createElement("h3", "Data submitted! Running PPIXpress... <br><br>"));


//            Store and show to screen uploaded files
//            Map<String, ArrayList<String>> uploadedFiles = new HashMap<>();
            int expression_file_count = 0;
            for (Part part : request.getParts()){

                String fileType = part.getName();
                String fileName = part.getSubmittedFileName();
                if (fileName != null){
                    if (fileType.equals("protein_network_file"))
                        writeOutputStream(part, ORIGINAL_NETWORK_PATH);

                    else if (fileType.equals("expression_file")){
                        String fileExtension = fileName.substring(fileName.length() - 3).equals(".gz") ? ".gz" : ".txt";
                        String input_files_path = INPUT_PATH + FILENAME_EXP + expression_file_count + fileExtension;
                        writeOutputStream(part, input_files_path);
                        System.out.println(input_files_path);
                        allArgs.add(input_files_path);

                        expression_file_count += 1;
                    }
//                    uploadedFiles.computeIfAbsent(part.getName(), k -> new ArrayList<>()).add(fileName);
                }
            }
//            allArgs.add("/Users/trangdo/Documents/BIOINFO/PPI-pipeline/example_data/BRCA_tumor.normalized_RSEM.gz");
//            List<String> uploadedFilesHTML = uploadedFiles.entrySet()
//                    .stream()
//                    .map(entry ->String.join(" ", entry.getKey().split("_")) + makeList(entry.getValue()))
//                    .collect(Collectors.toList());


//            Store and show to screen uploaded files
            allArgs.addAll(List.of(request.getParameterValues("PPIOptions")));
            allArgs.addAll(List.of(request.getParameterValues("ExpOptions")));
            allArgs.addAll(List.of(request.getParameterValues("RunOptions")));
            allArgs.add(request.getParameterValues("threshold")[0]);
            allArgs.add(request.getParameterValues("percentile")[0]);
            allArgs.removeIf(n -> (n.equals("null")));

            //TODO: Add percentile adjustment
            updateAtomicString(staticProgress, createElement("h3", "Parsing PPIXpress options..."));
            pipeline.parseInput(allArgs);
            List<String> parsedArgs = List.of(pipeline.getArgs());
            updateAtomicString(staticProgress, makeList(parsedArgs) + "<br>");

            updateAtomicString(staticProgress, createElement("h3", "Executing PPIXpress..."));
            AtomicBoolean updatingStop = new AtomicBoolean(false);
            AtomicReference<String> runMessage = new AtomicReference<String>("");
            request.getSession().setAttribute("LONG_PROCESS_SIGNAL", updatingStop);
            request.getSession().setAttribute("LONG_PROCESS_MESSAGE", runMessage);

            LongRunningProcess myThreads = new LongRunningProcess(pipeline, updatingStop, runMessage);
            Thread lrp = new Thread(myThreads);
            lrp.start();
        }
    }
    public static void main(String[] args){
    }
}

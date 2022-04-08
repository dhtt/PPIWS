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

import static com.webserver.PPIXpressRun.createElement;
import static com.webserver.PPIXpressRun.updateAtomicString;
import static org.apache.commons.lang3.StringUtils.capitalize;
import static org.apache.commons.lang3.StringUtils.join;
import static org.apache.juli.FileHandler.DEFAULT_BUFFER_SIZE;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
    public static void printList(PrintWriter out, String[] list){
        for (String i : list) out.println(i + "<br>");
    }

    static class LongRunningProcess implements Runnable{
        private final AtomicBoolean updatingStop;
        private final AtomicReference<String> message;
        private final PPIXpressRun parsedPipeline;
        private volatile boolean stop;

        public LongRunningProcess(PPIXpressRun parsedPipeline, AtomicBoolean updatingStop, AtomicReference<String> message) {
            this.updatingStop = updatingStop;
            this.parsedPipeline = parsedPipeline;
            this.message = message;
        }

        @Override
        public void run() {
            while (!stop){
                parsedPipeline.runAnalysis(updatingStop, message);
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
     * @return Modified content
     */
    static String addInnerText(String Element, String Content){
        String[] splitElement = Element.split("(?=<)|(?<=>)");
        return(splitElement[0] + splitElement[1] + Content + splitElement[2]);
    }

    static String makeList(List<String> l){
        StringBuilder stringList = new StringBuilder();
        if (l.size() != 0) l.forEach(s -> stringList.append(s.equals("") ? "" : createElement("li", s)));
        return(createElement("ul", String.valueOf(stringList)));
    }

    static void writeOutputStream(Part filePart, String filePath){
        try (InputStream in = filePart.getInputStream();
             OutputStream out = Files.newOutputStream(Paths.get(filePath))) {
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
        String FILENAME_PPI = "ppi_network.txt";
        String FILENAME_EXP = "exp_";

        PPIXpressRun pipeline = new PPIXpressRun();
        response.setContentType("text/html");
        String submit_type = request.getParameter("submitType");
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
            pipeline.parseArgs(args);
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
//            File uploaded_protein_network_file = new File("ppi.sif");
            staticProgress.set(createElement("h3", "Data submitted! Running PPIXpress... <br><br>"));

            Part proteinPart = request.getPart("protein_network_file");
            writeOutputStream(proteinPart, INPUT_PATH + FILENAME_PPI);


            updateAtomicString(staticProgress, createElement("h3", "Uploaded files:"));
            Map<String, ArrayList<String>> uploadedFiles = new HashMap<>();
            int expression_file_count = 0;
            for (Part part : request.getParts()){
                String fileType = part.getName();
                if (fileType.equals("protein_network_file")){
                    writeOutputStream(part, INPUT_PATH + FILENAME_PPI);
                }
                else if (fileType.equals("expression_file")){
                    writeOutputStream(part, INPUT_PATH + FILENAME_EXP + expression_file_count + ".txt");
                    expression_file_count += 1;
                }

                String fileName = part.getSubmittedFileName();
                if (fileName != null)
                    uploadedFiles.computeIfAbsent(part.getName(), k -> new ArrayList<>()).add(fileName);
            }
            System.out.println(uploadedFiles);
            List<String> uploadedFilesHTML = uploadedFiles.entrySet()
                    .stream()
                    .map(entry ->String.join(" ", entry.getKey().split("_")) + makeList(entry.getValue()))
                    .collect(Collectors.toList());
            updateAtomicString(staticProgress, makeList(uploadedFilesHTML) + "<br>");

//            Show run options
            String[] PPI_Options = request.getParameterValues("PPIOptions");
            String[] Exp_Options = request.getParameterValues("ExpOptions");
            String[] Run_Options = request.getParameterValues("RunOptions");
            String[] numericInput = {request.getParameter("threshold")};
            //TODO: Add percentile adjustment
            updateAtomicString(staticProgress, createElement("h3", "Parsing PPIXpress options..."));
            pipeline.parseArgs(PPI_Options, Exp_Options, Run_Options, numericInput);
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

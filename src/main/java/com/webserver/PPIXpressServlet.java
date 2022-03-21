package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

import static com.webserver.PPIXpressRun.updateAtomicString;

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        Main pipeline
        PPIXpressRun pipeline = new PPIXpressRun();
        response.setContentType("text/html");
        String submit_type = request.getParameter("submitType");

        if (submit_type.equals("RunExample")) {
            AtomicReference<String> staticProgress = new AtomicReference<String>("");
            request.getSession().setAttribute("STATIC_PROGRESS_MESSAGE", staticProgress);

//            SHOW EXAMPLE DATA
            staticProgress.set(
                    "<h3 style=\"color: #605248\">PLEASE DO NOT CLOSE THIS WINDOW</h3><br>" +
                    "<h4>| Running PPIXpress with example data...</h4>"+
                    "<a href='header.html'>Inspect/Download example data</a><br><br>");

//            PARSE OPTIONS
            updateAtomicString(staticProgress, "<h4>| Parsing PPIXpress options...</h4>");
            String[] args = {"-w", "-u", "-t=0.3"};
            pipeline.parseArgs(args);
            String[] parsedArgs = pipeline.getArgs();
            if (parsedArgs != null) updateAtomicString(staticProgress, String.join("<br>", parsedArgs));

//            EXECUTE PIPELINE
            updateAtomicString(staticProgress, "<br><br><h4>| Executing PPIXpress... </h4>");
            AtomicBoolean updatingStop = new AtomicBoolean(false);
            AtomicReference<String> runMessage = new AtomicReference<String>("");
            request.getSession().setAttribute("LONG_PROCESS_SIGNAL", updatingStop);
            request.getSession().setAttribute("LONG_PROCESS_MESSAGE", runMessage);

            LongRunningProcess myThreads = new LongRunningProcess(pipeline, updatingStop, runMessage);
            Thread lrp = new Thread(myThreads);
            lrp.start();
        }
            /*
//            pipeline.runAnalysis(out);
        }
        else if (submit_type.equals("RunNormal")){
            out.println("<h4>Data submitted!<br><br>Uploaded files:</h4>");
//        Show uploaded files
            for (Part part : request.getParts()) {
                if (part.getSubmittedFileName() != null) {
                    out.println(part.getName() + ": " + part.getSubmittedFileName() + "<br>");
                }
            }

//            Show run options
            String[] PPI_Options = request.getParameterValues("PPIOptions");
            String[] Exp_Options = request.getParameterValues("ExpOptions");
            String[] Run_Options = request.getParameterValues("RunOptions");
            String[] numericInput = {request.getParameter("threshold")};
            //TODO: Add percentile adjustment
            out.println("<br><h4>| Parsing PPIXpress options... </h4>");
            pipeline.parseArgs(PPI_Options, Exp_Options, Run_Options, numericInput);
            printList(out, pipeline.getArgs());

            out.println("<br><h4>| Executing PPIXpress... </h4>");
        }*/
    }
    public static void main(String[] args){
    }
}

package com.webserver;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

@WebServlet(name = "PPIXpress", value = "/PPIXpress")
@MultipartConfig()

public class PPIXpressServlet extends HttpServlet {
    public static void printList(PrintWriter out, String[] list){
        for (String i : list) out.println(i + "<br>");
    }

    static class LongRunningProcess implements Runnable{
        private final AtomicInteger percentComplete;
        private final AtomicReference<String> message;
        private final PPIXpressRun parsedPipeline;
        private volatile boolean stop;

        public LongRunningProcess(PPIXpressRun parsedPipeline, AtomicInteger percentComplete, AtomicReference<String> message) {
            this.percentComplete = percentComplete;
            this.parsedPipeline = parsedPipeline;
            this.message = message;
        }

        @Override
        public void run() {
            while (!stop){
//                try {
//                    Thread.sleep(1000);
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
                parsedPipeline.runAnalysis(percentComplete, message);
                if (percentComplete.get() == 6){
                    setStop(true);
                }
//                else {
//                    percentComplete.incrementAndGet();
//                }
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
        PrintWriter out = response.getWriter();
        String submit_type = request.getParameter("submitType");
        if (submit_type.equals("RunExample")) {
//            SHOW EXAMPLE DATA
//            out.println("<h4>| Running PPIXpress with example data...</h4>");
//            out.println("<a href='header.html'>Inspect/Download example data</a><br><br>");

//            PARSE OPTIONS
//            out.println("<h4>| Parsing PPIXpress options... </h4>");
            String[] args = {"-w", "-u", "-t=0.3"};
            pipeline.parseArgs(args);
            String[] parsedArgs = pipeline.getArgs();
            request.getSession().setAttribute("PARSED_ARGS", parsedArgs);
//            printList(out, parsedArgs);

//            EXECUTE PIPELINE
//            out.println("<br><h4>| Executing PPIXpress... </h4>");
//            Try Ajax progress bar
            AtomicInteger percentComplete = new AtomicInteger(0);
            AtomicReference<String> runMessage = new AtomicReference<String>("");
            request.getSession().setAttribute("LONG_RUNNING_PROCESS_STATUS", percentComplete);
            request.getSession().setAttribute("LONG_RUNNING_PROCESS_MESSAGE", runMessage);

            LongRunningProcess myThreads = new LongRunningProcess(pipeline, percentComplete, runMessage);
            Map<Thread, StackTraceElement[]> threads = Thread.getAllStackTraces();
            System.out.println(threads);
            Thread lrp = new Thread(myThreads);
            lrp.start();
            System.out.println(threads);
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

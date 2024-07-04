package unit_test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import standalone_tools.PPICompare_Tomcat;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.io.File;
import java.nio.file.*;
import static java.nio.file.StandardWatchEventKinds.ENTRY_CREATE;
import static java.nio.file.StandardWatchEventKinds.ENTRY_MODIFY;

import static org.junit.jupiter.api.Assertions.*;

@RunWith(JUnit4.class)
public class PPICompareTomcatTest {

    public ArrayList<Object> test_pipeline(){
        List<String> args_list = new ArrayList<>();
        // String INPUT_PATH = "repository/example_run/PPIXpress/INPUT/example_ppi_data.sif";
        String OUTPUT_PATH = "repository/example_upload/PPICompare/OUTPUT/";
        String GROUP1_PATH = "repository/example_upload/PPICompare/INPUT/M1_PPIXpress_out/";
        String GROUP2_PATH = "repository/example_upload/PPICompare/INPUT/N1_PPIXpress_out/";

        args_list.add("-output=" + OUTPUT_PATH);
        args_list.add("-group_1=" + GROUP1_PATH);
        args_list.add("-group_2=" + GROUP2_PATH);

        AtomicBoolean stop_signal = new AtomicBoolean(false);
        PPICompare_Tomcat pipeline = new PPICompare_Tomcat();
        pipeline.runAnalysis(args_list, stop_signal);
        ArrayList<Object> result_list = new ArrayList<Object>();
        result_list.add(stop_signal);
        result_list.add(OUTPUT_PATH + "LogFile.html");
        return result_list;
    }

    ArrayList<Object> pipeline_result = test_pipeline();
    
    @Test
    public void test_finished_process(){
        AtomicBoolean stop_signal = (AtomicBoolean) pipeline_result.get(1);
        assertTrue(stop_signal.get());
    }
    
    // @Test
    public void test_progress_file_exist(){
        String progress_file = pipeline_result.get(2).toString();
        File file = new File(progress_file);
        assertTrue(file.exists());
    }

    // @Test
    public void testWatchService(){
          // Create a watch event for log file

        String OUTPUT_PATH = "/home/trang/PPIWS/repository/example_run/PPIXpress/OUTPUT/";
        try (WatchService watchService = FileSystems.getDefault().newWatchService();){
            Path OUTPUT_PATH_DIR = Paths.get(OUTPUT_PATH);
            WatchKey watchKey = OUTPUT_PATH_DIR.register(watchService, ENTRY_CREATE, ENTRY_MODIFY);
            

            while (true) {
                for (WatchEvent<?> event : watchKey.pollEvents()) {
                    Path changedFile = OUTPUT_PATH_DIR.resolve((Path) event.context()); 
                    System.out.println("PPICompareServlet: Log file has been modified: " + event.kind());


                    System.out.println(changedFile);
                    if (changedFile.endsWith("LogFile.html")) {
                        System.out.println("My file has changed");
                    }    
                }

                boolean valid = watchKey.reset();
                if (!valid) {
                    break;
                }
            }
        } catch (Exception e) {
            System.out.println("Fail to watch file.\n" + e.toString());
        }

    }
}
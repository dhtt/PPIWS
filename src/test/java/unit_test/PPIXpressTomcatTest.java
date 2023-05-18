package unit_test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import standalone_tools.PPIXpress_Tomcat;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.io.File;

import static org.junit.jupiter.api.Assertions.*;

@RunWith(JUnit4.class)
public class PPIXpressTomcatTest {

    public ArrayList<Object> test_pipeline(){
        PPIXpress_Tomcat pipeline = new PPIXpress_Tomcat();
        List<String> args_list = new ArrayList<>();
        String INPUT_PATH = "repository/example_run/INPUT/human_ppin.sif";
        String OUTPUT_PATH = "repository/example_run/OUTPUT";
        String ORIGINAL_NETWORK_PATH = "repository/example_run/INPUT/Th2_precursors_1003.txt";

        args_list.add(INPUT_PATH);
        args_list.add(OUTPUT_PATH);
        args_list.add(ORIGINAL_NETWORK_PATH);
        args_list.add("-x");
        args_list.add("-t=1");
        args_list.add("-tp=-1");

        AtomicBoolean stop_signal = new AtomicBoolean(false);
        pipeline.runAnalysis(args_list, stop_signal);
        ArrayList<Object> result_list = new ArrayList<Object>();
        result_list.add(pipeline);
        result_list.add(stop_signal);
        result_list.add(OUTPUT_PATH + "/PPIXpress_log.html");
        return result_list;
    }

    ArrayList<Object> pipeline_result = test_pipeline();
    
    @Test
    public void test_finished_process(){
        AtomicBoolean stop_signal = (AtomicBoolean) pipeline_result.get(1);
        assertTrue(stop_signal.get());
    }
    
    @Test
    public void test_progress_file_exist(){
        String progress_file = pipeline_result.get(2).toString();
        File file = new File(progress_file);
        assertTrue(file.exists());
    }

}
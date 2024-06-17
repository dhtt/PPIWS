package unit_test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

import static org.junit.jupiter.api.Assertions.*;

import java.io.File;
import java.io.IOException;
import java.util.*;
import org.json.JSONArray;

import com.webserver.Utils;

@RunWith(JUnit4.class)
public class UtilsTest {
    @Test
    public void test_copyPPIXpress2PPICompare(){
        String LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/uploads/8OccrE351CwW";
        String groupedID = "Ccell:3,4";
        try {
            String copyTarget = Utils.copyPPIXpress2PPICompare(LOCAL_STORAGE_PATH, groupedID);
            assertTrue(copyTarget.equals(LOCAL_STORAGE_PATH + "/PPICompare/INPUT/" + groupedID.split(":")[0] + "/"));
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void test_unZipFile(){
        // Test with MPP.zip where all outputs are compressed. All outputs have .txt.gz extension
        String fileName = "/home/trang/PPIWS/repository/uploads/8de95199-5f2f-4a97-9a9e-971bbefed216/PPICompare/INPUT/MPP.zip";
        Utils.unzipFile(fileName, "group_1", ".");
        // Test with MPP.zip where all outputs are not compressed. All outputs have .txt extension
        String fileName1 = "/home/trang/PPIWS/repository/uploads/5e6b7e4c-b312-4a59-884d-454dc473015e/PPICompare/INPUT/N1_PPIXpress_out.zip";
        Utils.unzipFile(fileName1, "group_1", ".");
        // assertTrue(unzippedFile.equals(Utils.RemoveFileExtension(fileName)));
    }

    @Test
    public void test_ZipFile() throws IOException{
        String OUTPUT_PATH = "repository/example_run/PPIXpress/OUTPUT/";
        String OUTPUT_FILENAME = "ResultFiles_test.zip";
        Utils.zip(OUTPUT_PATH, OUTPUT_PATH + OUTPUT_FILENAME);
    }

    @Test
    public void test_filterProtein_PPICompare() {
        Map<String, String[]> proteinAttributeList = new HashMap<String, String[]>(); 
        String OUTPUT_PATH = "/home/trang/PPIWS/repository/example_run/PPICompare/OUTPUT/";
        try {
            Scanner s = new Scanner(new File(OUTPUT_PATH + "protein_attributes.txt")); 
            while (s.hasNext()) {
                String[] attributes = s.nextLine().split(" ");
                String UniprotID = attributes[0];
                proteinAttributeList.put(UniprotID, attributes);
            }
            s.close();
        } catch(Exception e){
            e.printStackTrace();
        }
        assertTrue(proteinAttributeList.get("O15151")[1].equals("MDM4"));
        
        JSONArray output = new JSONArray();
        output = Utils.filterProtein_PPICompare(OUTPUT_PATH, proteinAttributeList, "O15151");
        System.out.println(output);
    }

    @Test
    public void test_filterProtein_PPICompare_query(){
        String proteinQuery = "P01111";
        Map<String, String[]> proteinAttributeList = new HashMap<String, String[]>(); 
        String OUTPUT_PATH = "/home/trang/PPIWS/repository/example_run/PPICompare/OUTPUT/";
        try{
            Scanner s = new Scanner(new File(OUTPUT_PATH + "protein_attributes.txt"));
    
            while (s.hasNext()) {
                String[] attributes = s.nextLine().split(" ");
                String UniprotID = attributes[0];
                proteinAttributeList.put(UniprotID, attributes);
            }
            s.close();
        } catch(Exception e){
            e.printStackTrace();
        }

        JSONArray subNetworkData = Utils.filterProtein_PPICompare(OUTPUT_PATH, proteinAttributeList, proteinQuery);
        System.out.println(subNetworkData);
    }

    @Test
    public void test_filterProtein_PPIXpress() {
        String OUTPUT_PATH = "/home/trang/PPIWS/repository/example_run/PPIXpress/OUTPUT/";
        ArrayList<String> proteinList = new ArrayList<String>();
        System.out.println(": DownloadServlet: CHECK\n" + OUTPUT_PATH + "ProteinList.txt");


        try {
            Scanner s = new Scanner(new File(OUTPUT_PATH + "ProteinList.txt"));
            while (s.hasNext()) {
                proteinList.add(s.next());
            }
            s.close();
        } catch(Exception e){
            e.printStackTrace();
        }
        
        JSONArray output = new JSONArray();
        output = Utils.filterProtein(OUTPUT_PATH, "Q11130", "1", true);
        System.out.println(output);
    }


    @Test
    public void test_writeLog() {
        // Utils.setLogFileName("El5Rpmfa8uWF");
        // Utils.setLogFileName("El5Rpmfa8uWF");
        // Utils.writeLog();
    }

}
package unit_test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

import static org.junit.jupiter.api.Assertions.*;

import java.io.File;
import java.util.*;
import org.json.JSONArray;

import com.webserver.Utils;

@RunWith(JUnit4.class)
public class UtilsTest {
    @Test
    public void test_unZipFile(){
        // Test with MPP.zip where all outputs are compressed. All outputs have .txt.gz extension
        String fileName = "/home/trang/PPIWS/repository/uploads/8de95199-5f2f-4a97-9a9e-971bbefed216/PPICompare/INPUT/MPP.zip";
        Utils.UnzipFile(fileName, "group_1", ".");
        // Test with MPP.zip where all outputs are not compressed. All outputs have .txt extension
        String fileName1 = "/home/trang/PPIWS/repository/uploads/5e6b7e4c-b312-4a59-884d-454dc473015e/PPICompare/INPUT/N1_PPIXpress_out.zip";
        Utils.UnzipFile(fileName1, "group_1", ".");
        // assertTrue(unzippedFile.equals(Utils.RemoveFileExtension(fileName)));
    }

    // @Test
    public void test_filterProtein_PPICompare() {
        Map<String, String[]> proteinAttributeList = new HashMap<String, String[]>(); 
        String LOCAL_STORAGE_PATH = "/home/trang/PPIWS/repository/example_run/PPICompare/OUTPUT/";
        try {
            Scanner s = new Scanner(new File(LOCAL_STORAGE_PATH + "protein_attributes.txt")); 
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
        output = Utils.filterProtein_PPICompare(LOCAL_STORAGE_PATH, proteinAttributeList);
        System.out.println(output);
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
        output = Utils.filterProtein(OUTPUT_PATH, "Q9UKT8", "expression_1.txt", true);
        System.out.println(output);
    }
}
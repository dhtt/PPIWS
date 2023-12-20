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
    // @Test
    // public void test_unZipFile(){
    //     String fileName = "/home/trang/PPIWS/repository/uploads/2451851EEADECD0465E54C000A783806/PPICompare/INPUT/HSC.zip";
    //     String unzippedFile = Utils.UnzipFile(fileName);
    //     assertTrue(unzippedFile.equals(Utils.RemoveFileExtension(fileName)));
    // }

    @Test
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
        } catch(Exception e){
            e.printStackTrace();
        }
        assertTrue(proteinAttributeList.get("O15151")[1].equals("MDM4"));
        
        JSONArray output = new JSONArray();
        output = Utils.filterProtein_PPICompare(LOCAL_STORAGE_PATH, proteinAttributeList);
        System.out.println(output);
    }
}
package com.webserver;

import org.json.JSONArray;
import org.json.JSONObject;
import org.unix4j.line.Line;
import org.unix4j.unix.Grep;

import java.io.*;
import java.util.*;
import java.util.stream.Stream;
import java.nio.file.*;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
import java.util.zip.ZipEntry;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static org.unix4j.Unix4j.grep;


public class Utils {
    public static void setLogFileName(String name) {
        System.setProperty("logFilename", "/home/trang/PPIWS_logs/" + name + ".log");
    }

    /**
     * Zip output files in the result folder
     * 
     * @param sourceDirPath_ path to folder to be zipped
     * @param zipPath_       path to zipped folder
     * @throws IOException
     * Source: https://stackoverflow.com/a/68439125/9798960
     */
    public static void zip(String sourceDirPath_, String zipPath_) throws IOException {
        Files.deleteIfExists(Paths.get(zipPath_));
        Path zipFile = Files.createFile(Paths.get(zipPath_));
        List<String> ignoreFiles = Arrays.asList("protein_list.txt", "ProteinList.txt", ".bk", ".zip");

        Path sourceDirPath = Paths.get(sourceDirPath_);
        try (
                ZipOutputStream zipOutputStream = new ZipOutputStream(Files.newOutputStream(zipFile));
                Stream<Path> paths = Files.walk(sourceDirPath)) {
                    paths
                    .filter(path -> !Files.isDirectory(path))
                    .forEach(path -> {
                        if (path.toString().endsWith(".gz") || path.toString().endsWith(".txt") &&
                            !ignoreFiles.stream().anyMatch(suffix -> path.toString().endsWith(suffix))
                            ) {
                            ZipEntry zipEntry = new ZipEntry(sourceDirPath.relativize(path).toString());
                            try {
                                zipOutputStream.putNextEntry(zipEntry);
                                Files.copy(path, zipOutputStream);
                                zipOutputStream.closeEntry();
                            } catch (IOException e) {
                                System.out.println(e.getMessage());
                            }
                        }
                    });
            zipOutputStream.finish();
        }
    }
    
    /**
     * Appends the given string to the specified file.
     *
     * @param str      the string to be appended
     * @param fileName the name of the file to append the string to
     */
    public static void appendStrToFile(String str, String fileName) {
        try {
                // Open given file in append mode by creating an
                // object of BufferedWriter class
                BufferedWriter out = new BufferedWriter(new FileWriter(fileName, true));

                // Writing on output stream
                out.write(str);
                // Closing the connection
                out.close();
        }
        // Catch block to handle the exceptions
        catch (IOException e) {

                // Display message when exception occurs
                System.out.println("Exception occured in ProgressReporter:appendStrToFile: " + e);
        }
    }

    public static String RemoveFileExtension(String FileName) {
        String nameWithoutExtension = null;
        // Find the last occurrence of the period character.
        int lastDotIndex = FileName.lastIndexOf(".");
        
        if (lastDotIndex != -1) {
            try{
                // Remove the file extension.
                nameWithoutExtension = FileName.substring(0, lastDotIndex);
            }
            catch(Exception e){
                System.out.println("Cannot remove file extension");
            }
        } else {
            nameWithoutExtension = FileName;
        }
        return(nameWithoutExtension);
    }

    
    public static String unzipFile(String zipFilePath_, String prefix_, String sep_) {
        // Define the directory where you want to extract the contents
        Path zipFilePath = Paths.get(RemoveFileExtension(zipFilePath_));
        try {
            if (!Files.exists(zipFilePath)) {
                Files.createDirectories(zipFilePath);
            } else {
                Utils.deleteDir(zipFilePath.toString());
                Files.createDirectories(zipFilePath);
            }
        } catch(Exception e){
            System.out.println(e);
        }

        byte[] buffer = new byte[1024];

        try (
            FileInputStream fis = new FileInputStream(zipFilePath_);
            BufferedInputStream bis = new BufferedInputStream(fis);
            ZipInputStream stream = new ZipInputStream(bis)) {
                ZipEntry entry;
                while ((entry = stream.getNextEntry()) != null) {
                    
                    String[] entryNames = entry.getName().split("/");
                    String entryName = entryNames[entryNames.length - 1];
                    if (!entryName.startsWith("__MACOSX") & !entryName.startsWith(".") 
                        & (entryName.endsWith(".txt") | entryName.endsWith(".gz"))){
                        Path filePath = zipFilePath.resolve(prefix_ + sep_ + entryName);
                        
                        try {
                            File newFile = filePath.toFile();
                            if (!newFile.isDirectory()){
                                FileOutputStream fos = new FileOutputStream(newFile);
                                BufferedOutputStream bos = new BufferedOutputStream(fos, buffer.length);

                                int len;
                                while ((len = stream.read(buffer)) > 0) {
                                    bos.write(buffer, 0, len);
                                }
                                bos.close();
                            }
                        }
                        catch(IOException e){
                            e.printStackTrace();
                        }
                    }
                }
            }
        catch(Exception e){
            e.printStackTrace();
        }
        return(zipFilePath.toString());
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
            Utils.deleteDir(LocalStoragePath_);
            createUserDir(LocalStoragePath_);
        }
    }


    /**
     * Create working directory for user
     * 
     * @param LocalStoragePath_ Path to the user's local storage
     */
    // group_ids = ['g1:1,2,3','g2:5,6,7']
    public static String copyPPIXpress2PPICompare(String Path_, String groupedID) throws IOException {
        String PPIXpressOutputPath = Path_ + "/PPIXpress/OUTPUT/";
        String PPICompareInputPath = Path_ + "/PPICompare/INPUT/";
        String[] PPICompareRequiredFormat = new String[]{"ppin.txt", "ddin.txt", "major-transcripts.txt", "ppin.txt.gz", "ddin.txt.gz", "major-transcripts.txt.gz"};
        String groupID = groupedID.split(":")[0]; // group_id = g1
        String[] sampleIDs = groupedID.split(":")[1].split(","); // sample_ids = [1,2,3]

        String targetDir = PPICompareInputPath + groupID + "/";

        try {
            for (String fileSuffix : PPICompareRequiredFormat) {
                for (String ID : sampleIDs) {
                    String fileName = ID + "_" + fileSuffix;
                    String source = PPIXpressOutputPath + fileName; // /PPIXpress/OUTPUT/1_ppin.txt or /PPIXpress/OUTPUT/1_ppin.txt.gz
                    if (Files.exists(Paths.get(source))){
                        String target = targetDir + fileName;
    
                        if (!Files.exists(Paths.get(targetDir))) {
                            Files.createDirectories(Paths.get(targetDir));
                        }

                        Files.copy(Paths.get(source), Paths.get(target), StandardCopyOption.REPLACE_EXISTING);
                    } else {
                        continue;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return(targetDir);
    }
    

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


    public static JSONObject addEdge(String source_, String target_, String weight_, String class_){
        JSONObject edge_data = new JSONObject();
        edge_data.put("source", source_);
        edge_data.put("target", target_);
        edge_data.put("isdirected", false);
        edge_data.put("weight", Float.parseFloat(weight_));

        JSONObject edge_output = new JSONObject();
        edge_output.put("data", edge_data);
        edge_output.put("position", new JSONObject());
        edge_output.put("group", "edges");
        edge_output.put("removed", false);
        edge_output.put("grabbable", true);
        edge_output.put("classes", class_);

        return edge_output;
    }


    public static JSONObject addNode(String id_, String label_, String parent_, String class_){
        JSONObject node_data = new JSONObject();
        node_data.put("id", id_);
        node_data.put("label", label_);
        node_data.put("parent", parent_);

        JSONObject node_output = new JSONObject();
        node_output.put("data", node_data);
        node_output.put("position", new JSONObject());
        node_output.put("group", "nodes");
        node_output.put("remove", false);
        node_output.put("selected", false);
        node_output.put("locked", false);
        node_output.put("classes", class_);

        return node_output;
    }

    public static JSONObject addNode_PPICompare(String id_, String label_, String class_, Map<String, String[]> proteinAttributeList_){
        // proteinAttributeList_[0] should be the same as id_
        String[] proteinAttributeList_node = proteinAttributeList_.get(id_);
        String geneName = proteinAttributeList_node[1];
        String partOfMinReasons = proteinAttributeList_node[2];
        String alterationType = proteinAttributeList_node[3];
        String transcriptomicAlteration = proteinAttributeList_node[4];
        Integer score = Integer.parseInt(proteinAttributeList_node[5]);

        
        JSONObject node_data = new JSONObject();
        node_data.put("id", id_);
        node_data.put("label", geneName);
        node_data.put("partOfMinReasons", partOfMinReasons);
        node_data.put("alterationType", alterationType);
        node_data.put("transcriptomicAlteration", transcriptomicAlteration);
        node_data.put("score", score);

        JSONObject node_output = new JSONObject();
        node_output.put("data", node_data);
        node_output.put("position", new JSONObject());
        node_output.put("group", "nodes");
        node_output.put("remove", false);
        node_output.put("selected", false);
        node_output.put("locked", false);
        node_output.put("classes", class_);

        return node_output;
    }


    public static JSONArray filterProtein_PPICompare(String LOCAL_STORAGE_PATH, Map<String, String[]> proteinAttributeList, String proteinQuery) { 
        JSONArray output = new JSONArray();  
        Set<String> partners = new HashSet<String>();
        File PPI_file = new File(LOCAL_STORAGE_PATH + "differential_network.txt");
        List<Line> lines = new ArrayList<Line>();
        
        if (!proteinQuery.equals("null")){
            lines = grep(Grep.Options.i, ".*?" + proteinQuery + ".*?", PPI_file).toLineList();
        }

        try {
            if (!lines.isEmpty()){
                for (Line line : lines) {
                    String[] PPIs = line.getContent().split(" ");
                    partners.addAll(List.of(Arrays.copyOfRange(PPIs, 0, 2)));

                    //Convert +/- type interaction to 1/0 for cytoscape color mapping 
                    String type = PPIs[2].equals("+") ? "1.0":"0.0"; 
                    
                    JSONObject PPI_Edge = new JSONObject();
                    PPI_Edge = addEdge(PPIs[0], PPIs[1], type, "PPI_Edge");
                    output.put(PPI_Edge);
                }
            } else {
                BufferedReader br = new BufferedReader(new FileReader(PPI_file));
                br.readLine();
                String line = null;
                
                while ((line = br.readLine()) != null) {
                    String[] PPIs = line.split(" ");
                    partners.addAll(List.of(Arrays.copyOfRange(PPIs, 0, 2)));

                    //Convert +/- type interaction to 1/0 for cytoscape color mapping 
                    String type = PPIs[2].equals("+") ? "1.0":"0.0"; 
                    
                    JSONObject PPI_Edge = new JSONObject();
                    PPI_Edge = addEdge(PPIs[0], PPIs[1], type, "PPI_Edge");
                    output.put(PPI_Edge);
                }
                br.close();
            }

            // Create single nodes that linked to itself
            for (String node : partners) { 
                JSONObject Protein_Node = addNode_PPICompare(node, node, "Protein_Node", proteinAttributeList);
                output.put(Protein_Node);
            }
        } catch(Exception e){
            e.printStackTrace();
        }

        return output;
    }
    

    public static JSONArray filterProtein(String LOCAL_STORAGE_PATH, String proteinQuery, String expressionQuery, boolean showDDIs) {
        JSONArray output = new JSONArray();
        JSONObject graph_type = new JSONObject();
        List<Line> lines = new ArrayList<>();
        try {   
            File PPI_file = new File(LOCAL_STORAGE_PATH + expressionQuery + "_ppin.txt");

            if (PPI_file.exists()){
                lines = grep(Grep.Options.i, ".*?" + proteinQuery + ".*?", PPI_file).toLineList();

                if (!lines.isEmpty()) {
                    graph_type.put("graph_type", "condition_specific_network");
                } else {
                    PPI_file = new File(LOCAL_STORAGE_PATH + "reference_ppin.txt");
                    if (PPI_file.exists()){
                        lines = grep(Grep.Options.i, ".*?" + proteinQuery + ".*?", PPI_file).toLineList();

                        graph_type.put("graph_type", !lines.isEmpty() ? "reference_network" : "none");
                    } else {
                        graph_type.put("graph_type",  "none");
                    }
                }
            } else {
                graph_type.put("graph_type",  "none");
            }
            output.put(graph_type); // Contain graph_type information in the first position

            if (graph_type.get("graph_type") == "none") {
                JSONObject Protein_Node = addNode(proteinQuery, proteinQuery, "", "Protein_Node");
                output.put(Protein_Node);

                JSONObject Domain_Node = addNode("domain", "domain", proteinQuery, "Node_hidden");
                output.put(Domain_Node);
            } else {
                Set<String> partners = new HashSet<String>();

                for (Line line : lines) {
                    String[] PPIs = line.getContent().split(" ");
                    partners.addAll(List.of(Arrays.copyOfRange(PPIs, 0, 2)));
                    JSONObject PPI_Edge = addEdge(PPIs[0], PPIs[1], PPIs[2], "PPI_Edge");
                    output.put(PPI_Edge);
                }
    
                // Create single nodes that linked to itself
                for (String node : partners) { 
                    JSONObject Protein_Node = addNode(node, node, "", "Protein_Node");
                    output.put(Protein_Node);
                }
    
                if (showDDIs){
                    File DDI_file = graph_type.get("graph_type").equals("condition_specific_network") ? 
                        new File(LOCAL_STORAGE_PATH + expressionQuery + "_ddin.txt") : new File(LOCAL_STORAGE_PATH + "reference_ddin.txt");
                    List<Line> DDIs = grep(".*?" + String.join(".*?|.*?", partners) + ".*?", DDI_file).toLineList();
                    ArrayList<String> DomainList = new ArrayList<String>();
    
                    for (Line line : DDIs) {
                        String[] PPIs = line.getContent().split(" ");
    
                        if (PPIs[2].equals("pd")) {
                            String parent = PPIs[0];
                            String[] nodeLabels = PPIs[1].split("\\|");
                            String DDI_ID = nodeLabels[1] + "_" + nodeLabels[2];
    
                            if (!DomainList.contains(DDI_ID)){ // Avoid adding duplicated nodes
                                JSONObject Domain_Node = addNode(DDI_ID, nodeLabels[1], parent, "Domain_Node");
                                output.put(Domain_Node);
                                DomainList.add(DDI_ID);
                            }
                        }
                        else if (PPIs[2].equals("dd")) {
                            String[] nodeLabel1 = PPIs[0].split("\\|");
                            String DDI_ID1 = nodeLabel1[1] + "_" + nodeLabel1[2];
                            String[] nodeLabel2 = PPIs[1].split("\\|");
                            String DDI_ID2 = nodeLabel2[1] + "_" + nodeLabel2[2];
    
                            if (!DomainList.contains(DDI_ID1 + DDI_ID2)){ // Avoid adding duplicated edges
                                String proteinPair = nodeLabel1[2] + "_" + nodeLabel2[2];
    
                                if (proteinPair.matches("(?i).*" + proteinQuery + ".*" )){
                                    JSONObject DDI_Edge = addEdge(DDI_ID1, DDI_ID2, PPIs[3], "DDI_Edge");
                                    output.put(DDI_Edge);
                                }
                                DomainList.add(DDI_ID1 + DDI_ID2);
                            }
                        }
                    }
                }
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return output;
    }

    public static void writeLog() {
        setLogFileName("test_writeLog");
        final Logger logger = LogManager.getLogger(Utils.class);
  
        logger.trace("Hello");
        logger.info("Hello");
        logger.error("Hello");
        logger.warn("Hello");
    }


    public static void main(String[] args) throws FileNotFoundException {
//        String USER_ID = "USER_TEST/"; // Each user has their own ID
//        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/" + USER_ID + "OUTPUT/"; // Define a data local storage on the local server
//        String expressionQuery = "1";
//        JSONArray output = filterProtein(LOCAL_STORAGE_PATH, "P07900", expressionQuery, true);
////        String output = getProteinList(LOCAL_STORAGE_PATH);
//        System.out.println(output);
//        System.out.println();
//        HashSet<String> proteins = new HashSet<>();
//        proteins.add("Protein 1");
//        proteins.add("Protein 2");
//        Utilities.writeEntries(proteins, LOCAL_STORAGE_PATH + "test.txt");
    }
}

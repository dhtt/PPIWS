package com.webserver;

import org.json.JSONArray;
import org.json.JSONObject;
import org.unix4j.line.Line;
import org.unix4j.unix.Grep;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import static org.unix4j.Unix4j.grep;


public class Utils {

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

    public static JSONArray filterProtein(String LOCAL_STORAGE_PATH, String proteinQuery, String expressionQuery, boolean showDDIs) {
        JSONArray output = new JSONArray();
        File PPI_file = new File(LOCAL_STORAGE_PATH + expressionQuery + "_ppin.txt");
        List<Line> lines = grep(Grep.Options.i, ".*?" + proteinQuery + ".*?", PPI_file).toLineList();
        if (lines.isEmpty()) {
            JSONObject emptyList = new JSONObject();
            emptyList.put("Error", "Protein not found!");
            output.put(emptyList);
        } else {
            Set<String> partners = new HashSet<>();

            for (Line line : lines) {
                String[] PPIs = line.getContent().split(" ");
                partners.addAll(List.of(Arrays.copyOfRange(PPIs, 0, 2)));
                JSONObject PPI_Edge = addEdge(PPIs[0], PPIs[1], PPIs[2], "PPI_Edge");
                output.put(PPI_Edge);
            }

            for (String node : partners) {
                JSONObject Protein_Node = addNode(node, node, "", "Protein_Node");
                output.put(Protein_Node);
            }

            if (showDDIs){
                File DDI_file = new File(LOCAL_STORAGE_PATH + expressionQuery + "_ddin.txt");
                List<Line> DDIs = grep(".*?" + String.join(".*?|.*?", partners) + ".*?", DDI_file).toLineList();
                ArrayList<String> DomainList = new ArrayList<>();

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

//        System.out.println(output);
        return output;
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

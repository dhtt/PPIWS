package com.webserver;

import framework.Utilities;
import org.json.JSONArray;
import org.json.JSONObject;
import org.unix4j.line.Line;
import org.unix4j.unix.Grep;

import java.io.*;
import java.util.*;

import static org.unix4j.Unix4j.grep;
import static standalone_tools.PPIXpress_Tomcat.createElement;


public class Utils {
    public static class Protein {
        String ID;
        ArrayList<String> Domains;

        // okay with many threads since only written once
        private HashMap<String, String[]> ddis;
        private HashMap<String, String[]> protein_to_domains;
        private HashMap<String, String> domain_to_protein;
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

                JSONObject edge_data = new JSONObject();
                edge_data.put("source", PPIs[0]);
                edge_data.put("target", PPIs[1]);
                edge_data.put("isdirected", false);
                edge_data.put("weight", Float.parseFloat(PPIs[2]));

                JSONObject edge_output = new JSONObject();
                edge_output.put("data", edge_data);
                edge_output.put("position", new JSONObject());
                edge_output.put("group", "edges");
                edge_output.put("removed", false);
                edge_output.put("grabbable", true);
                edge_output.put("classes", "");

                output.put(edge_output);
            }

            for (String node : partners) {
                JSONObject node_data = new JSONObject();
                node_data.put("id", node);

                JSONObject node_output = new JSONObject();
                node_output.put("data", node_data);
                node_output.put("position", new JSONObject());
                node_output.put("group", "nodes");
                node_output.put("remove", false);
                node_output.put("selected", false);
                node_output.put("locked", false);
                node_output.put("classes", "");

                output.put(node_output);
            }

            if (showDDIs){
                File DDI_file = new File(LOCAL_STORAGE_PATH + expressionQuery + "_ddin.txt");
                List<Line> DDIs = grep(".*?" + String.join(".*?|.*?", partners) + ".*?", DDI_file).toLineList();
                for (Line line : DDIs) {
                    String[] PPIs = line.getContent().split(" ");

                    if (PPIs[2].equals("pd")) {
                        String parent = PPIs[0];
                        String node = PPIs[1].split("\\|")[1] + " " + PPIs[1].split("\\|")[0];

                        JSONObject node_data = new JSONObject();
                        node_data.put("id", node);
                        node_data.put("parent", parent);

                        JSONObject node_output = new JSONObject();
                        node_output.put("data", node_data);
                        node_output.put("position", new JSONObject());
                        node_output.put("group", "nodes");
                        node_output.put("remove", false);
                        node_output.put("selected", false);
                        node_output.put("locked", false);
                        node_output.put("classes", "");

                        output.put(node_output);
                    }
                    else if (PPIs[2].equals("dd")) {
                        String[] node1 = PPIs[0].split("\\|");
                        String[] node2 = PPIs[1].split("\\|");

                        if (node1[2].equals(proteinQuery) | node2[2].equals(proteinQuery)){
                            JSONObject edge_data = new JSONObject();
                            edge_data.put("source", node1[1] + " " + node1[0]);
                            edge_data.put("target", node2[1] + " " + node2[0]);
                            edge_data.put("weight", Float.parseFloat(PPIs[3]));

                            JSONObject edge_output = new JSONObject();
                            edge_output.put("data", edge_data);
                            edge_output.put("position", new JSONObject());
                            edge_output.put("group", "edges");
                            edge_output.put("removed", false);
                            edge_output.put("grabbable", true);
                            edge_output.put("classes", "");

                            output.put(edge_output);
                        }
                    }
                }
            }
        }

        System.out.println(output);
        return output;
    }


    public static void main(String[] args) throws FileNotFoundException {
        String USER_ID = "USER_TEST/"; // Each user has their own ID
        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/" + USER_ID + "OUTPUT/"; // Define a data local storage on the local server
        String expressionQuery = "1";
        JSONArray output = filterProtein(LOCAL_STORAGE_PATH, "P07900", expressionQuery, true);
//        String output = getProteinList(LOCAL_STORAGE_PATH);
        System.out.println(output);
//        HashSet<String> proteins = new HashSet<>();
//        proteins.add("Protein 1");
//        proteins.add("Protein 2");
//        Utilities.writeEntries(proteins, LOCAL_STORAGE_PATH + "test.txt");
    }
}

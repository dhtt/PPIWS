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
    public static JSONArray filterProtein(String LOCAL_STORAGE_PATH, String proteinQuery, String expressionQuery){
        JSONArray output = new JSONArray();
        File file = new File(LOCAL_STORAGE_PATH + expressionQuery);
        List<Line> lines = grep(Grep.Options.i, proteinQuery, file).toLineList();
        if (lines.isEmpty()) {
            JSONObject emptyList = new JSONObject();
            emptyList.put("Error", "Protein not found!");
            output.put(emptyList);
        }
        else {
            Set<String> partners = new HashSet<>();

            for (Line line : lines){
                String[] PPIs = line.getContent().split(" ");
                partners.addAll(List.of(PPIs));

                JSONObject node_data = new JSONObject();
                node_data.put("source", PPIs[0]);
                node_data.put("target", PPIs[1]);
                node_data.put("weight", PPIs[2]);

                JSONObject node_output = new JSONObject();
                node_output.put("data", node_data);
                node_output.put("removed", false);
                node_output.put("selected", false);
                node_output.put("selectable", true);
                node_output.put("locked", false);
                node_output.put("grabbable", true);
                node_output.put("classes", "");

                output.put(node_output);
            }

            for (String node : partners){
                JSONObject edge_data = new JSONObject();
                edge_data.put("id", node);

                JSONObject edge_output = new JSONObject();
                edge_output.put("data", edge_data);
                edge_output.put("group", "nodes");
                edge_output.put("remove", false);
                edge_output.put("selected", false);
                edge_output.put("locked", false);
                edge_output.put("classes", "");

                output.put(edge_output);
            }
        }

        return output;
    }


    public static void main(String[] args) throws FileNotFoundException {
//        String USER_ID = "USER_1/"; // Each user has their own ID
//        String LOCAL_STORAGE_PATH = "/Users/trangdo/IdeaProjects/Webserver/src/main/resources/USER_DATA/" + USER_ID + "OUTPUT/"; // Define a data local storage on the local server
//////        String expressionQuery = "1_ppin.txt";
//////        JSONArray output = filterProtein(LOCAL_STORAGE_PATH, "p07900", expressionQuery);
////        String output = getProteinList(LOCAL_STORAGE_PATH);
////        System.out.println(output);
//        HashSet<String> proteins = new HashSet<>();
//        proteins.add("Protein 1");
//        proteins.add("Protein 2");
//        Utilities.writeEntries(proteins, LOCAL_STORAGE_PATH + "test.txt");
    }
}

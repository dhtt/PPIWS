package com.webserver;

import java.nio.file.Paths;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;


public class example {
    /**
     * Delete folders and contents recursively
     * @param Path_ Path to directory
     */
    public static void deleteDir(String Path_) {
        File dirFile = new File(Path_);
        if (dirFile.isDirectory()) {
            File[] dirs = dirFile.listFiles();
            assert dirs != null;
            for (File dir: dirs) {
                deleteDir(String.valueOf(dir));
            }
        }
        dirFile.delete();
    }
    
    /**
     * Create working directory for user
     * @param LocalStoragePath_ Path to the user's local storage
     */
    public static void createUserDir(String LocalStoragePath_) throws IOException {
        if (!Files.exists(Paths.get(LocalStoragePath_))){
            Files.createDirectories(Paths.get(LocalStoragePath_ + "OUTPUT/"));
            Files.createDirectories(Paths.get(LocalStoragePath_ + "INPUT/"));
        }
        else {
            deleteDir(LocalStoragePath_);
            createUserDir(LocalStoragePath_);
        }
    }
    public static void main(String[] args) throws IOException {
        String LOCAL_STORAGE_PATH = "./PPIWS/repository/uploads/" + "example1" + "/"; // Define a data local storage on the local server
        createUserDir(LOCAL_STORAGE_PATH); // Create input directory
    }
}

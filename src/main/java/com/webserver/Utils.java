package com.webserver;

import com.helloworld.HelloWorldJar;
import framework.NetworkBuilder;
import framework.PPIN;

public class Utils {
    public static String findDate(){
        HelloWorldJar hwj = new HelloWorldJar();
        return hwj.now;
    }
    public static void main(String[] args){
//        System.out.println("Creating PPI");
//        PPIN org_network = new PPIN("/Users/trangdo/Documents/BIOINFO/PPIXpress_1.23/example_data/human_ppin.sif");
//        System.out.println("Building network");
//        NetworkBuilder nb = new NetworkBuilder(org_network);
//        System.out.println("Successfully built network from file");
    }
}

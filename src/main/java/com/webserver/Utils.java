package com.webserver;

import com.helloworld.HelloWorldJar;

public class Utils {
    public static String findDate(){
        HelloWorldJar hwj = new HelloWorldJar();
        return hwj.get_message("From HelloWorldJar, the time is: ");
    }
}

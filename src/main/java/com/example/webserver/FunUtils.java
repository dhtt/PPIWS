package com.example.webserver;

import java.util.Locale;
import com.helloworld.HelloWorldJar;


public class FunUtils {
    public static String findDate(){
        HelloWorldJar hwj = new HelloWorldJar();
        return hwj.get_message("From HelloWorldJar, the time is: ");
    }
}

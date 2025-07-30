package com.example.hackathon;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class HackathonApplication {
    public static void main(String[] args) {
        // Set timezone to UTC for consistent time handling
        System.setProperty("user.timezone", "UTC");
        SpringApplication.run(HackathonApplication.class, args);
    }
}
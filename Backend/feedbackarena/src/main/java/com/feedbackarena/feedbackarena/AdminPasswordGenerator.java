package com.feedbackarena.feedbackarena;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class AdminPasswordGenerator {

    public static void main(String[] args) {

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        String password = "password";

        String hash = encoder.encode(password);

        System.out.println(hash);
    }
}
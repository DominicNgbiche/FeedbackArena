package com.feedbackarena.feedbackarena.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor 
public class EmailService {

    private final JavaMailSender mailSender;
    
    public void sendEmailVerification(String email, String verificationCode){
        SimpleMailMessage message = new SimpleMailMessage();

        message.setTo(email);
        message.setSubject("FeedbackArena Email Verification");
        message.setText("Your verification code is: " + verificationCode);
        mailSender.send(message);
    }
}

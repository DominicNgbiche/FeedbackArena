package com.feedbackarena.feedbackarena.exception;

public class FeedbackNotFoundException extends RuntimeException {
    
    public FeedbackNotFoundException(String message){
        super(message);
    }
}

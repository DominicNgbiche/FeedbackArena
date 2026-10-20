package com.feedbackarena.feedbackarena.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.Authentication;

import com.feedbackarena.feedbackarena.service.FeedbackService;

import jakarta.validation.Valid;

import com.feedbackarena.feedbackarena.dto.FeedbackRequest;
import com.feedbackarena.feedbackarena.model.Feedback;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/feedback")
@RequiredArgsConstructor
public class FeedbackController {

    private final FeedbackService feedbackService;

    @GetMapping("/all")
    public List<Feedback> getAllFeedback(){
        return feedbackService.getAllFeedback();
    }

    @PostMapping("create")
    public Feedback creatFeedback (@Valid  @RequestBody FeedbackRequest feedbackRequest, Authentication authentication){
        String email = authentication.getName();
        
        return feedbackService.createFeedback(feedbackRequest, email);
    }

    @GetMapping("/{id}")
    public Feedback getFeedbackById(@PathVariable Long id){
        return feedbackService.getFeedbackById(id);
    }

    @PutMapping("/{id}")
    public Feedback updateFeedback(@PathVariable Long id, @Valid  @RequestBody FeedbackRequest feedbackRequest){
        return feedbackService.updatFeedback(id, feedbackRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteFeedback(@PathVariable Long id){
        feedbackService.deleteFeedback(id);
    }

    @GetMapping("/my")
public List<Feedback> getMyFeedback(Authentication authentication) {

    String email = authentication.getName();

    return feedbackService.getMyFeedback(email);
}
    
}

package com.feedbackarena.feedbackarena.service;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.feedbackarena.feedbackarena.dto.FeedbackRequest;
import com.feedbackarena.feedbackarena.exception.FeedbackNotFoundException;
import com.feedbackarena.feedbackarena.model.Feedback;
import com.feedbackarena.feedbackarena.model.User;
import com.feedbackarena.feedbackarena.repository.FeedbackRepository;
import com.feedbackarena.feedbackarena.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor 
public class FeedbackService {
    
    private final FeedbackRepository feedbackRepository;
    private final UserRepository userRepository;

    public List<Feedback> getAllFeedback() {
        return feedbackRepository.findAll(
            Sort.by(Sort.Direction.DESC, "id")
        );
    }

    public Feedback createFeedback(FeedbackRequest feedbackRequest, String email) {
        Feedback feedback = new Feedback();

        feedback.setTitle(feedbackRequest.getTitle());
        feedback.setDescription(feedbackRequest.getDescription());
        feedback.setStatus(feedbackRequest.getStatus());

        User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));

    feedback.setUser(user);

        return feedbackRepository.save(feedback);
    }


    public Feedback getFeedbackById(Long id){
    return feedbackRepository.findById(id)
    .orElseThrow(() -> new FeedbackNotFoundException("Feedback not found"));
    }

    public Feedback updatFeedback(Long id, FeedbackRequest feedbackRequest){
        Feedback feedback = feedbackRepository.findById(id)
        .orElseThrow(() -> new FeedbackNotFoundException("Feedback not found"));

        feedback.setTitle(feedbackRequest.getTitle());
        feedback.setDescription(feedbackRequest.getDescription());
        feedback.setStatus(feedbackRequest.getStatus());

        return feedbackRepository.save(feedback);
    }

    public void deleteFeedback(Long id){
        Feedback feedback = feedbackRepository.findById(id)
        .orElseThrow(() -> new FeedbackNotFoundException("Feedback not found"));

        feedbackRepository.delete(feedback);
    }

    public List<Feedback> getMyFeedback(String email) {

    User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));

    return feedbackRepository.findByUserIdOrderByIdDesc(user.getId());
}
}


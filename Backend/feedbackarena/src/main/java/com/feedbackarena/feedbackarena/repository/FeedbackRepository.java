package com.feedbackarena.feedbackarena.repository;

import com.feedbackarena.feedbackarena.model.Feedback;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {

    List<Feedback> findByUserId(Long userId);

    List<Feedback> findByUserIdOrderByIdDesc(Long userId);
}

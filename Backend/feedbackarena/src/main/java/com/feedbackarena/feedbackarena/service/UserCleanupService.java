package com.feedbackarena.feedbackarena.service;

import java.time.LocalDateTime;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.feedbackarena.feedbackarena.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserCleanupService {

    private final UserRepository userRepository;

    @Scheduled(fixedRate = 60000)
    public void deleteExpiredUnverifiedUsers() {
        
        LocalDateTime now = LocalDateTime.now();

        userRepository.deleteByEmailVerifiedFalseAndVerificationCodeExpiryBefore(now);
    }
}
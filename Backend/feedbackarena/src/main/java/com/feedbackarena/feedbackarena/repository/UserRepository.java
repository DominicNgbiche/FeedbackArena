package com.feedbackarena.feedbackarena.repository;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.feedbackarena.feedbackarena.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    void deleteByEmailVerifiedFalseAndVerificationCodeExpiryBefore(LocalDateTime now);
}

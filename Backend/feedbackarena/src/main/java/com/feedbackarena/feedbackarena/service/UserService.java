package com.feedbackarena.feedbackarena.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.feedbackarena.feedbackarena.model.User;
import com.feedbackarena.feedbackarena.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service 
@RequiredArgsConstructor 
public class UserService {
    
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final JwtService jwtService;
    private final SecureRandom secureRandom = new SecureRandom();

    public User createUser(String email, String password){
        if(userRepository.findByEmail(email).isPresent()){
            throw new RuntimeException("User already registered");
        }

        User user = new User();

        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));

        int code = secureRandom.nextInt(1000000);
        String verificationCode = String.format("%06d", code);

        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(15);

        user.setVerificationCode(verificationCode);
        user.setVerificationCodeExpiry(expiryTime);
        user.setEmailVerified(false);
        user.setRole("USER");

        User savedUser = userRepository.save(user);

        emailService.sendEmailVerification(savedUser.getEmail(), savedUser.getVerificationCode());

        return savedUser;
    }

    public void verifyEmail(String email, String verificationCode){
        User user = userRepository.findByEmail(email)
        .orElseThrow(() -> new RuntimeException("User not found"));

        if(user.isEmailVerified()){
            throw new RuntimeException("Email already verified");
        }

        if (!user.getVerificationCode().equals(verificationCode)) {
        throw new RuntimeException("Invalid verification code");
    }

    if (LocalDateTime.now().isAfter(user.getVerificationCodeExpiry())) {
        if(!user.isEmailVerified()){
            userRepository.delete(user);
        }

        throw new RuntimeException("Verification code has expired. Please sign up again");
    }

    user.setEmailVerified(true);
    user.setVerificationCode(null);
    user.setVerificationCodeExpiry(null);

    userRepository.save(user);
    }


    public User loginUser(String email, String password) {

    User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Invalid email or password"));

    if (!user.isEmailVerified()) {
        throw new RuntimeException("Please verify your email first");
    }

    if (!passwordEncoder.matches(password, user.getPassword())) {
        throw new RuntimeException("Invalid email or password");
    }

    return user;
}

public User promoteToAdmin(String email) {

    User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));

    if (!user.isEmailVerified()) {
        throw new RuntimeException("User must verify their email before becoming an admin");
    }

    if ("ADMIN".equals(user.getRole()) || "SUPER_ADMIN".equals(user.getRole())) {
    throw new RuntimeException("User is already an admin or super admin");
}

    user.setRole("ADMIN");

    return userRepository.save(user);
}

public User demoteToUser(String email, String currentAdminEmail) {

    if (email.equals(currentAdminEmail)) {
        throw new RuntimeException("You cannot demote yourself");
    }

    User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));

    if ("SUPER_ADMIN".equals(user.getRole())) {
        throw new RuntimeException("SUPER_ADMIN cannot be demoted");
    }

    if (!"ADMIN".equals(user.getRole())) {
        throw new RuntimeException("User is not an admin");
    }

    user.setRole("USER");

    return userRepository.save(user);
}
}

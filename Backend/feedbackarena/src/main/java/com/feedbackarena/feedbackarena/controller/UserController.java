package com.feedbackarena.feedbackarena.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.feedbackarena.feedbackarena.dto.AuthResponse;
import com.feedbackarena.feedbackarena.dto.LoginRequest;
import com.feedbackarena.feedbackarena.dto.SignUpRequest;
import com.feedbackarena.feedbackarena.dto.VerifyEmailRequest;
import com.feedbackarena.feedbackarena.model.User;
import com.feedbackarena.feedbackarena.service.JwtService;
import com.feedbackarena.feedbackarena.service.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class UserController {

    private final UserService userService;
    private final JwtService jwtService;

    @PostMapping("/signup")
    public AuthResponse signUp(@Valid @RequestBody SignUpRequest signupRequest){
        User user = userService.createUser(signupRequest.getEmail(), signupRequest.getPassword());

        AuthResponse authResponse = new AuthResponse();

        authResponse.setEmail(user.getEmail());
        authResponse.setEmailVerified(user.isEmailVerified());
        authResponse.setId(user.getId());
        authResponse.setRole(user.getRole());

        return authResponse;
    }
    

    @PostMapping("/verify")
    public String verifyEmail(@Valid @RequestBody VerifyEmailRequest verifyEmailRequest){

        userService.verifyEmail(verifyEmailRequest.getEmail(), verifyEmailRequest.getVerificationCode());

        return "Email verified successfully";
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest loginRequest){
        User user = userService.loginUser(loginRequest.getEmail(), loginRequest.getPassword());

        String token = jwtService.generateToken(user.getEmail(), user.getRole());
        
        AuthResponse authResponse = new AuthResponse();

        authResponse.setEmail(user.getEmail());
        authResponse.setEmailVerified(user.isEmailVerified());
        authResponse.setId(user.getId());
        authResponse.setRole(user.getRole());
        authResponse.setToken(token);

        return authResponse;
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
@PutMapping("/promote-admin")
public User promoteToAdmin(@RequestParam String email) {
    return userService.promoteToAdmin(email);
}

@PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
@PutMapping("/demote-user")
public User demoteToUser(
        @RequestParam String email,
        Authentication authentication
) {
    String currentAdminEmail = authentication.getName();

    return userService.demoteToUser(email, currentAdminEmail);
}
}

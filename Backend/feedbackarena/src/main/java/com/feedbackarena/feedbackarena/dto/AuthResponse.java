package com.feedbackarena.feedbackarena.dto;

import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter 
public class AuthResponse {
    
    private Long id;

    private String email;

    private String role;

    private boolean emailVerified;

    private String token;
}

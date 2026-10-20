package com.feedbackarena.feedbackarena.security;

import org.springframework.web.filter.OncePerRequestFilter;

import com.feedbackarena.feedbackarena.service.JwtService;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import java.util.Collections;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor 
public class JwtAuthenticationFilter extends OncePerRequestFilter{
    
    private final JwtService jwtService;

    @Override 
    protected void doFilterInternal(
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");

        if(authHeader == null || !authHeader.startsWith("Bearer ")){
            filterChain.doFilter(request, response);
            return;
        }

        String jwt = authHeader.substring(7);

        if (jwtService.isTokenValid(jwt)) {
    String email = jwtService.extractEmail(jwt);
    String role = jwtService.extractRole(jwt);



    UsernamePasswordAuthenticationToken authentication =
            new UsernamePasswordAuthenticationToken(
                    email,
                    null,
                    java.util.Collections.singletonList(
        new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_" + role)
)
            );

                System.out.println("JWT email: " + email);
System.out.println("JWT role: " + role);
System.out.println("Authorities: " + authentication.getAuthorities());

    SecurityContextHolder.getContext().setAuthentication(authentication);
    

    
}

        filterChain.doFilter(request, response);
    }
}

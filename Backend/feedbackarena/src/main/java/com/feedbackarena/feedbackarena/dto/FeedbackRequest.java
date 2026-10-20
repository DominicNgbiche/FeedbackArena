package com.feedbackarena.feedbackarena.dto;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter 
public class FeedbackRequest {
    
    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Description is required")
    @Size(max = 1000, message = "Description must not exceed 1000 characters")
    private  String description;

    @NotBlank(message = "Status is required")
    @Size(max = 40, message = "Status must not exceed 40 characters")
    private String status;
}

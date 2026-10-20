package com.feedbackarena.feedbackarena;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class FeedbackarenaApplication {

	public static void main(String[] args) {
		SpringApplication.run(FeedbackarenaApplication.class, args);
	}

}

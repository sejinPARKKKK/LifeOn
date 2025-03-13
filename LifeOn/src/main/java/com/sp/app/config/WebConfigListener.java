package com.sp.app.config;

import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.sp.app.admin.service.VisitorCounter;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class WebConfigListener {
	
	@Bean
	public ServletListenerRegistrationBean<VisitorCounter> sessionListener(){
		 ServletListenerRegistrationBean<VisitorCounter> listener = new ServletListenerRegistrationBean<>();
         listener.setListener(new VisitorCounter());
         return listener;
	}
}

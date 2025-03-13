package com.sp.app.config;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.sp.app.interceptor.LoginCheckInterceptor;

@Configuration
public class SpringMvcConfiguration implements WebMvcConfigurer {
	
	public void addInterceptors(InterceptorRegistry registry) {
		List<String> excludePaths = new ArrayList<>();
		
		excludePaths.add("/");
		excludePaths.add("/dist/**");
		excludePaths.add("/member/login");
		excludePaths.add("/member/logout");
		excludePaths.add("/member/join");
		excludePaths.add("/member/idCheck");
		excludePaths.add("/member/nickNameCheck");
		excludePaths.add("/member/complete");
		excludePaths.add("/member/idFind");
		excludePaths.add("/member/authCodeCheckId");
		excludePaths.add("/member/idFindComplete");
		excludePaths.add("/member/pwdFind");
		excludePaths.add("/member/authCodeCheckPwd");
		excludePaths.add("/member/pwdSet");
		excludePaths.add("/member/sendAuthCode");
		excludePaths.add("/member/");
		excludePaths.add("/uploads/**");
		excludePaths.add("/uploadPath/**");
		
		excludePaths.add("/lounge1/room");
		excludePaths.add("/lounge1/recipe");
		excludePaths.add("/lounge2/tip");
		excludePaths.add("/lounge2/daily");
		
		excludePaths.add("/market/rent/main");
		
		excludePaths.add("/help");
		excludePaths.add("/lifeon/info");
		
		registry.addInterceptor(new LoginCheckInterceptor())
			.excludePathPatterns(excludePaths);
	}
}

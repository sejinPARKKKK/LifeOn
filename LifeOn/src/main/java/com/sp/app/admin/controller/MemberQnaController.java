package com.sp.app.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/memberQna/*")
public class MemberQnaController {

	@GetMapping("list")
	public String memberQna() throws Exception {
		
		return "admin/memberQna/list";
	}
}

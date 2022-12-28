package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import kr.or.ddit.service.AdminService;


@Controller
public class AdminController {
	@Autowired
	AdminService adminService;
	
}

package kr.or.ddit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/git")
@Controller
public class GitController {
	
	@GetMapping("/gitRepo")
	public String gittest() {
		return "Git/Git";
	}
}

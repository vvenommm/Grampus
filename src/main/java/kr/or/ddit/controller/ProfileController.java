package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.ProfileService;
import kr.or.ddit.vo.ProfileVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/profile")
@Controller
public class ProfileController {
	
	@Autowired
	ProfileService profileService;


}

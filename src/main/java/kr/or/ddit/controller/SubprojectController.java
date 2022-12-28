package kr.or.ddit.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.SubprojectService;
import kr.or.ddit.vo.SubprojectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/subproj")
@Controller
public class SubprojectController {

	@Inject
	SubprojectService subpService;
	
	@RequestMapping("/getGrpList")
	public List<SubprojectVO> getGrpList (int projId) {
		return this.subpService.getGrpList(projId);
	}
	
	@ResponseBody
	@RequestMapping("/newSprojTtl")
	public int newSprojTtl(@RequestBody SubprojectVO spvo, HttpServletRequest request) {
		log.info("        그룹명 바꾸는 spvo : " + spvo);
		
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		spvo.setProjId(projId);
		
		int result = this.subpService.newSprojTtl(spvo);
		
		return result;
	}
}

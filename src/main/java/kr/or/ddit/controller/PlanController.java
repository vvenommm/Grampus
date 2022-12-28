package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.PlanService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.vo.PlanVO;
import kr.or.ddit.vo.ProjectVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PlanController {
	
	@Autowired
	PlanService planService;
	
	@Autowired
	ProjectService projectService;

	//1. 플랜 조회
	@GetMapping("/plan")
	public ModelAndView planList(ModelAndView mav, HttpServletRequest request) {
//		public String planList(Model model) {
		log.info("                        planList                        ");
		
		//데이터 가져오기
		List<Map<String, Object>> planList = this.planService.planList();
		log.info("         planLIst 값 있나요? " + planList);
		
		//내가 개설한 프로젝트 중 현재 진행 중인 프로젝트 제목 리스트
		HttpSession session = request.getSession();
		String memNo = (String)session.getAttribute("memNo");
		ProjectVO pvo = new ProjectVO();
		List<ProjectVO> projMadeByMe = new ArrayList<ProjectVO>();
		if(memNo != null) {
			pvo.setMemNo(memNo);
			projMadeByMe = this.projectService.projMadeByMe(pvo);
		}
		log.info("          projMadeByMe : " + projMadeByMe);
		
		//null 확인
		if(planList != null && planList.size() > 0) {
			mav.addObject("planList", planList);
		}
			
		//null 확인
		if(projMadeByMe != null && projMadeByMe.size() > 0) {
			mav.addObject("projMadeByMe", projMadeByMe);
		}
		
		mav.setViewName("plan");
		return mav;
	}
	
	//2. 플랜 등록
	
	//3. 플랜 수정
	@ResponseBody
	@PostMapping("/updatePrice")
	public Map<String, Object> updatePrice(@RequestBody Map<String, Integer> map) {
		log.info("/updatePrice           planVO" + map);
		Map<String, Object> result = new HashMap<String, Object>();
		
		int cnt = this.planService.updatePrice(map);
		log.info("           cnt " + cnt);
		
		if(cnt > 0) {
			result = this.planService.planOne(map.get("planId"));
			log.info("result         : " + result);
		}else {
			result.put("planId", "0");
		}
		
		return result;
	}
	
	//4. 플랜 삭제
}

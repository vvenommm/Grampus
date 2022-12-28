package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.CalendarService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.vo.CalendarVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/calendar")
public class CalendarController {
	@Autowired
	CalendarService calendarService;
	
	@Autowired
	TaskService taskService;
	
	@Inject
	ProMemService proMemService;
	
	@GetMapping("/myCalendar/{projId}/{pmemGrp}")
	public String myCalendar(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, HttpServletRequest request, Model model) {
		//세션 아이디 저장
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", pmemGrp);
		
		//설정 버튼 보이게 할지 말지 구분하는 값 불러와서 보내기
		ProMemVO pvo = new ProMemVO();
		pvo.setProjId(projId);
		pvo.setMemNo((String)session.getAttribute("memNo"));
		ProMemVO amIPM = this.proMemService.iAmPm(pvo);
		int pm = 0;
		if(amIPM != null) pm = amIPM.getPm();
		log.info("           난 pm인가? : " + pm);
		pvo.setPm(pm);
		session.setAttribute("iamPM", pvo);
		log.info("           난 pm인가?pvo : " + pvo);
		
		return "calendar/myCalendar";
	}
	
	//개인 일정 가져오기
	@PostMapping("/selectCalendar")
	@ResponseBody
	public List<Map<String, Object>> selectCalendar(HttpServletRequest request, Model model) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("memNo", vo.getMemNo());
		
		List<Map<String, Object>> mySchedule = this.calendarService.selectCalendar(map);
		log.info("     mySchedule : {} ", mySchedule);
		return mySchedule;
	}
	
	//그룹 일정 가져오기
	@PostMapping("/selectCalendarGrp")
	@ResponseBody
	public List<Map<String, Object>> selectCalendarGrp(HttpServletRequest request, ModelAndView mav) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		String pmemGrp = (String)session.getAttribute("grp");
		
		//로그인한 사람의 프로젝트 내 역할에 따라 구분
		ProMemVO promemVO = new ProMemVO();
		promemVO.setMemNo(vo.getMemNo());
		promemVO.setProjId(projId);
		promemVO.setPmemGrp(pmemGrp);
		List<ProMemVO> roleList = this.taskService.checkRole(promemVO);
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("projId", projId);
		
		String role = "";
		for(int i = 0; i < roleList.size(); i++) {
			role = "R01";
		}
		
		if(role.equals("R01")) {		//PM이라면
			list = this.calendarService.groupCalendarPm(map);
		}else {
			map.put("pmemGrp", pmemGrp);		
			list = this.calendarService.groupCalendarOther(map);
		}
		log.info("     그룹 일정 list : {} ", list);
		
		mav.addObject("list", list);
		mav.setViewName("redirect:/calendar/myCalendar");
		
		return list;
	}
	
	//일정 삭제
	@GetMapping("/deleteCalendar")
	@ResponseBody
	public void deleteCalendar(String calNo) {
		log.info("calNo : " + calNo);
		int result = this.calendarService.deleteCalendar(calNo);
		if(result > 0) {
			return;
		}
	}
	
	//일정 모두 삭제
	@GetMapping("/deleteAllCalendar")
	public String deleteAllCalendar() {
		this.calendarService.deleteAllCalendar();
		return "calendar/myCalendar";
	}
	
	//일정 수정
	@PostMapping("/updateCalendar")
	@ResponseBody
	public int updateCalendar(@RequestBody CalendarVO calendarVO, HttpServletRequest request) {
		log.info("왔다");
		
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("memNo", vo.getMemNo());
		map.put("pmemGrp", session.getAttribute("grp"));		
		
		int loginPmemcd = this.calendarService.selectPmemCd(map);
		calendarVO.setPmemCd(loginPmemcd);
		
		int result = this.calendarService.updateCalendar(calendarVO);
		return result;
	}
	
	//일정 등록
	@PostMapping("/createCalendar")
	@ResponseBody
	public int createCalendar(@RequestBody CalendarVO calendarVO, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("memNo", vo.getMemNo());
		map.put("pmemGrp", session.getAttribute("grp"));		//프로젝트 멤버 코드 받기
		int loginPmemcd = this.calendarService.selectPmemCd(map);
		
		calendarVO.setPmemCd(loginPmemcd);
		
		int result = this.calendarService.createCalendar(calendarVO);
		return result;
	}
	
	//달력번호 가져오기
	@GetMapping("/maxcalNo")
	@ResponseBody
	public String maxcalNo() {
		String calNo = calendarService.maxcalNo();
		return calNo;
	}
	
}

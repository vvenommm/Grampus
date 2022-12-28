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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.HistoryService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.util.PageVO;
import kr.or.ddit.vo.HistoryVO;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;
import oracle.net.aso.r;

@RequestMapping("/task")
@Slf4j
@Controller
public class TaskController {
	@Autowired
	TaskService taskService;
	@Autowired 
	ProMemService proMemService;
	@Inject
	ProjectService projectService;
	@Inject
	MemberService memService;
	@Inject
	HistoryService historyService;
	@Inject
	AlertService alertService;
	
	//일감 메인 (그룹 버전)-------------------------------------------------------------------------
	@RequestMapping("/taskMain/{projId}/{pmemGrp}")
	public String taskMain(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, 
			Model model, HttpServletRequest request, @RequestParam(defaultValue = "1") int currentPage) {
		
		//---------------------------------------------------------------------
		
		//세션 아이디 가져오기 & 저장하기
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", pmemGrp);
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
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
		
		//브레드크럼에 쓰일 값
		Map<String, Object> breadcrumb = new HashMap<String, Object>();
		breadcrumb.put("projId", projId);
		breadcrumb.put("grp", pmemGrp);
		breadcrumb.put("memNo", session.getAttribute("memNo"));
		Map<String, Object> projVO = this.projectService.projMain(breadcrumb);
		session.setAttribute("projVO", projVO);
		
		
		//로그인한 사람의 프로젝트 내 역할에 따라 구분
		ProMemVO promemVO = new ProMemVO();
		promemVO.setMemNo(vo.getMemNo());
		promemVO.setProjId(projId);
		promemVO.setPmemGrp(pmemGrp);
		List<ProMemVO> roleList = this.taskService.checkRole(promemVO);
		String role = "";
		
		List<TaskVO> list = new ArrayList<TaskVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		TaskVO taskVO = new TaskVO();

		map.put("projId", projId);
		int countTask = 0;
		int countTaskIng = 0;
		int countTaskDone = 0;
		int countTaskApprove = 0;
		int countTaskReject = 0;
		
		double allPercent = 0;
		double ingPercent = 0;
		double donePercent = 0;
		double approvePercent = 0;
		double rejectPercent = 0;
		
		taskVO.setProjId(projId);
		
		int count1 = 0;
		int count2 = 0;
		
		for(int i = 0; i < roleList.size(); i++) {
			if(roleList.get(i).getRoleId().equals("R01")) {
				role = "R01";
			}
		}
		
		map.put("pmemGrp", pmemGrp);
		taskVO.setPmemGrp(pmemGrp);
		
		//전체 일감 개수
		countTask = this.taskService.countTask2(taskVO);
		//진행 중 일감 개수
		countTaskIng = this.taskService.countTaskIng2(taskVO);
		//완료 일감 개수
		countTaskDone = this.taskService.countTaskDone2(taskVO);
		//승인 일감 개수
		countTaskApprove = this.taskService.countTaskApprove2(taskVO);
		//반려 일감 개수
		countTaskReject = this.taskService.countTaskReject2(taskVO);

		//--------------------------------------------------------------------------------------------------------------------------------------------------------
		//개수 계산
		//전월 대비 증가율(전체 일감)
		Map<String, Integer> allMap = this.taskService.allPercent2(map);
		if(String.valueOf(allMap.get("COUNT1")) == null || String.valueOf(allMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(allMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(allMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(allMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(allMap.get("COUNT2")));	//이번달
			}
		}
		allPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
				
		//전월 대비 증가율(진행 일감)
		Map<String, Integer> ingMap = this.taskService.ingPercent2(map);
		if(String.valueOf(ingMap.get("COUNT1")) == null || String.valueOf(ingMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(ingMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(ingMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(ingMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(ingMap.get("COUNT2")));	//이번달
			}
		}
		ingPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
				
		//전월 대비 증가율(완료 일감)
		Map<String, Integer> doneMap = this.taskService.donePercent2(map);
		if(String.valueOf(doneMap.get("COUNT1")) == null || String.valueOf(doneMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(doneMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(doneMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(doneMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(doneMap.get("COUNT2")));	//이번달
			}
		}
		donePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
		
		//전월 대비 증가율(승인 일감)
		Map<String, Integer> approveMap = this.taskService.approvePercent2(map);
		if(String.valueOf(approveMap.get("COUNT1")) == null || String.valueOf(approveMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(approveMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(approveMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(approveMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(approveMap.get("COUNT2")));	//이번달
			}
		}
		approvePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
		
		//전월 대비 증가율(반려 일감)
		Map<String, Integer> rejectMap = this.taskService.rejectPercent2(map);
		if(String.valueOf(rejectMap.get("COUNT1")) == null || String.valueOf(rejectMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(rejectMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(rejectMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT2")));	//이번달
			}
		}
		rejectPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
			
		//해당 팀의 멤버 출력
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);

		List<Map<String, Object>> memList = this.taskService.sameGrpMem(map);
		model.addAttribute("memList", memList);			//같은 그룹 멤버 출력
		
		//해당 프로젝트의 모든 그룹 가져오기
		List<Map<String, Object>> grpList = new ArrayList<Map<String,Object>>(); 
		grpList = this.projectService.grpList(projId);
		
		log.info("taskList?? : " + list);
		
		model.addAttribute("countTask", countTask);
		model.addAttribute("countTaskIng", countTaskIng);
		model.addAttribute("countTaskDone", countTaskDone);
		model.addAttribute("countTaskApprove", countTaskApprove);
		model.addAttribute("countTaskReject", countTaskReject);
		
		allPercent = Math.round(allPercent*100) / 100.0;
		ingPercent = Math.round(ingPercent*100) / 100.0;
		donePercent = Math.round(donePercent*100) / 100.0;
		approvePercent = Math.round(approvePercent*100) / 100.0;
		rejectPercent = Math.round(rejectPercent*100) / 100.0;
		
		model.addAttribute("allPercent", allPercent);
		model.addAttribute("ingPercent", ingPercent);
		model.addAttribute("donePercent", donePercent);
		model.addAttribute("approvePercent", approvePercent);
		model.addAttribute("rejectPercent", rejectPercent);
		
		
		////////////////////////////////////////////////////////////////////////// 페이징 시작
		int total = this.taskService.totalPages(map);
		log.info("     131번째 줄 페이징 total 전체 글 갯수 : " + total);
		Map<String, Object> mappp = new HashMap<String, Object>();
		mappp.put("projId", projId);
		mappp.put("pmemGrp", pmemGrp);
		mappp.put("currentPage", currentPage);
		mappp.put("show", 20);
		mappp.put("chkP", 1);
		list = this.taskService.taskList2(mappp);
		
		PageVO page = new PageVO(total, currentPage, 20, 5, list);
		log.info("     페이지!!!! : " + page.toString());
		model.addAttribute("list", page);
		model.addAttribute("total", total);
		////////////////////////////////////////////////////////////////////////// 페이징 끄읕
		
		model.addAttribute("taskList", list); //일감 리스트
		
		model.addAttribute("grpList", grpList);		//그룹 리스트
		model.addAttribute("pmemGrp", pmemGrp);		//로그인한 사람이 속한 그룹
		model.addAttribute("role", role);			//로그인한 사람 역할 구분
		
		return "task/taskMain";
	}
	
	//모두 카테고리 선택 시 일감 목록
	@PostMapping("/taskList")
	@ResponseBody
	public List<TaskVO> taskList(HttpServletRequest request, @RequestParam(defaultValue = "1") int currentPage) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", session.getAttribute("projId"));
		map.put("currentPage", currentPage);
		map.put("show", 20);
		map.put("chkP", 1);
		List<TaskVO> taskList = this.taskService.taskList(map);
		
		return taskList;
	}
	
	//각 상태별 일감 개수 구하기(모두인 경우)
	@PostMapping("/tasks") 
	@ResponseBody
	public Map<String, Object> tasks(HttpServletRequest request, Model model, ModelAndView mav) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		TaskVO taskVO = new TaskVO();
		int countTask = 0;
		int countTaskIng = 0;
		int countTaskDone = 0;
		int countTaskApprove = 0;
		int countTaskReject = 0;
		
		double allPercent = 0;
		double ingPercent = 0;
		double donePercent = 0;
		double approvePercent = 0;
		double rejectPercent = 0;
		
		taskVO.setProjId(projId);
		
		int count1 = 0;
		int count2 = 0;
		
		//전체 일감 개수
		countTask = this.taskService.countTask(taskVO);
		//진행 중 일감 개수
		countTaskIng = this.taskService.countTaskIng(taskVO);
		//완료 일감 개수
		countTaskDone = this.taskService.countTaskDone(taskVO);
		//승인 일감 개수
		countTaskApprove = this.taskService.countTaskApprove(taskVO);
		//반려 일감 개수
		countTaskReject = this.taskService.countTaskReject(taskVO);

		//----------------------------------------------------------------------------------------------------------------------------------------------------
		//전월 대비 증가율(전체 일감)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);

		Map<String, Integer> allMap = this.taskService.allPercent(map);
		log.info("allMap : " + allMap);
		if(String.valueOf(allMap.get("COUNT1")) == null || String.valueOf(allMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(allMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(allMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(allMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(allMap.get("COUNT2")));	//이번달
			}
		}
		allPercent =  Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
				
		//전월 대비 증가율(진행 일감)
		Map<String, Integer> ingMap = this.taskService.ingPercent(map);
		if(String.valueOf(ingMap.get("COUNT1")) == null || String.valueOf(ingMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(ingMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(ingMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(ingMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(ingMap.get("COUNT2")));	//이번달
			}
		}
		ingPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
				
		//전월 대비 증가율(완료 일감)
		Map<String, Integer> doneMap = this.taskService.donePercent(map);
		if(String.valueOf(doneMap.get("COUNT1")) == null || String.valueOf(doneMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(doneMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(doneMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(doneMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(doneMap.get("COUNT2")));	//이번달
			}
		}
		donePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
		
		//전월 대비 증가율(승인 일감)
		Map<String, Integer> approveMap = this.taskService.approvePercent(map);
		if(String.valueOf(approveMap.get("COUNT1")) == null || String.valueOf(approveMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(approveMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(approveMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(approveMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(approveMap.get("COUNT2")));	//이번달
			}
		}
		approvePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
		
		//전월 대비 증가율(반려 일감)
		Map<String, Integer> rejectMap = this.taskService.rejectPercent(map);
		if(String.valueOf(rejectMap.get("COUNT1")) == null || String.valueOf(rejectMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(rejectMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(rejectMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT2")));	//이번달
			}
		}
		rejectPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0;
		
		allPercent = Math.round(allPercent*100) / 100.0;
		ingPercent = Math.round(ingPercent*100) / 100.0;
		donePercent = Math.round(donePercent*100) / 100.0;
		approvePercent = Math.round(approvePercent*100) / 100.0;
		rejectPercent = Math.round(rejectPercent*100) / 100.0;
		
		Map<String, Object> resultMap1 = new HashMap<String, Object>();
		resultMap1.put("allPercent", allPercent);
		resultMap1.put("ingPercent", ingPercent);
		resultMap1.put("donePercent", donePercent);
		resultMap1.put("approvePercent", approvePercent);
		resultMap1.put("rejectPercent", rejectPercent);

		resultMap1.put("countTask", countTask);
		resultMap1.put("countTaskIng", countTaskIng);
		resultMap1.put("countTaskDone", countTaskDone);
		resultMap1.put("countTaskApprove", countTaskApprove);
		resultMap1.put("countTaskReject", countTaskReject);
		
		return resultMap1;
	}
	
	//전체 카테고리 선택 시 일감 목록
	@PostMapping("/taskList2")
	@ResponseBody
	public List<TaskVO> taskList2(HttpServletRequest request, @RequestParam(defaultValue = "1") int currentPage) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", session.getAttribute("projId"));
		map.put("pmemGrp", session.getAttribute("grp"));
		map.put("currentPage", currentPage);
		map.put("show", 20);
		map.put("chkP", 1);
		
		List<TaskVO> taskList = this.taskService.taskList2(map);

		int total = this.taskService.totalPagesAll((int)session.getAttribute("projId"));
		PageVO page = new PageVO(total, currentPage, 20, 5, taskList);
		log.info("     taskList2의 페이지vo!!!! : " + page.toString());
		session.setAttribute("list", page);
		
		return taskList;
	}
	
	//각 상태별 일감 개수 구하기(전체인 경우)
	@PostMapping("/tasks2") 
	@ResponseBody
	public Map<String, Object> tasks2(HttpServletRequest request, Model model, ModelAndView mav) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		TaskVO taskVO = new TaskVO();
		int countTask = 0;
		int countTaskIng = 0;
		int countTaskDone = 0;
		int countTaskApprove = 0;
		int countTaskReject = 0;
		
		double allPercent = 0;
		double ingPercent = 0;
		double donePercent = 0;
		double approvePercent = 0;
		double rejectPercent = 0;
		
		taskVO.setProjId(projId);
		taskVO.setPmemGrp(String.valueOf(session.getAttribute("grp")));
		
		int count1 = 0;
		int count2 = 0;
		
		//전체 일감 개수
		countTask = this.taskService.countTask2(taskVO);
		//진행 중 일감 개수
		countTaskIng = this.taskService.countTaskIng2(taskVO);
		//완료 일감 개수
		countTaskDone = this.taskService.countTaskDone2(taskVO);
		//승인 일감 개수
		countTaskApprove = this.taskService.countTaskApprove2(taskVO);
		//반려 일감 개수
		countTaskReject = this.taskService.countTaskReject2(taskVO);
		
		//----------------------------------------------------------------------------------------------------------------------------------------------------
		//전월 대비 증가율(전체 일감)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", session.getAttribute("grp"));
		
		Map<String, Integer> allMap = this.taskService.allPercent2(map);
		
		if(String.valueOf(allMap.get("COUNT1")) == null || String.valueOf(allMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(allMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(allMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(allMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(allMap.get("COUNT2")));	//이번달
			}
		}
		allPercent =  Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
		
		//전월 대비 증가율(진행 일감)
		Map<String, Integer> ingMap = this.taskService.ingPercent2(map);
		if(String.valueOf(ingMap.get("COUNT1")) == null || String.valueOf(ingMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(ingMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(ingMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(ingMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(ingMap.get("COUNT2")));	//이번달
			}
		}
		ingPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
		
		//전월 대비 증가율(완료 일감)
		Map<String, Integer> doneMap = this.taskService.donePercent2(map);
		if(String.valueOf(doneMap.get("COUNT1")) == null || String.valueOf(doneMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(doneMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(doneMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(doneMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(doneMap.get("COUNT2")));	//이번달
			}
		}
		donePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0;
		
		//전월 대비 증가율(승인 일감)
		Map<String, Integer> approveMap = this.taskService.approvePercent2(map);
		if(String.valueOf(approveMap.get("COUNT1")) == null || String.valueOf(approveMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(approveMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(approveMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(approveMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(approveMap.get("COUNT2")));	//이번달
			}
		}
		approvePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0;
		
		//전월 대비 증가율(반려 일감)
		Map<String, Integer> rejectMap = this.taskService.rejectPercent2(map);
		if(String.valueOf(rejectMap.get("COUNT1")) == null || String.valueOf(rejectMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(rejectMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(rejectMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT2")));	//이번달
			}
		}
		rejectPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
		
		allPercent = Math.round(allPercent*100) / 100.0;
		ingPercent = Math.round(ingPercent*100) / 100.0;
		donePercent = Math.round(donePercent*100) / 100.0;
		approvePercent = Math.round(approvePercent*100) / 100.0;
		rejectPercent = Math.round(rejectPercent*100) / 100.0;
		
		Map<String, Object> resultMap1 = new HashMap<String, Object>();
		resultMap1.put("allPercent", allPercent);
		resultMap1.put("ingPercent", ingPercent);
		resultMap1.put("donePercent", donePercent);
		resultMap1.put("approvePercent", approvePercent);
		resultMap1.put("rejectPercent", rejectPercent);
		
		resultMap1.put("countTask", countTask);
		resultMap1.put("countTaskIng", countTaskIng);
		resultMap1.put("countTaskDone", countTaskDone);
		resultMap1.put("countTaskApprove", countTaskApprove);
		resultMap1.put("countTaskReject", countTaskReject);
		
		log.info("resultMap -전체 : " + resultMap1);
		return resultMap1;
	}
	
	//일감 등록 페이지
	@GetMapping("/newTask/{pmemGrp}")
	public String newTask(@PathVariable String pmemGrp) {
		return "task/newTask";
	}
	
	//하위일감 등록 페이지
	@GetMapping("/newChildTask/{taskNo}/{pmemGrp}")
	public String newChildTask(@PathVariable String taskNo, @PathVariable String pmemGrp) {
		return "task/newChildTask";
	}
	
	//하위일감 등록 페이지(일감 상세페이지에서)
	@GetMapping("/newChildTaskInDetail/{taskNo}/{pmemGrp}")
	public String newChildTaskInDetail(@PathVariable String taskNo, @PathVariable String pmemGrp) {
		return "task/newChildTaskInDetail";
	}
	
	//같은 그룹 멤버(담당자 선택) 가져오기
	@PostMapping("/sameGrpMem")
	@ResponseBody
	public List<Map<String, Object>> sameGrpMem(@RequestBody String pmemGrp, ModelAndView mav, Model model, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pmemGrp",  pmemGrp);
		map.put("projId", projId);
		
		List<Map<String, Object>> grpList = this.taskService.sameGrpMem(map);
		
		mav.addObject("grpList", grpList);
		mav.setViewName("redirect:/task/newTask");
		return grpList;
	}
	
	//같은 그룹 멤버(담당자 선택) 가져오기
	@PostMapping("/sameGrpMemUp")
	@ResponseBody
	public List<Map<String, Object>> sameGrpMemUp(@RequestBody String taskNo, ModelAndView mav, Model model, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskNo",  taskNo);
		map.put("projId", projId);
		
		List<Map<String, Object>> grpList = this.taskService.sameGrpMemUp(map);
		
		mav.addObject("grpList", grpList);
		mav.setViewName("redirect:/task/taskDetail/{taskNo}/{pmemGrp}");
		return grpList;
	}
	
	//새 일감 등록
	@PostMapping("/insertTask")
	@ResponseBody
	public int insertTask(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		map.put("projId", projId);
		map.put("pmemGrp", session.getAttribute("grp"));
		
		if(map.get("taskParent") == null || map.get("taskParent") == "") {
			map.put("taskParent", "");
		}
		
		int result = this.taskService.insertTask(map);
		map.put("memNo", vo.getMemNo());
		
		String progress = (String)map.get("taskProgress");
		
		//일감 진행도 100% 수정 시 PL에게 알림
		if(Integer.parseInt(progress) == 100) {
			Map<String, Object> recmap = new HashMap<String, Object>();
			recmap.put("projId", projId);
			recmap.put("pmemGrp", map.get("pmemGrp"));
			String receiver = this.taskService.selectPL(recmap);
			Map<String, Object> projInfo = this.projectService.projInfo(projId);
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", receiver);
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+map.get("pmemGrp")+" 그룹 "+map.get("taskTtl")+" 일감의 진척도가 100% 입니다");
			alertmap.put("altSend", map.get("memNo"));
			alertmap.put("altLink", "/task/taskDetail/"+map.get("taskNo")+"/"+map.get("pmemGrp"));
			this.alertService.alertInsert(alertmap);
		}
		
		return result;
	}
	
	//일감 상세정보 페이지
	@RequestMapping("/taskDetail/{taskNo}/{pmemGrp}")
	public String taskDetail(@PathVariable("taskNo") String taskNo, @PathVariable("pmemGrp") String pmemGrp, Model model, HttpServletRequest request, @RequestParam(value="newProjId", required = false) String newProjId) {
		//세션 정보 가져오기
		HttpSession session = request.getSession();
		
		if(newProjId != null) {
			session.setAttribute("projId", Integer.parseInt(newProjId));
			session.setAttribute("grp", pmemGrp);
		}
		
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		TaskVO taskVO = new TaskVO();
		//일감 상세정보
		taskVO.setProjId(projId);
		taskVO.setTaskNo(taskNo);
		TaskVO voResult = this.taskService.taskDetail(taskVO);
		model.addAttribute("taskVO", voResult);
		
		//하위 일감 검색
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("taskParent", taskNo);
		map.put("pmemGrp", session.getAttribute("grp"));
		
		List<TaskVO> taskChildList = this.taskService.taskChild(map);
		model.addAttribute("taskChildList", taskChildList);

		//상위 일감 검색
		taskVO.setProjId(projId);
		taskVO.setTaskNo(taskNo);
		List<TaskVO> taskParentList = this.taskService.taskParent(taskVO);
		model.addAttribute("taskParentList", taskParentList);
		log.info("taskParentList : " + taskParentList.toString());
		log.info("taskChildList : " + taskChildList.toString());
		
		//승인 반려를 위해 PM인지 권한 체크
		ProMemVO promemVO = new ProMemVO();
		promemVO.setMemNo(vo.getMemNo());
		promemVO.setProjId(projId);
		promemVO.setPmemGrp(pmemGrp);
		List<ProMemVO> roleList  = this.taskService.checkRole(promemVO);
		String roleId = "";
		
		for(int i = 0; i < roleList.size(); i++) {
			if(roleList.get(i).getRoleId().equals("R01")) {
				roleId = "R01";
			}
		}
		model.addAttribute("roleId", roleId);
		
		//해당 일감의 이슈 출력
		List<IssueVO> issueList = this.taskService.onetaskIssue(taskNo);
		model.addAttribute("issueList", issueList);
		
		return "task/taskDetail";
	}
	
	//일감 삭제
	@PostMapping("/deleteTask")
	@ResponseBody
	public int deleteTask(@RequestBody String taskNo, HttpServletRequest request) {
		int result = this.taskService.deleteTask(taskNo);
		
		//history 내역에 insert
		HistoryVO vo = new HistoryVO();
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		String pmemGrp = (String)session.getAttribute("grp");
		MemberVO mvo = (MemberVO)session.getAttribute("loginVO");
		String memNo = mvo.getMemNo();
		
		vo.setProjId(projId);
		vo.setPmemGrp(pmemGrp);
		vo.setMemNo(memNo);
		vo.setHisKey(taskNo);
		log.info("        일감 삭제 vo : " + vo);
		this.historyService.taskDel(vo);
		
		log.info("delete result : "  + result);
		return result;
	}
	
	//삭제된 일감을 상위일감으로 가진 일감의 상위일감 null로 변경
	@PostMapping("/updateTaskParent")
	@ResponseBody
	public int updateTaskParent(@RequestBody String taskNo) {
		int result = this.taskService.updateTaskParent(taskNo);
		return result;
	}
	
	//승인, 반려 처리
	@PostMapping("/updateStts")
	@ResponseBody
	public int updateStts(@RequestBody TaskVO taskVO) {
		log.info("update ===> taskVO : " + taskVO.toString());
		int result = this.taskService.updateStts(taskVO);
		return result;
	}
	
	//일감 수정
	@PostMapping("/updateTask")
	@ResponseBody
	public int updateTask(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		//세션 정보 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		map.put("pmemGrp", session.getAttribute("grp"));
		map.put("projId", projId);
		if(map.get("taskParent") == null) {
			map.put("taskParent", "");
		}
		log.info("map : " + map);
		
		int result = this.taskService.updateTask(map);
	
		map.put("memNo", session.getAttribute("memNo"));
		Map<String, Object> newMap = new HashMap<String, Object>();
		newMap.put("projId", projId);
		newMap.put("memNo", map.get("memNo"));
		newMap.put("pmemGrp", session.getAttribute("grp"));
		
		log.info("update result : " + result);
		
		String progress = (String)map.get("taskProgress");
		
		//일감 진행도 100% 수정 시 PL에게 알림
		if(Integer.parseInt(progress) == 100) {
			Map<String, Object> recmap = new HashMap<String, Object>();
			recmap.put("projId", projId);
			recmap.put("pmemGrp", map.get("pmemGrp"));
			String receiver = this.taskService.selectPL(recmap);
			Map<String, Object> projInfo = this.projectService.projInfo(projId);
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", receiver);
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+map.get("pmemGrp")+" 그룹 "+map.get("taskTtl")+" 일감의 진척도가 100% 입니다");
			alertmap.put("altSend", map.get("memNo"));
			alertmap.put("altLink", "/task/taskDetail/"+map.get("taskNo")+"/"+map.get("pmemGrp"));
			this.alertService.alertInsert(alertmap);
		}
		
		return result;
	}
	
	//일감 메인페이지 카드별 검색
	@PostMapping("/cardSort")
	@ResponseBody
	public List<TaskVO> cardSort(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		//세션 정보 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		if(map.get("pmemGrp").equals("모두")) {
			map.put("grp", "1");
		}
		
		if(map.get("taskStts").equals("전체")) {
			map.put("stts", "1");
		}
		
		map.put("projId", projId);
		List<TaskVO> sortList = this.taskService.cardSort(map);
			
		return sortList;
	}
	
	
	/////////////////////////////////////////////////////////////////////////// 일괄편집 /////////////////////////////////////////////////////////////////
	
	//일괄편집 모달에서 담당자 출력
	@PostMapping("/modalPmemcd")
	@ResponseBody
	public List<Map<String, Object>> modalPmemcd(@RequestBody String taskNo, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskNo", taskNo);
		map.put("projId", session.getAttribute("projId"));
		
		List<Map<String, Object>> pmemList = this.taskService.modalPmemCd(map);
		return pmemList;
	}
	
	//일괄편집 업데이트
	@PostMapping("/updateAll")
	public String updateAll(@ModelAttribute TaskVO taskVO, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		String pmemGrp = (String)session.getAttribute("grp");
		
		//프로젝트멤버코드 구하기
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);

		log.info("taskVO.getTaskNo() : " + taskVO.getTaskNo());
		log.info("taskVO.getTaskPriority() : " + taskVO.getTaskPriority());
		log.info("taskVO.getTaskTtl() : " + taskVO.getTaskTtl());
		log.info("taskVO.getPmemCds() : " + taskVO.getPmemCds());
		log.info("taskVO.getTaskProgresss() : " + taskVO.getTaskProgresss());
		log.info("taskVO.getTaskStts() : " + taskVO.getTaskStts());
		log.info("taskVO.getTaskSdy() : " + taskVO.getTaskSdy());
		log.info("taskVO.getTaskEdy() : " + taskVO.getTaskEdy());
		
		String[] taskNos = taskVO.getTaskNo().split(",");
		String[] taskPris = taskVO.getTaskPriority().split(",");
		String[] taskTtls = taskVO.getTaskTtl().split(",");
		String[] pmemCds = taskVO.getPmemCds().split(",");
		String[] taskPros = taskVO.getTaskProgresss().split(",");
		String[] taskSttss = taskVO.getTaskStts().split(",");
		String[] taskSdys = taskVO.getTaskSdy().split(",");
		String[] taskEdys = taskVO.getTaskEdy().split(",");
		
		for(int i = 0; i < taskNos.length; i++) {
			log.info("taskNos[i] : " + taskNos[i]);
			log.info("taskPris[i] : " + taskPris[i]);
			log.info("taskTtls[i] : " + taskTtls[i]);
			log.info("pmemCds[i] : " + pmemCds[i]);
			log.info("taskPros[i] : " + taskPros[i]);
			log.info("taskSttss[i] : " + taskSttss[i]);
			log.info("taskSdys[i] : " + taskSdys[i]);
			log.info("taskEdys[i] : " + taskEdys[i]);
			
			taskVO.setPmemCd(Integer.parseInt(pmemCds[i]));
			taskVO.setTaskNo(taskNos[i]);
			taskVO.setTaskPriority(taskPris[i]);
			taskVO.setTaskTtl(taskTtls[i]);
			taskVO.setTaskProgress(Integer.parseInt(taskPros[i]));
			taskVO.setTaskStts(taskSttss[i]);
			taskVO.setTaskSdy(taskSdys[i]);
			taskVO.setTaskEdy(taskEdys[i]);
			this.taskService.updateAll(taskVO);
			
			//일감 진행도 100% 수정 시 PL에게 알림
			if(Integer.parseInt(taskPros[i]) == 100) {
				Map<String, Object> recmap = new HashMap<String, Object>();
				recmap.put("projId", projId);
				recmap.put("pmemGrp", pmemGrp);
				String receiver = this.taskService.selectPL(recmap);
				Map<String, Object> projInfo = this.projectService.projInfo(projId);
				MemberVO mvo = (MemberVO)session.getAttribute("loginVO");
				Map<String, Object> alertmap = new HashMap<String, Object>();
				alertmap.put("memNo", receiver);
				alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+pmemGrp+" 그룹 "+taskTtls[i]+" 일감의 진척도가 100% 입니다");
				alertmap.put("altSend", mvo.getMemNo());
				alertmap.put("altLink", "/task/taskDetail/"+taskNos[i]+"/"+pmemGrp);
				this.alertService.alertInsert(alertmap);
			}
		}
		
		model.addAttribute("projId", projId);
		model.addAttribute("pmemGrp", pmemGrp);
		return "redirect:/task/taskMain/{projId}/{pmemGrp}";
	}
	
	
	/////////////////////////////////////////////////////////////////////////// 칸반 /////////////////////////////////////////////////////////////////
	
	//칸반 메인
	@RequestMapping("/kanbanMain/{projId}/{pmemGrp}")
	public String kanbanMain(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, HttpServletRequest request, Model model) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		//로그인한 사람의 프로젝트 내 역할에 따라 구분
		ProMemVO promemVO = new ProMemVO();
		promemVO.setMemNo(vo.getMemNo());
		promemVO.setProjId(projId);
		promemVO.setPmemGrp(pmemGrp);
		List<ProMemVO> roleList = this.taskService.checkRole(promemVO);
		String role = "";
		
		List<TaskVO> list = new ArrayList<TaskVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		TaskVO taskVO = new TaskVO();
		
		map.put("projId", projId);
		
		int countTaskIng5 = 0;
		int countTaskDone5 = 0;
		int countTaskNew5 = 0;
		
		taskVO.setProjId(projId);
		taskVO.setPmemGrp(pmemGrp);
		
		for(int i = 0; i < roleList.size(); i++) {
			if(roleList.get(i).getRoleId().equals("R01")) {
				role = "R01";
			}
		}
		
		map.put("pmemGrp", pmemGrp);
		map.put("chkP", 0);
		list = this.taskService.taskList2(map);
		
		//신규 일감 개수
		countTaskNew5 = this.taskService.countTaskNew2(taskVO);
		//진행 중 일감 개수
		countTaskIng5 = this.taskService.countTaskIng2(taskVO);
		//완료 일감 개수
		countTaskDone5 = this.taskService.countTaskDone2(taskVO);
		
		log.info("kanban taskList : " + list);
		
		model.addAttribute("countTaskNew5", countTaskNew5);
		model.addAttribute("countTaskIng5", countTaskIng5);
		model.addAttribute("countTaskDone5", countTaskDone5);
		model.addAttribute("taskList", list);
		model.addAttribute("pmemGrp", pmemGrp);		//로그인한 사람이 속한 그룹
		
		//전체 일감 개수
		int count1 = 0;
		int count2 = 0;
		
		int countTask = 0;
		int countTaskIng = 0;
		int countTaskDone = 0;
		int countTaskApprove = 0;
		int countTaskReject = 0;
		
		double allPercent = 0;
		double ingPercent = 0;
		double donePercent = 0;
		double approvePercent = 0;
		double rejectPercent = 0;
		
		countTask = this.taskService.countTask2(taskVO);
		//진행 중 일감 개수
		countTaskIng = this.taskService.countTaskIng2(taskVO);
		//완료 일감 개수
		countTaskDone = this.taskService.countTaskDone2(taskVO);
		//승인 일감 개수
		countTaskApprove = this.taskService.countTaskApprove2(taskVO);
		//반려 일감 개수
		countTaskReject = this.taskService.countTaskReject2(taskVO);

		//--------------------------------------------------------------------------------------------------------------------------------------------------------
		//개수 계산
		//전월 대비 증가율(전체 일감)
		Map<String, Integer> allMap = this.taskService.allPercent2(map);
		if(String.valueOf(allMap.get("COUNT1")) == null || String.valueOf(allMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(allMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(allMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(allMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(allMap.get("COUNT2")));	//이번달
			}
		}
		allPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
				
		//전월 대비 증가율(진행 일감)
		Map<String, Integer> ingMap = this.taskService.ingPercent2(map);
		if(String.valueOf(ingMap.get("COUNT1")) == null || String.valueOf(ingMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(ingMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(ingMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(ingMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(ingMap.get("COUNT2")));	//이번달
			}
		}
		ingPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100) * 100) / 100.0; 
				
		//전월 대비 증가율(완료 일감)
		Map<String, Integer> doneMap = this.taskService.donePercent2(map);
		if(String.valueOf(doneMap.get("COUNT1")) == null || String.valueOf(doneMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(doneMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(doneMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(doneMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(doneMap.get("COUNT2")));	//이번달
			}
		}
		donePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
		
		//전월 대비 증가율(승인 일감)
		Map<String, Integer> approveMap = this.taskService.approvePercent2(map);
		if(String.valueOf(approveMap.get("COUNT1")) == null || String.valueOf(approveMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(approveMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(approveMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(approveMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(approveMap.get("COUNT2")));	//이번달
			}
		}
		approvePercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
		
		//전월 대비 증가율(반려 일감)
		Map<String, Integer> rejectMap = this.taskService.rejectPercent2(map);
		if(String.valueOf(rejectMap.get("COUNT1")) == null || String.valueOf(rejectMap.get("COUNT2")) == null) {
			count1 = 1;
			count2 = 1;
		}else {
			if(Integer.parseInt(String.valueOf(rejectMap.get("COUNT1"))) == 0 || Integer.parseInt(String.valueOf(rejectMap.get("COUNT2"))) == 0) {
				count1 = 1;
				count2 = 1;
			}else {
				count1 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT1")));	//전달
				count2 = Integer.parseInt(String.valueOf(rejectMap.get("COUNT2")));	//이번달
			}
		}
		rejectPercent = Math.round(((count2 - count1) / Double.valueOf(count1) * 100.0) * 100) / 100.0; 
			
		//해당 팀의 멤버 출력
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);

		List<Map<String, Object>> memList = this.taskService.sameGrpMem(map);
		model.addAttribute("memList", memList);			//같은 그룹 멤버 출력
		
		//해당 프로젝트의 모든 그룹 가져오기
		List<Map<String, Object>> grpList = new ArrayList<Map<String,Object>>(); 
		grpList = this.projectService.grpList(projId);
		
		log.info("taskList?? : " + list);
		
		model.addAttribute("countTask", countTask);
		model.addAttribute("countTaskIng", countTaskIng);
		model.addAttribute("countTaskDone", countTaskDone);
		model.addAttribute("countTaskApprove", countTaskApprove);
		model.addAttribute("countTaskReject", countTaskReject);
		
		allPercent = Math.round(allPercent*100) / 100.0;
		ingPercent = Math.round(ingPercent*100) / 100.0;
		donePercent = Math.round(donePercent*100) / 100.0;
		approvePercent = Math.round(approvePercent*100) / 100.0;
		rejectPercent = Math.round(rejectPercent*100) / 100.0;
		
		model.addAttribute("allPercent", allPercent);
		model.addAttribute("ingPercent", ingPercent);
		model.addAttribute("donePercent", donePercent);
		model.addAttribute("approvePercent", approvePercent);
		model.addAttribute("rejectPercent", rejectPercent);
		
		return "task/kanbanMain";
	}
	
	//일감 상태 수정
	@PostMapping("/updateKanbanStts")
	@ResponseBody
	public int updateKanbanStts(@RequestBody TaskVO taskVO, HttpServletRequest request) {
		//완료 상태가 아닌 경우의 진척도 처리하기
		if(taskVO.getTaskProgress() == 0) {
			int progress = this.taskService.selectProgress(taskVO.getTaskNo());
			taskVO.setTaskProgress(progress);
		}
		
		//수정하기
		int result = this.taskService.updateKanbanStts(taskVO);
		
		//일감 진행도 100% 수정 시 PL에게 알림
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		if(taskVO.getTaskProgress() == 100) {
			Map<String, Object> recmap = new HashMap<String, Object>();
			recmap.put("projId", projId);
			recmap.put("pmemGrp", session.getAttribute("grp"));
			String receiver = this.taskService.selectPL(recmap);
			Map<String, Object> projInfo = this.projectService.projInfo(projId);
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", receiver);
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+taskVO.getPmemGrp()+" 그룹 "+taskVO.getTaskTtl()+" 일감의 진척도가 100% 입니다");
			alertmap.put("altSend", vo.getMemNo());
			alertmap.put("altLink", "/task/taskDetail/"+taskVO.getTaskNo()+"/"+taskVO.getPmemGrp());
			this.alertService.alertInsert(alertmap);
		}
		
		return result;
	}
	
	//일감 삭제
	@PostMapping("/deleteKanban")
	@ResponseBody
	public int deleteKanban(@RequestBody String taskNo) {
		int result = this.taskService.deleteTask(taskNo);
		return result;
	}
	 
	//상태별 일감 개수
	@PostMapping("/countTask")
	@ResponseBody
	public Map<String, Object> countTask(HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		String pmemGrp = (String)session.getAttribute("grp");	
		log.info("pmemGrp : " + pmemGrp);
		
		TaskVO taskVO = new TaskVO();
		taskVO.setProjId(projId);
		taskVO.setPmemGrp(pmemGrp);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		int countTaskNew = this.taskService.countTaskNew2(taskVO);
		int countTaskIng = this.taskService.countTaskIng2(taskVO);
		int countTaskDone = this.taskService.countTaskDone2(taskVO);
		
		map.put("countTaskNew", countTaskNew);
		map.put("countTaskIng", countTaskIng);
		map.put("countTaskDone", countTaskDone);
		
		return map;
	}
	
	
	
	
	//----------------마이페이지 내 일감 조회 --------------------
		@GetMapping("/mypageTaskList" )
		public String mypageTaskList(TaskVO taskVO, Model model, HttpServletRequest request) {
			log.info("taskVO : " + taskVO.toString());
			
			HttpSession session = request.getSession();
			session.removeAttribute("projId");
			session.removeAttribute("grp");
			
			String memNo = (String)session.getAttribute("memNo");
			taskVO.setMemNo(memNo);
			List<TaskVO> taskVOList = this.taskService.mypageTaskList(taskVO);
			model.addAttribute("taskVOList", taskVOList);
			//내가 참여하고 진행중인 프로젝트리스트
			List<ProjectVO> projVOList = this.projectService.mypageProejctList(memNo);
			model.addAttribute("projVOList", projVOList);
			
			//회원번호 보내기
			MemberVO memberVO =  this.memService.memDetail(memNo);
			model.addAttribute("memberVO", memberVO);
			
			return "mypage/mypageTaskList";
		}
		
		//오늘까지 일감 조회
		@GetMapping("/todayTaskList")
		public String todayTaskList(TaskVO taskVO, Model model, HttpServletRequest request) {
			HttpSession session = request.getSession();
			String memNo = (String)session.getAttribute("memNo");
			taskVO.setMemNo(memNo);
			List<TaskVO> taskVOList =  this.taskService.todayTaskList(taskVO);
			model.addAttribute("taskVOList", taskVOList);
			
			//내가 참여하고 진행중인 프로젝트리스트
			List<ProjectVO> projVOList = this.projectService.mypageProejctList(memNo);
			model.addAttribute("projVOList", projVOList);
					
			return "mypage/todayTaskList";
		}
		
		//지난 일감 조회
		@GetMapping("/endTaskList")
		public String endTaskList(TaskVO taskVO, Model model, HttpServletRequest request) {
			HttpSession session = request.getSession();
			String memNo = (String)session.getAttribute("memNo");
			taskVO.setMemNo(memNo);
			List<TaskVO> taskVOList =  this.taskService.endTaskList(taskVO);
			model.addAttribute("taskVOList", taskVOList);
			//내가 참여하고 진행중인 프로젝트리스트
			List<ProjectVO> projVOList = this.projectService.mypageProejctList(memNo);
			model.addAttribute("projVOList", projVOList);
			
			return "mypage/endTaskList";
		}
		
		//이번주 일감 조회
		@GetMapping("/weekTaskList")
		public String weekTaskList(String memNo, Model model, HttpServletRequest request) {
			HttpSession session = request.getSession();
			MemberVO vo = (MemberVO)session.getAttribute("loginVO");
			List<TaskVO> taskVOList =  this.taskService.weekTaskList(memNo);
			model.addAttribute("taskVOList", taskVOList);
			//내가 참여하고 진행중인 프로젝트리스트
			List<ProjectVO> projVOList = this.projectService.mypageProejctList(memNo);
			model.addAttribute("projVOList", projVOList);
					
			return "mypage/weekTaskList";
		}
		
		//상위 하위 일감 검색
		@ResponseBody
		@PostMapping("/updownSearch")
		public List<Map<String, Object>> updownSearch(@RequestBody Map<String, Object> map){
			List<Map<String, Object>> list = this.taskService.updownSearch(map);
			return list;
		}
	}


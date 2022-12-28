package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@RequestMapping("/gantt")
@Slf4j
@Controller
public class GanttController {
	@Autowired
	TaskService taskService;
	
	@Autowired
	AlertService alertService;
	
	@Autowired
	ProjectService projectService;

	//간트 메인
	@RequestMapping("/ganttMain/{projId}/{pmemGrp}")
	public String ganttMain(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, Model model, HttpServletRequest request) {
		HttpSession session  = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", pmemGrp);
		
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
		
		TaskVO taskVO = new TaskVO();
		Map<String, Object> map = new HashMap<String, Object>();
		
		taskVO.setProjId(projId);
		taskVO.setPmemGrp(pmemGrp);

		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);
		
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
		
		return "gantt/ganttMain";
	}
	
	//일감 출력하기
	@PostMapping("/selectTask")
	@ResponseBody
	public List<TaskVO> selectTask(@RequestBody String pmemGrp, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		int projId = (int)session.getAttribute("projId");
		
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

		taskVO.setProjId(projId);

		for(int i = 0; i < roleList.size(); i++) {
			if(roleList.get(i).getRoleId().equals("R01")) {
				role = "R01";
			}
		}
		map.put("pmemGrp", pmemGrp);
		map.put("chkP", 0);
		list = this.taskService.taskList2(map);
		
		return list;
	}
	
	//모두 카테고리 선택 시 
	@PostMapping("/taskList")
	@ResponseBody
	public List<TaskVO> taskList(HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", session.getAttribute("projId"));
		List<TaskVO> taskList = this.taskService.taskList(map);
		map.put("chkP", 0);
		
		return taskList;
	}
	 
	//바 이동 시 날짜 수정
	@PostMapping("/updateDateGantt")
	@ResponseBody
	public int updateDateGantt(@RequestBody TaskVO taskVO) {
		int result = this.taskService.updateDateGantt(taskVO);
		return result;
	}
	
	//수정창을 통한 수정
	@PostMapping("/updateAllGantt")
	@ResponseBody
	public int updateAllGantt(@RequestBody TaskVO taskVO, HttpServletRequest request) {
		int result = this.taskService.updateAllGantt(taskVO);
		
		//일감 진행도 100% 수정 시 PL에게 알림
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		if(taskVO.getTaskProgress() == 100) {
			Map<String, Object> recmap = new HashMap<String, Object>();
			recmap.put("projId", projId);
			recmap.put("pmemGrp", (String)session.getAttribute("grp"));
			String receiver = this.taskService.selectPL(recmap);
			Map<String, Object> projInfo = this.projectService.projInfo(projId);
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", receiver);
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+(String)session.getAttribute("grp")+" 그룹 "+taskVO.getTaskTtl()+" 일감의 진척도가 100% 입니다");
			alertmap.put("altSend", (String)session.getAttribute("memNo"));
			alertmap.put("altLink", "/task/taskDetail/"+taskVO.getTaskNo()+"/"+(String)session.getAttribute("grp"));
			this.alertService.alertInsert(alertmap);
		}
		
		return result;
	}
	
	//삭제
	@PostMapping("/deleteTask") 
	@ResponseBody
	public int deleteTask(@RequestBody String taskNo) {
		int result = this.taskService.deleteTask(taskNo);
		return result;
	}
	
	//일감 상세정보
	@PostMapping("/taskDetail")
	@ResponseBody
	public TaskVO taskDetail(@RequestBody String taskNo, HttpServletRequest request, Model model, ModelAndView mav) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		String pmemGrp = (String)session.getAttribute("grp");
		int projId = (int)session.getAttribute("projId");
		
		log.info("pmemGrp : " + pmemGrp);
		
		TaskVO vo = new TaskVO();
		vo.setProjId(projId);
		vo.setTaskNo(taskNo);
		
		TaskVO taskVO = this.taskService.taskDetail(vo);
		model.addAttribute("taskVO", taskVO);
		model.addAttribute("pmemGrp", pmemGrp);
		
		return taskVO;
	}
	
	//상위일감 번호 삭제
	@PostMapping("/updateParent")
	@ResponseBody
	public int updateParent(@RequestBody Map<String, Object> map) {
		if(map.get("taskParent").equals("none")) {
			map.put("taskParent", "");
		}
		
		int result = this.taskService.updateParent(map);
		return result;
	}
}

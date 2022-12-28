package kr.or.ddit.controller;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.ApplicantService;
import kr.or.ddit.service.CostService;
import kr.or.ddit.service.JobService;
import kr.or.ddit.service.LicenseService;
import kr.or.ddit.service.MainService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.service.NewsService;
import kr.or.ddit.service.PaymentService;
import kr.or.ddit.service.PlanService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.ResumeService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.vo.AlertVO;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CostVO;
import kr.or.ddit.vo.JobVO;
import kr.or.ddit.vo.LicenseVO;
import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NewsVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.RoleVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmptyController {

	@Autowired
	PlanService planService;
	
	@Autowired
	NewsService service;
	
	@Autowired
	JobService jobService;
	
	
	////////////////////////////////////
	
	
	@Inject
	MemberService memService;
	
	@Autowired
	ProfileService profileService;
	
	@Autowired
	ResumeService resumeService;
	
	@Autowired
	LicenseService licenseService;
	
	@Autowired
	PaymentService paymentService;
	
	@Autowired
	ProMemService proMemService;
	
	@Inject
	CostService costService;
	
	@Inject
	ApplicantService applicantService;
	
	@Inject
	ProjectService projectService;
	
	@Inject
	TaskService taskService;
	
	@Inject
	AlertService alertService;
	
	@Inject
	MainService mainService;
	
	
	
	
	@GetMapping("/main")
	public String main(Model model, @RequestParam Map<String, Object> map,
			@RequestParam(value = "cont", defaultValue = "") String cont, 
			@RequestParam(value = "listcnt", defaultValue = "1") String listcnt, 
			HttpServletRequest request) throws ParseException {
		log.info("main에 왔다");
		HttpSession session = request.getSession();
		
		/*---------------- 뉴스 구현 ----------------*/
		//뉴스 더보기 설정
		map = new HashMap<String, Object>();
		map.put("listcnt", Integer.parseInt(listcnt)*8);
		map.put("memNo",session.getAttribute("memNo"));
		
		List<Map<String, Object>> newsList = this.service.list(map);
		
		
		//select 결과 list를 보냄
		model.addAttribute("list", newsList);
		model.addAttribute("listcnt",Integer.parseInt(listcnt));
		
		
		/*---------------- 플랜 구현 ----------------*/
		log.info("planList");
		
		//플랜 데이터 가져오기
		List<Map<String, Object>> planList = this.planService.planList();
		log.info("planLIst 값 있나요? " + planList);
		
		//플랜 널 값 확인
		if(planList != null && planList.size() > 0) {
			model.addAttribute("planList", planList);
		}

		/*---------------- 구인공고 구현 ----------------*/
		//id 세션값으로
		String id  = (String)session.getAttribute("id");
		map = new HashMap<String, Object>();
		map.put("listcnt", Integer.parseInt(listcnt)*8);
		map.put("scon", cont);
		List<Map<String, Object>> list = jobService.jobList(map);
		for(int i=0; i<list.size(); i++) {
			String[] tech = list.get(i).get("JOB_TECH").toString().trim().split(",");
			list.get(i).put("TECH", tech);
		}
		
		if(id != null) {
			log.info("        id : " + id);
			//북마크
			List<String> mlist = jobService.markList(id);
			model.addAttribute("mList",mlist);
		}

		for(int i=0; i<list.size(); i++) {
			Date wday = (Date) list.get(i).get("JOB_WDY");
			Date eday = (Date) list.get(i).get("JOB_EDY");
			Calendar tday = Calendar.getInstance();
			double calRs = Math.ceil((((double)(tday.getTimeInMillis()-wday.getTime())/(double)(eday.getTime()-wday.getTime()))*100));
			if(calRs>100) {
				calRs = 100.0;
			}
			DecimalFormat format = new DecimalFormat("0.#");
			String result = format.format(calRs);
			list.get(i).put("pers", result);
		}
		model.addAttribute("jobList",list);
		model.addAttribute("listcnt",Integer.parseInt(listcnt));
		
		return "main";
	}
	
	@GetMapping("/grampusIntro")
	public String grampusIntro(){
		return "grampusIntro";
	}
	
	
	//포트폴리오 팝업창
	@RequestMapping("/portfolio/{memNo}")
	public String portfolio(@PathVariable("memNo") String memNo, Model model, TaskVO taskVO, ProjectVO projectVO, JobVO jobVO, AlertVO alertVO, ApplicantVO applicantVO, MainVO mainVO) {
		
		log.info("포트폴리오용 memNo : " + memNo);
		
		MemberVO memberVO =  this.memService.memDetail(memNo);
		ResumeVO resumeVO = this.resumeService.resumeSelect(memNo);
		List<LicenseVO> licenseVOList = this.licenseService.licenseList(memNo);
		List<LicenseVO> licenseVOList2 = this.licenseService.licenseList2(memNo);
		jobVO.setMemNo(memNo);
		jobVO.setScon("");
		List<JobVO> jovVOList = this.jobService.bookMarkList(jobVO);
		List<CostVO> costVOList = this.costService.costList(memNo);
		applicantVO.setMemNo(memNo);
		applicantVO.setScon("");
		List<ApplicantVO> applicantVOList = applicantService.jobApplicantList(applicantVO);
		projectVO.setMemNo(memNo);
		projectVO.setScon("");
		ProjectVO projectVOList = projectService.projIngListCnt(projectVO);
		List<ProjectVO> projectEndVOList = projectService.projEndList(projectVO);
		List<ProjectVO> projectInviteVOList = projectService.inviteProjectList(memNo);
		taskVO.setMemNo(memNo);
		List<TaskVO> taskVOList = this.taskService.mypageTaskList(taskVO);
		List<TaskVO> todayTaskVOList = this.taskService.todayTaskList(taskVO);
		List<TaskVO> weekTaskVOList = this.taskService.weekTaskList(memNo);
		List<TaskVO> endTaskVOList = this.taskService.endTaskList(taskVO);
		alertVO.setMemNo(memNo);
		List<AlertVO> alertVOList = this.alertService.alertListCnt(alertVO);
		
		model.addAttribute("memberVO", memberVO);
		model.addAttribute("resumeVO", resumeVO);
		model.addAttribute("licenseVOList", licenseVOList);
		model.addAttribute("licenseVOList2", licenseVOList2);
		model.addAttribute("jovVOList", jovVOList);
		model.addAttribute("costVOList", costVOList);
		model.addAttribute("applicantVOList", applicantVOList);
		model.addAttribute("projectVOList", projectVOList);
		model.addAttribute("projectEndVOList", projectEndVOList);
		model.addAttribute("projectInviteVOList", projectInviteVOList);
		model.addAttribute("taskVOList", taskVOList);
		model.addAttribute("todayTaskVOList", todayTaskVOList);
		model.addAttribute("weekTaskVOList", weekTaskVOList);
		model.addAttribute("endTaskVOList", endTaskVOList);
		model.addAttribute("alertVOList", alertVOList);
		model.addAttribute("fo", "Y");
		
		//직책
		MainVO myRole= this.mainService.myRole(memberVO);
		model.addAttribute("myRole", myRole);
		log.info("myRole : " + mainVO.toString());
		
		/////////////////////////////////// 완료/승인된 일감 - 내 전체 일감
		TaskVO myTasks = this.mainService.myTasks(memberVO);
		log.info("     도넛 그래프용 vo : " + myTasks);
		
		model.addAttribute("myTasks", myTasks);
		/////////////////////////////////// 완료/승인된 일감 - 내 전체 일감

		//프로젝트
		MainVO myProj = this.mainService.myProj(memberVO);
		model.addAttribute("myProj", myProj);
		log.info("myProj: " + mainVO.toString());
		
		//프로젝트 리스트
		List<ProjectVO> projList = new ArrayList<ProjectVO>();
		projList = this.mainService.projList(memberVO);
		model.addAttribute("projList", projList);
		log.info("projList", projList.toArray());
		
		//일감 리스트
		List<TaskVO> taskList = new ArrayList<TaskVO>();
		taskList = this.mainService.taskList(memberVO);
		model.addAttribute("taskList", taskList);
		log.info("taskList", taskList.toArray());
		
		//직책 리스트
		List<RoleVO> roleList = new ArrayList<RoleVO>();
		roleList = this.mainService.roleList(memberVO);
		model.addAttribute("roleList", roleList);
		log.info("roleList", roleList.toArray());
		
		return "portfolio";
	}
	
}
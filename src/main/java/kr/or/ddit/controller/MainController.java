package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.ApplicantService;
import kr.or.ddit.service.CostService;
import kr.or.ddit.service.JobService;
import kr.or.ddit.service.LicenseService;
import kr.or.ddit.service.MainService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.service.PaymentService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProfileService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.ResumeService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.vo.AlertVO;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CostVO;
import kr.or.ddit.vo.JobVO;
import kr.or.ddit.vo.LicenseVO;
import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/main")
@Controller
public class MainController {
	
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
	JobService jobService;
	
	@Inject
	CostService costService;
	
	@Inject
	ApplicantService applicantService;
	
	@Inject
	ProjectService projectService;
	
	@Inject
	TaskService taskService;
	
	@Inject
	MainService mainService;
	
	
	@GetMapping("/myMain")
	public String home(HttpServletRequest request, String memNo, Model model, MainVO mainVO,TaskVO taskVO, ProjectVO projectVO, JobVO jobVO, ApplicantVO applicantVO,
			@RequestParam(value="no", required = false) String no) {
		HttpSession session = request.getSession();
		memNo = (String)session.getAttribute("memNo");
		taskVO.setMemNo(memNo);
		projectVO.setMemNo(memNo);
		projectVO.setScon("");

		MemberVO memberVO;

		//projId??? grp ????????????
		session.removeAttribute("projId");
		session.removeAttribute("grp");
		session.removeAttribute("fo");
		
		if(no != null) { //?????? ????????? ????????? ?????????
			memNo = no; //????????? ????????? ?????? ????????? memNo??? ????????? ??? ????????? ????????? ?????? ???????????? ????????? ????????????
			
			memberVO =  this.memService.memDetail(memNo);
			List<ProfileVO> profileVOList = this.profileService.profileList(memNo);			
			ResumeVO resumeVO = this.resumeService.resumeSelect(memNo);
			List<LicenseVO> licenseVOList = this.licenseService.licenseList(memNo);
			ProjectVO projectVOList = projectService.projIngListCnt(projectVO);
			List<ProjectVO> projectEndVOList = projectService.projEndList(projectVO);
			List<TaskVO> taskVOList = this.taskService.mypageTaskList(taskVO);
			List<TaskVO> todayTaskVOList = this.taskService.todayTaskList(taskVO);
			
			model.addAttribute("profileVOList", profileVOList);         
			model.addAttribute("memberVO", memberVO);
			model.addAttribute("resumeVO", resumeVO);
			model.addAttribute("licenseVOList", licenseVOList);
			model.addAttribute("projectVOList", projectVOList);
			model.addAttribute("projectEndVOList", projectEndVOList);
			model.addAttribute("taskVOList", taskVOList);
			model.addAttribute("todayTaskVOList", todayTaskVOList);
			
			
		}else { //no??? null?????? ????????? ??? ????????? ??????????????? ??????
		
			//?????? String memId ????????? session?????? ????????? ???????????? ??????????????? ??????!!
			session = request.getSession();
			log.info("session : " + session);
			memNo = (String) session.getAttribute("memNo");
			
			memberVO =  this.memService.memDetail(memNo);
			List<ProfileVO> profileVOList = this.profileService.profileList(memNo);			
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
			
			model.addAttribute("profileVOList", profileVOList);         
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
		}
		
		
		//??????
		session = request.getSession();
		mainVO.setMemNo((String)session.getAttribute("memNo"));
		
		MainVO myRole= this.mainService.myRole(memberVO);
		model.addAttribute("myRole", myRole);
		log.info("myRole : " + mainVO.toString());
		
		/////////////////////////////////// ??????/????????? ?????? - ??? ?????? ??????
		TaskVO myTasks = this.mainService.myTasks(memberVO);
		log.info("     ?????? ???????????? vo : " + myTasks);
		
		model.addAttribute("myTasks", myTasks);
		/////////////////////////////////// ??????/????????? ?????? - ??? ?????? ??????

		//????????????
		MainVO myProj = this.mainService.myProj(memberVO);
		model.addAttribute("myProj", myProj);
		log.info("myProj: " + mainVO.toString());
		
		
		//???????????? ?????????
		List<MainVO> myHisList = new ArrayList<MainVO>();
		myHisList =	this.mainService.myHisList(memberVO);
		model.addAttribute("myHisList", myHisList);
		log.info("myHisList", myHisList.toArray());
		
		//???????????? ?????????
		List<ProjectVO> projList = new ArrayList<ProjectVO>();
		projList = this.mainService.projList(memberVO);
		model.addAttribute("projList", projList);
		log.info("projList", projList.toArray());
		
		//?????? ?????????
		List<TaskVO> taskList = new ArrayList<TaskVO>();
		taskList = this.mainService.taskList(memberVO);
		model.addAttribute("taskList", taskList);
		log.info("taskList", taskList.toArray());
		
		return "main/myMain";
	}
	
	@ResponseBody
	@RequestMapping("/myTasks")
	public TaskVO myTask(@RequestBody MemberVO vo) {
		log.info("    mainController?????? myTask");
		return this.mainService.myTasks(vo);
	}
}

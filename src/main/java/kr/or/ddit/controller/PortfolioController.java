package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.AlertService;
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
import kr.or.ddit.vo.CostVO;
import kr.or.ddit.vo.JobVO;
import kr.or.ddit.vo.LicenseVO;
import kr.or.ddit.vo.MainVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.RoleVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
//@RequestMapping("/portfolio")
@Controller
public class PortfolioController {

	@Autowired
	JobService jobService;
	
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
	
	//포트폴리오 팝업창
//		@RequestMapping("/portfolio/{memNo}")
//		public String portfolio(@PathVariable("memNo") String memNo, Model model, TaskVO taskVO, ProjectVO projectVO, JobVO jobVO, AlertVO alertVO, ApplicantVO applicantVO, MainVO mainVO) {
//			
//			log.info("포트폴리오용 memNo : " + memNo);
//			
//			MemberVO memberVO =  this.memService.memDetail(memNo);
//			ResumeVO resumeVO = this.resumeService.resumeSelect(memNo);
//			List<LicenseVO> licenseVOList = this.licenseService.licenseList(memNo);
//			List<LicenseVO> licenseVOList2 = this.licenseService.licenseList2(memNo);
//			jobVO.setMemNo(memNo);
//			jobVO.setScon("");
//			List<JobVO> jovVOList = this.jobService.bookMarkList(jobVO);
//			List<CostVO> costVOList = this.costService.costList(memNo);
//			applicantVO.setMemNo(memNo);
//			applicantVO.setScon("");
//			List<ApplicantVO> applicantVOList = applicantService.jobApplicantList(applicantVO);
//			projectVO.setMemNo(memNo);
//			projectVO.setScon("");
//			ProjectVO projectVOList = projectService.projIngListCnt(projectVO);
//			List<ProjectVO> projectEndVOList = projectService.projEndList(projectVO);
//			List<ProjectVO> projectInviteVOList = projectService.inviteProjectList(memNo);
//			taskVO.setMemNo(memNo);
//			List<TaskVO> taskVOList = this.taskService.mypageTaskList(taskVO);
//			List<TaskVO> todayTaskVOList = this.taskService.todayTaskList(taskVO);
//			List<TaskVO> weekTaskVOList = this.taskService.weekTaskList(memNo);
//			List<TaskVO> endTaskVOList = this.taskService.endTaskList(taskVO);
//			alertVO.setMemNo(memNo);
//			List<AlertVO> alertVOList = this.alertService.alertListCnt(alertVO);
//			
//			model.addAttribute("memberVO", memberVO);
//			model.addAttribute("resumeVO", resumeVO);
//			model.addAttribute("licenseVOList", licenseVOList);
//			model.addAttribute("licenseVOList2", licenseVOList2);
//			model.addAttribute("jovVOList", jovVOList);
//			model.addAttribute("costVOList", costVOList);
//			model.addAttribute("applicantVOList", applicantVOList);
//			model.addAttribute("projectVOList", projectVOList);
//			model.addAttribute("projectEndVOList", projectEndVOList);
//			model.addAttribute("projectInviteVOList", projectInviteVOList);
//			model.addAttribute("taskVOList", taskVOList);
//			model.addAttribute("todayTaskVOList", todayTaskVOList);
//			model.addAttribute("weekTaskVOList", weekTaskVOList);
//			model.addAttribute("endTaskVOList", endTaskVOList);
//			model.addAttribute("alertVOList", alertVOList);
//			
//			//직책
//			MainVO myRole= this.mainService.myRole(memberVO);
//			model.addAttribute("myRole", myRole);
//			log.info("myRole : " + mainVO.toString());
//			
//			/////////////////////////////////// 완료/승인된 일감 - 내 전체 일감
//			TaskVO myTasks = this.mainService.myTasks(memberVO);
//			log.info("     도넛 그래프용 vo : " + myTasks);
//			
//			model.addAttribute("myTasks", myTasks);
//			/////////////////////////////////// 완료/승인된 일감 - 내 전체 일감
//
//			//프로젝트
//			MainVO myProj = this.mainService.myProj(memberVO);
//			model.addAttribute("myProj", myProj);
//			log.info("myProj: " + mainVO.toString());
//			
//			//프로젝트 리스트
//			List<ProjectVO> projList = new ArrayList<ProjectVO>();
//			projList = this.mainService.projList(memberVO);
//			model.addAttribute("projList", projList);
//			log.info("projList", projList.toArray());
//			
//			//일감 리스트
//			List<TaskVO> taskList = new ArrayList<TaskVO>();
//			taskList = this.mainService.taskList(memberVO);
//			model.addAttribute("taskList", taskList);
//			log.info("taskList", taskList.toArray());
//			
//			//직책 리스트
//			List<RoleVO> roleList = new ArrayList<RoleVO>();
//			roleList = this.mainService.roleList(memberVO);
//			model.addAttribute("roleList", roleList);
//			log.info("roleList", roleList.toArray());
//			
//			return "portfolio.pop";
//		}
}

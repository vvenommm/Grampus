package kr.or.ddit.controller;

import java.io.Console;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

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
import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.ProjectVO;
import kr.or.ddit.vo.ResumeVO;
import kr.or.ddit.vo.RoleVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mypage")
public class MyPageController {

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
	AlertService alertService;
	
	@Inject
	MainService mainService;
				
	//???????????????(????????? ?????????, ???????????????,  
	//?????? URI /member/memDetail?memNo=M0001
	@GetMapping("/myPageMain")
	public String myPage2(HttpServletRequest request, String memNo, Model model, TaskVO taskVO, ProjectVO projectVO, JobVO jobVO, AlertVO alertVO, ApplicantVO applicantVO, MainVO mainVO) {
		
		log.info("memNo : " + memNo);
		
		//?????? String memId ????????? session?????? ????????? ???????????? ??????????????? ??????!!
		HttpSession session = request.getSession();
		log.info("session : " + session);
		
		memNo = (String) session.getAttribute("memNo");

		MemberVO memberVO =  this.memService.memDetail(memNo);
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
		log.info("    todayTaskVOList : {} ", todayTaskVOList);
		List<TaskVO> weekTaskVOList = this.taskService.weekTaskList(memNo);
		List<TaskVO> endTaskVOList = this.taskService.endTaskList(taskVO);
		alertVO.setMemNo(memNo);
		List<AlertVO> alertVOList = this.alertService.alertListCnt(alertVO);
		
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
		model.addAttribute("alertVOList", alertVOList);
		
		//??????
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
		List<ProjectVO> projList = new ArrayList<ProjectVO>();
		projList = this.mainService.projList(memberVO);
		model.addAttribute("projList", projList);
		log.info("projList", projList.toArray());
		
		//?????? ?????????
		List<TaskVO> taskList = new ArrayList<TaskVO>();
		taskList = this.mainService.taskList(memberVO);
		model.addAttribute("taskList", taskList);
		log.info("taskList", taskList.toArray());
		
		//?????? ?????????
		List<RoleVO> roleList = new ArrayList<RoleVO>();
		roleList = this.mainService.roleList(memberVO);
		model.addAttribute("roleList", roleList);
		log.info("roleList", roleList.toArray());
		
		
		
		return "mypage/myPageMain";
	}
	
	//??????????????????
	@GetMapping("/profileList")
	public String profileList(HttpServletRequest request, String memNo, Model model ) {
		
		//?????? String memId ????????? session?????? ????????? ???????????? ??????????????? ??????!!
		HttpSession session = request.getSession();
		log.info("session : " + session);
		memNo = (String) session.getAttribute("memNo");
		
		List<ProfileVO> profileVOList = this.profileService.profileList(memNo);		
		MemberVO memberVO =  this.memService.memDetail(memNo);
		
		log.info("memberVO" +memberVO);
		log.info("profileVOList :" + profileVOList.toString());
		
		model.addAttribute("memberVO", memberVO);
		model.addAttribute("profileVOList", profileVOList);    
		return "mypage/profileList";
	}
	
	//???????????????
	@PostMapping("/profileUpdate")
	public String profileUpdate(ProfileVO profileVO, HttpServletRequest request) {
		
		log.info("profileVO ?????? : " + profileVO);
		String uploadFolder = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\grampus\\src\\main\\webapp\\resources\\image";
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Map<String, List<MultipartFile>> paramMap = multipartRequest.getMultiFileMap();
		
		String fileName = null;
		List<MultipartFile> files = paramMap.get("fieImageName");
		for (MultipartFile file : files) {
			System.out.println(file.getOriginalFilename());
			fileName = file.getOriginalFilename();
			if(!(fileName.equals(null) || fileName.isEmpty())) {
				String uploadFileName = fileName;
				uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
				UUID uuid = UUID.randomUUID();
				uploadFileName = uuid.toString()+"-"+uploadFileName;
				profileVO.setProfPhoto(uploadFileName);
				File saveFile = new File(uploadFolder,uploadFileName);
				try {
					file.transferTo(saveFile);
					break;
				} catch (IllegalStateException e) {
					log.error(e.getMessage());
				} catch (IOException e) {
					log.error(e.getMessage());
				}
			}

		}
		
		log.info("fileName : "+fileName);
		
		int profileUpdate =  this.profileService.profileUpdate(profileVO);
		log.info("profileUpdate : " + profileUpdate);
		
		return "redirect:/mypage/myPageMain";
	}
	
	
	//???????????????????????????
	@GetMapping("/pwChange")
	public String pwChange(HttpServletRequest request, Model model, String memNo) {
		HttpSession session = request.getSession();
		memNo = (String) session.getAttribute("memNo");
		MemberVO memVO =  this.memService.memDetail(memNo);
		model.addAttribute("memVO", memVO);
		return "mypage/pwChange";
	}
	
	//????????? ???????????? ??????
	@PostMapping("/memUpdate")
	public String memUpdate(MemberVO memberVO) {
		
		int memupdate = this.memService.memUpdate(memberVO);
		log.info("memupdate : " + memupdate);
		
		return "redirect:/mypage/myPageMain";		
	}
	
	//????????? ??????
	@PostMapping("/resumeInsert")
	public String resumeInsert(ResumeVO resumeVO) {
		log.info("       ??? ?????? ?????? : " + resumeVO);
		
		int resumeInsert = this.resumeService.resumeInsert(resumeVO);
		
		return "redirect:/mypage/myPageMain";
	}
	
	//????????? ??????
	@PostMapping("/resuemUpdate")
	public String resuemUpdate(ResumeVO resumeVO, @RequestParam MultipartFile file) {
		log.info("resumeVO.getMemPhoto() : " + resumeVO.getMemPhoto());
		if(resumeVO.getMemPhoto().equals("Y")) {
			log.info("file : " + file.toString());
			log.info("resumeVO : " + resumeVO.toString());
			String fileName = file.getOriginalFilename();
			String fileExtension = fileName.substring(fileName.lastIndexOf("."),fileName.length());
			String uploadFolder = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\grampus\\src\\main\\webapp\\resources\\image";
			UUID uuid = UUID.randomUUID();
			String[] uuids = uuid.toString().split("-");
			String uniqueName = uuids[0];
			File saveFile = new File(uploadFolder+"\\"+uniqueName+fileExtension);
			
			try {
				file.transferTo(saveFile);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			resumeVO.setMemPhoto(uniqueName+fileExtension);
			
			int memPhotoUpdate = this.memService.memPhotoUpdate(resumeVO);
			log.info("memPhotoUpdate : " + memPhotoUpdate);
		}
		int resuemUpdate = this.resumeService.resuemUpdate(resumeVO);
		log.info("resuemUpdate?????? : " + resuemUpdate);
		
		return "redirect:/mypage/myPageMain";
	}
	
	//????????? ??????
	@PostMapping("/licenseInsert")
	public String licenseInsert(LicenseVO licenseVO) {
		
		int incenseInsert = this.licenseService.licenseInsert(licenseVO);
		
		log.info("incenseInsert : " + incenseInsert);
		
		
		return "redirect:/mypage/myPageMain";
	}
	
	//????????? ??????
	@GetMapping("/licenseDelete")
	public String licenseDelete(int liceNo) {
		
		int licenseDelete = this.licenseService.licenseDelete(liceNo);
		log.info("licenseDelete : " +licenseDelete);
		
		return "redirect:/mypage/myPageMain";
	}
	

	
}
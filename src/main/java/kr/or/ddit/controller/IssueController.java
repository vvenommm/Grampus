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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.AnswerService;
import kr.or.ddit.service.HistoryService;
import kr.or.ddit.service.IssueService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.TaskService;
import kr.or.ddit.vo.AnswerVO;
import kr.or.ddit.vo.HistoryVO;
import kr.or.ddit.vo.IssueVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.TaskVO;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@RequestMapping("/issue")
@Controller
public class IssueController {
	@Autowired
	TaskService taskService;
	
	@Autowired
	IssueService issueService;
	
	@Autowired
	AnswerService answerService;
	
	@Autowired
	HistoryService historyService;
	
	@Autowired
	ProMemService promemService;
	
	@Autowired
	ProjectService projectService;
	
	@Autowired
	AlertService alertService;
	
	//이슈 메인 페이지
	@RequestMapping("/issueMain/{projId}/{pmemGrp}")
	public String issueMain(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, 
			HttpServletRequest request, Model model) {
		//세션 아이디 가져오기 & 저장하기
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", pmemGrp);
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		
		//설정 버튼 보이게 할지 말지 구분할 값
		ProMemVO pvo = new ProMemVO();
		pvo.setProjId(projId);
		pvo.setMemNo((String)session.getAttribute("memNo"));
		ProMemVO amIPM = this.promemService.iAmPm(pvo);
		int pm = 0;
		if(amIPM != null) pm = amIPM.getPm();
		log.info("           난 pm인가? : " + pm);
		pvo.setPm(pm);
		session.setAttribute("iamPM", pvo);
		
		
		//브레드크럼에 쓰일 값
		Map<String, Object> breadcrumb = new HashMap<String, Object>();
		breadcrumb.put("projId", projId);
		breadcrumb.put("grp", pmemGrp);
		breadcrumb.put("memNo", session.getAttribute("memNo"));
		Map<String, Object> projVO = this.projectService.projMain(breadcrumb);
		session.setAttribute("projVO", projVO);
		
		
		//로그인한 사람의 프로젝트 내 역할에 따라 구분
		ProMemVO promemVO = new ProMemVO();
		promemVO.setMemNo(pvo.getMemNo());
		promemVO.setProjId(projId);
		promemVO.setPmemGrp(pmemGrp);
		List<ProMemVO> roleList = this.taskService.checkRole(promemVO);
		String role = "";
		String role2 = "";
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		
		int improveCount = 0;
		int defectCount = 0;
		int personalCount = 0;
		int etcCount = 0;
		
		for(int i = 0; i < roleList.size(); i++) {
			if(roleList.get(i).getRoleId().equals("R01")) {
				role = "R01";
			}
			if(roleList.get(i).getRoleId().equals("R02")) {
				role2 = "R02";
			}
		}
			
		map.put("pmemGrp", pmemGrp);
		list = this.issueService.issueList2(map);
		
		//개선 개수
		improveCount = this.issueService.improveCount2(map);
		//결함 개수
		defectCount = this.issueService.defectCount2(map);
		//인사 개수
		personalCount = this.issueService.personalCount2(map);
		//기타 개수
		etcCount = this.issueService.etcCount2(map);
		
		log.info("issueMain ==> " +  list);
		model.addAttribute("issueList", list);
		model.addAttribute("pmemGrp", pmemGrp);
		model.addAttribute("improveCount", improveCount);
		model.addAttribute("defectCount", defectCount);
		model.addAttribute("personalCount", personalCount);
		model.addAttribute("etcCount", etcCount);
		model.addAttribute("role", role);
		
		return "issue/issueMain";
	}
	
	
	//모두 카테고리 선택 시 이슈 목록
	@PostMapping("/issueList")
	@ResponseBody
	public List<Map<String, Object>> issueList(HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", session.getAttribute("projId"));
		
		//전체 이슈 목록
		List<Map<String, Object>> list =  this.issueService.issueList(map);
		
		return list;
	}
	
	//각 종류별 이슈 개수 구하기
	@PostMapping("/issues")
	@ResponseBody
	public Map<String, Object> issues(HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		//개선 개수
		int improveCount = this.issueService.improveCount(map);
		//결함 개수
		int defectCount = this.issueService.defectCount(map);
		//인사 개수
		int personalCount = this.issueService.personalCount(map);
		//기타 개수
		int etcCount = this.issueService.etcCount(map);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("improveCount", improveCount);
		resultMap.put("defectCount", defectCount);
		resultMap.put("personalCount", personalCount);
		resultMap.put("etcCount", etcCount);
		
		return resultMap;
	}
	
	//전체 카테고리 선택 시 이슈 목록
	@PostMapping("/issueList2")
	@ResponseBody
	public List<Map<String, Object>> issueList2(HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", session.getAttribute("projId"));
		map.put("pmemGrp", session.getAttribute("grp"));
		
		//전체 이슈 목록
		List<Map<String, Object>> list =  this.issueService.issueList2(map);
		
		return list;
	}
	
	//각 종류별 이슈 개수 구하기
	@PostMapping("/issues2")
	@ResponseBody
	public Map<String, Object> issues2(HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", session.getAttribute("grp"));
		
		//개선 개수
		int improveCount = this.issueService.improveCount2(map);
		//결함 개수
		int defectCount = this.issueService.defectCount2(map);
		//인사 개수
		int personalCount = this.issueService.personalCount2(map);
		//기타 개수
		int etcCount = this.issueService.etcCount2(map);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("improveCount", improveCount);
		resultMap.put("defectCount", defectCount);
		resultMap.put("personalCount", personalCount);
		resultMap.put("etcCount", etcCount);
		
		return resultMap;
	}
	
	//이슈 상세 페이지
	@RequestMapping("/issueDetail/{issueNo}/{pmemGrp}")
	public String issueDetail(@PathVariable("issueNo") String issueNo, @PathVariable("pmemGrp") String pmemGrp, HttpServletRequest request, Model model) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("issueNo", issueNo);
		
		//이슈 상세 정보
		Map<String, Object> resultMap = this.issueService.issueDetail(map);
		model.addAttribute("resultMap", resultMap);
		
		//이슈 댓글
		List<AnswerVO> answerList = this.answerService.issueAnswer(map);
		model.addAttribute("answerList", answerList);
		
		//로그인한 사람의 해당 프로젝트 내 해당 그룹에서의 프로젝트멤버코드 체크
		ProMemVO promemVO = new ProMemVO();
		promemVO.setProjId(projId);
		promemVO.setMemNo(vo.getMemNo());
		promemVO.setPmemGrp(pmemGrp);
		
		int loginPmemcd = this.issueService.checkPmemcd(promemVO);
		model.addAttribute("loginPmemcd", loginPmemcd);
		
		return "issue/issueDetail";
	}
	
	//이슈 등록 페이지
	@RequestMapping("/newIssue/{projId}/{pmemGrp}")
	public String newIssue(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, @RequestParam(value = "taskNo", required = false) String taskNo, HttpServletRequest request, Model model) {
		//세션 아이디 가져오기 & 저장하기
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", pmemGrp);
		
		if(taskNo != null) {
			model.addAttribute("taskNo", taskNo);
		}else {
			model.addAttribute("taskNo", 1);
		}
		
		return "issue/newIssue";
	}
	
	//이슈 등록 시 같은 팀의 전체 일감 가져오기
	@PostMapping("/getTaskInfo")
	@ResponseBody
	public List<TaskVO> getTaskInfo(@RequestBody String pmemGrp, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);
		log.info("projId" + projId);
		log.info("pmemGrp" + pmemGrp);
		List<TaskVO> taskList = this.issueService.getTaskInfo(map);
		
		return taskList;
	}
	
	//이슈 등록
	@PostMapping("/insertIssue")
	@ResponseBody
	public int insertIssue(@RequestBody IssueVO issueVO, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		String pmemGrp = String.valueOf(session.getAttribute("grp"));
		
		//로그인한 사람의 해당 프로젝트 내 해당 그룹에서의 프로젝트멤버코드 체크
		ProMemVO promemVO = new ProMemVO();
		promemVO.setProjId(projId);
		promemVO.setMemNo(vo.getMemNo());
		promemVO.setPmemGrp(pmemGrp);
		log.info(promemVO.toString());
		int loginPmemcd = this.issueService.checkPmemcd(promemVO);
		
		//이슈 등록
		issueVO.setPmemCd(loginPmemcd);
		log.info(issueVO.toString());
		
		int result = this.issueService.insertIssue(issueVO);
		
		//history 테이블에 추가
		HistoryVO hvo = new HistoryVO();
		hvo.setPmemCd(issueVO.getPmemCd());
		hvo.setHisKey(issueVO.getIssueNo());
		hvo.setHisCn(issueVO.getIssueCn());
		this.historyService.issueIn(hvo);
		
		//멘션 태그된 사람들에게 알림 전송
		if(issueVO.getMemNoArr().length > 0) {
			Map<String, Object> projInfo = this.projectService.projInfo(projId);
			String[] receiver = issueVO.getMemNoArr();
			for(int i=0; i<receiver.length; i++) {
				Map<String, Object> alertmap = new HashMap<String, Object>();
				alertmap.put("memNo", receiver[i]);
				alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+session.getAttribute("grp")+" 그룹 "+issueVO.getIssueNo()+" 이슈에서 언급되었습니다");
				alertmap.put("altSend", vo.getMemNo());
				alertmap.put("altLink", "/issue/issueDetail/"+issueVO.getIssueNo()+"/"+session.getAttribute("grp"));
				this.alertService.alertInsert(alertmap);
			}
		}
		
		return result;
	}
	
	//이슈 수정
	@PostMapping("/updateIssue")
	@ResponseBody
	public int updateIssue(@RequestBody IssueVO issueVO, HttpServletRequest request) {
		log.info(issueVO.toString());
		
		int result = this.issueService.updateIssue(issueVO);
		
		//history 테이블에 추가
		log.info("is                " + issueVO.toString());
		
		HistoryVO hvo = new HistoryVO();
		hvo.setPmemCd(issueVO.getPmemCd());
		hvo.setHisKey(issueVO.getIssueNo());
		hvo.setHisCn(issueVO.getIssueCn());
		this.historyService.issueUp(hvo);
		
		//멘션 태그된 사람들에게 알림 전송
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		if(issueVO.getMemNoArr().length > 0) {
			Map<String, Object> projInfo = this.projectService.projInfo(projId);
			String[] receiver = issueVO.getMemNoArr();
			for(int i=0; i<receiver.length; i++) {
				Map<String, Object> alertmap = new HashMap<String, Object>();
				alertmap.put("memNo", receiver[i]);
				alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+session.getAttribute("grp")+" 그룹 "+issueVO.getIssueNo()+" 이슈에서 언급되었습니다");
				alertmap.put("altSend", vo.getMemNo());
				alertmap.put("altLink", "/issue/issueDetail/"+issueVO.getIssueNo()+"/"+session.getAttribute("grp"));
				this.alertService.alertInsert(alertmap);
			}
		}
		
		return result;
	}
	
	//이슈 삭제
	@PostMapping("/deleteIssue")
	@ResponseBody
	public int deleteIssue(@RequestBody IssueVO issueVO) {
		int result = this.issueService.deleteIssue(issueVO.getIssueNo());
		
		//history 테이블에 추가
		HistoryVO hvo = new HistoryVO();
		hvo.setPmemCd(issueVO.getPmemCd());
		hvo.setHisKey(issueVO.getIssueNo());
		this.historyService.issueDel(hvo);
		
		return result;
	}
	
	//이슈 댓글 등록
	@PostMapping("/newAnswer")
	@ResponseBody
	public int newAnswer(@RequestBody Map<String, Object> map, HttpServletRequest request) {
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");
		
		map.put("projId", projId);
		map.put("memNo", vo.getMemNo());
		map.put("pmemGrp", session.getAttribute("grp"));
		int result = this.answerService.newAnswer(map);
		
		//댓글 등록 시 게시글 작성자에게 알림
		Map<String, Object> projInfo = this.projectService.projInfo(projId);
		String in = String.valueOf(map.get("issueNo"));
		String receiver = this.issueService.getWriter(Integer.parseInt(in));
		Map<String, Object> alertmap = new HashMap<String, Object>();
		alertmap.put("memNo", receiver);
		alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+session.getAttribute("grp")+" 그룹 "+map.get("issueNo")+" 이슈에 댓글이 작성되었습니다");
		alertmap.put("altSend", vo.getMemNo());
		alertmap.put("altLink", "/issue/issueDetail/"+map.get("issueNo")+"/"+session.getAttribute("grp"));
		this.alertService.alertInsert(alertmap);
		
		
		//history 테이블에 insert
		HistoryVO hvo = new HistoryVO();
		hvo.setProjId(projId);
		hvo.setMemNo(vo.getMemNo());
		hvo.setPmemGrp((String)session.getAttribute("grp"));
		hvo.setHisKey(map.get("ansNo"));
		hvo.setHisCn((String)map.get("ansCn"));
		log.info("      댓글 등록 시 map : " + map.toString());
		log.info("      댓글 등록 시 hvo : " + hvo.toString());
		this.historyService.answerIn(hvo);
		
		return result;
	}
	
	//이슈 댓글 삭제
	@PostMapping("/deleteAnswer")
	@ResponseBody
	public int deleteAnswer(@RequestBody int ansNo, HttpServletRequest request) {
		int result = this.answerService.deleteAnswer(ansNo);
		
		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");

		//history 테이블에 insert
		HistoryVO hvo = new HistoryVO();
		hvo.setProjId(projId);
		hvo.setMemNo(vo.getMemNo());
		hvo.setPmemGrp((String)session.getAttribute("grp"));
		hvo.setHisKey(ansNo);
		log.info("      댓글 삭제 시 hvo : " + hvo.toString());
		this.historyService.answerDel(hvo);
		
		return result;
	}
	
	//이슈 댓글 수정
	@PostMapping("/updateAnswer")
	@ResponseBody
	public int updateAnswer(@RequestBody AnswerVO answerVO, HttpServletRequest request) {
		log.info(answerVO.toString());
		int result = this.answerService.updateAnswer(answerVO);

		//세션 아이디 가져오기
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		MemberVO vo = (MemberVO)session.getAttribute("loginVO");

		//history 테이블에 insert
		HistoryVO hvo = new HistoryVO();
		hvo.setProjId(projId);
		hvo.setMemNo(vo.getMemNo());
		hvo.setPmemGrp((String)session.getAttribute("grp"));
		hvo.setHisKey(answerVO.getAnsNo());
		hvo.setHisCn(answerVO.getAnsCn());
		log.info("      댓글 수정 시 answerVO : " + answerVO.toString());
		log.info("      댓글 수정 시 hvo : " + hvo.toString());
		this.historyService.answerUp(hvo);
		
		return result;
	}
	
	
	//일괄편집 업데이트 
	@PostMapping("/updateAll")
	public String updateAll(@ModelAttribute IssueVO issueVO, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		String pmemGrp = (String)session.getAttribute("grp");
		
		//프로젝트멤버코드 구하기
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);
		
		String[] issueNos = issueVO.getIssueNo().split(",");
		String[] issueTypes = issueVO.getIssueType().split(",");
		String[] issueTtls = issueVO.getIssueTtl().split(",");
		String[] pmemCds = issueVO.getPmemCds().split(",");
		String[] issueSttss = issueVO.getIssueStts().split(",");
		String[] issueDys = issueVO.getIssueDy().split(",");
		
		for(int i = 0; i < issueNos.length; i++) {
			log.info("issueNos[i] : " + issueNos[i]);
			log.info("issueTypes[i] : " + issueTypes[i]);
			log.info("issueTtls[i] : " + issueTtls[i]);
			log.info("pmemCds[i] : " + pmemCds[i]);
			log.info("issueSttss[i] : " + issueSttss[i]);
			log.info("issueDys[i] : " + issueDys[i]);
			
			issueVO.setIssueNo(issueNos[i]);
			issueVO.setIssueType(issueTypes[i]);
			issueVO.setIssueTtl(issueTtls[i]);
			issueVO.setPmemCd(Integer.parseInt(pmemCds[i]));
			issueVO.setIssueStts(issueSttss[i]);
			issueVO.setIssueDy(issueDys[i]);
			this.issueService.updateAll(issueVO);
		}
		
		model.addAttribute("projId", projId);
		model.addAttribute("pmemGrp", pmemGrp);
		
		return "redirect:/issue/issueMain/{projId}/{pmemGrp}";
	}
	
	//이슈 종류별 정렬(모두)
	@PostMapping("/isSortAll")
	@ResponseBody
	public List<Map<String, Object>> isSortAll(@RequestBody String issueType, HttpServletRequest request) {
		log.info("issueType : =>>>>>>>>>>>>>>>>>>" + issueType);
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("issueType", issueType);
		
		List<Map<String, Object>> resList = this.issueService.isSortAll(map);
		return resList;
	}
	
	//이슈 종류별 정렬(팀별)
	@PostMapping("/isSortGrp")
	@ResponseBody
	public List<Map<String, Object>> isSortGrp(@RequestBody String issueType, HttpServletRequest request) {
		log.info("issueType : =>>>>>>>>>>>>>>>>>>" + issueType);
		HttpSession session = request.getSession();
		int projId = (int)session.getAttribute("projId");
		String pmemGrp = (String)session.getAttribute("grp");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);
		map.put("issueType", issueType);
		
		List<Map<String, Object>> resList = this.issueService.isSortGrp(map);
		
		return resList;
	}
	
}

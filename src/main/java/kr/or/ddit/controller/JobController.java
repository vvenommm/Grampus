package kr.or.ddit.controller;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.JobService;
import kr.or.ddit.service.MarkService;
import kr.or.ddit.service.ResumeService;
import kr.or.ddit.vo.JobVO;
import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class JobController {
	@Autowired
	JobService jobService;
	
	@Inject
	ResumeService resumeService;
	
	//구인공고 목록 페이지
	@GetMapping("/jobList")
	public String jobList(@RequestParam(value = "cont", defaultValue = "") String cont, @RequestParam(value = "listcnt", defaultValue = "1") String listcnt, Model model, HttpServletRequest request) throws ParseException {
		//id 세션값으로
		HttpSession session = request.getSession();
		String id  = (String)session.getAttribute("id");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listcnt", Integer.parseInt(listcnt)*8);
		map.put("scon", cont);
		List<Map<String, Object>> list = jobService.jobList(map);
		for(int i=0; i<list.size(); i++) {
			String[] tech = list.get(i).get("JOB_TECH").toString().trim().split(",");
			list.get(i).put("TECH", tech);
		}
		
		if(id != null) {
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
		return "jobList";
	}
	
	//구인공고 상세
	@GetMapping("/jobDetail")
	public String jobDetail(@RequestParam int projId, Model model, HttpServletRequest request) {
		Map<String, Object> map1 = jobService.projVal(projId);
		Map<String, Object> map2 = jobService.jobVal(projId);
		List<Map<String, Object>> list1 = jobService.costVal(projId);
		String[] tech = map2.get("JOB_TECH").toString().trim().split(",");
		model.addAttribute("projVal",map1);
		model.addAttribute("jobVal",map2);
		model.addAttribute("costVal",list1);
		model.addAttribute("jobTech", tech);
		
		//레쥬메 없으면 지원 못한다고 해야해서 추가
		HttpSession session = request.getSession();
		if(session.getAttribute("memNo") != null) {
			int resume = this.resumeService.doYouHaveResume((String)session.getAttribute("memNo"));
			model.addAttribute("resume", resume);
		}
		
		return "jobDetail";
	}
	
	//구인공고 등록
	@ResponseBody
	@PostMapping("/jobRegist")
	public int jobRegist(@RequestBody Map<String, Object> map) {
		int res = jobService.jobRegist(map);
		return res;
	}
	
	//구인공고 수정
	@ResponseBody
	@PostMapping("/jobModify")
	public int jobModify(@RequestBody Map<String, Object> map) {
		int res = jobService.jobModify(map);
		return res;
	}
	
	//구인공고 삭제
	@ResponseBody
	@PostMapping("/jobDelete")
	public int jobDelete(@RequestParam String projId) {
		jobService.appliDelete(Integer.parseInt(projId));
		int res = jobService.jobDelete(Integer.parseInt(projId));
		return res;
	}
	
	//마이페이지 북마크 목록 보기
	@GetMapping("/bookMarkList")
	public String bookMarkList(Model model, JobVO jobVO,@RequestParam(value = "cont", defaultValue = "") String cont) {
		jobVO.setScon(cont);
		 List<JobVO> bookMarkList =  this.jobService.bookMarkList(jobVO);
		 String scon = jobVO.getScon();
		 model.addAttribute("scon", scon);
		 model.addAttribute("bookMarkList", bookMarkList);
		
		return "mypage/bookMarkList";
	}
	
	//북마크 공고 상세보기
	@GetMapping("/bookMarkDetail")
	public String bookMarkDetail(Model model,JobVO jobVO) {
		
		JobVO jobVODetail = this.jobService.bookMarkDetail(jobVO);
		 log.info("jobVODetail : " + jobVODetail);
		 model.addAttribute("jobVODetail", jobVODetail);
		
		return "redirect:/mypage/bookMarkList";
	}
	
	
}

package kr.or.ddit.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.ParseException;
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
import kr.or.ddit.service.BoardService;
import kr.or.ddit.service.NoticeService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/notice")
@Controller
public class NoticeController {
	
	@Autowired
	NoticeService noticeService;

	@Autowired
	AlertService alertService;
	
	@Autowired
	ProMemService promemService;
	
	@Autowired
	ProjectService projectService;
	
	@Inject
	BoardService boardService;
	
	//공지사항 조회
	@RequestMapping("/noticeList/{projId}/{pmemGrp}")
	public ModelAndView noticeList(@PathVariable("projId") int projId, @PathVariable("pmemGrp") String pmemGrp, ModelAndView mav,
			BoardVO boardVO, HttpServletRequest request,
			@RequestParam(value = "cont", defaultValue = "") String cont, 
			@RequestParam(value = "listcnt", defaultValue = "1") String listcnt) throws ParseException {
		
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", pmemGrp);
		log.info("projId : " + projId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("pmemGrp", pmemGrp);
		map.put("listcnt", Integer.parseInt(listcnt)*4);
		map.put("scon", cont);
		String scon = (String) map.get("scon");
		mav.addObject("scon", scon);
		List<NoticeVO> noticeVO = this.noticeService.noticeList(map);
		BoardVO projTtl = this.boardService.projTtl(boardVO);
		

		log.info("noticeVO : " + noticeVO);
		if(noticeVO != null) {
			mav.addObject("projTtl", projTtl);
			mav.addObject("noticeVO", noticeVO);
			mav.addObject("pmemGrp", pmemGrp);
			mav.addObject("listcnt", Integer.parseInt(listcnt));
		}
		
		mav.setViewName("notice/noticeList");
		
		return mav;
	}
	
	// 스프링에서는 요청 파라미터(articleNo=1)를 매개변수로 받을 수 있음
	// 파라미터는 String인데 spring에서 int로 자동 형변환해줌
	//공지사항 상세보기 // 공지사항 조회수 증가
	@GetMapping("/noticeDetail")
	public String noticeDetail(NoticeVO noticeVO, Model model, String ntcNo, HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("projId", noticeVO.getProjId());
		session.setAttribute("pmemGrp", noticeVO.getPmemGrp());
		session.setAttribute("pmemCd", noticeVO.getPmemCd());
		
		noticeVO = this.noticeService.noticeDetail(noticeVO);
		model.addAttribute("noticeVO", noticeVO);
		
		//공지사항 조회수 증가
		int noticeHit = noticeService.noticeHit(ntcNo);
		log.info("noticeHit : " + noticeHit);
		
		return "notice/noticeDetail";
	}
	
	//공지사항 작성하기
	@GetMapping("/noticeWrite")
	public String noticeWrite() {
		
		
		return "notice/noticeWrite";
	}
	
	@ResponseBody
	@PostMapping("/noticeWritePost")
	public Map<String,Object> noticeWritePost (@RequestBody Map<String, Object> map, HttpServletRequest request) {
		
		log.info("map : "+ map.toString());
		Map<String,Object> map2 = new HashMap<String, Object>();
		
		map2.put("projId", map.get("projId"));
		map2.put("pmemGrp", map.get("pmemGrp"));
		map2.put("memNo", map.get("memNo"));
//		map2 : {projId=41, memNo=M0001, pmemGrp=전체}
		log.info("map2 : " + map2);
		Map<String,Object> test = this.noticeService.getPmemCd(map2);
		log.info("test : " + test);
		//int testNum = Integer.parseInt(String.valueOf(dataMap.get("num_val1")));
		int pmemCd = Integer.parseInt(String.valueOf(test.get("PMEM_CD")));
		
		log.info("pmemCd : " + pmemCd);
		
		Map<String, Object> map3 = new HashMap<String, Object>();
		
		map3.put("projId", map2.get("projId"));
		map3.put("pmemGrp", map2.get("pmemGrp"));
		map3.put("memNo", map2.get("memNo"));
		map3.put("pmemCd", pmemCd);
		map3.put("ntcTtl", map.get("ntcTtl"));
		map3.put("ntcCn", map.get("ntcCn"));
		
		log.info("map3 : " + map3);
		int noticeInsert = this.noticeService.noticeInsert(map3);
		log.info("noticeInsert : " + noticeInsert);
		
		//공지사항 등록 시 알림
		Map<String, Object> ntcmap = new HashMap<String, Object>();
		ntcmap.put("projId", map.get("projId"));
		ntcmap.put("pmemGrp", map.get("pmemGrp"));
		List<Map<String, Object>> ntclist = this.noticeService.getProjGrp(ntcmap);
		Map<String, Object> projInfo = this.projectService.projInfo(Integer.parseInt(((String)map.get("projId"))));
		String sender = this.promemService.getProjAdmin(Integer.parseInt(((String)map.get("projId"))));
		for(int i=0; i<ntclist.size(); i++) {
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", ntclist.get(i).get("MEM_NO"));
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+map.get("pmemGrp")+" 그룹의 새로운 공지사항이 등록되었습니다");
			alertmap.put("altSend", sender);
			alertmap.put("altLink", "/notice/noticeList/"+map.get("projId")+"/"+map.get("pmemGrp"));
			this.alertService.alertInsert(alertmap);
		}
		
		return map2;
	}
	
	//공지사항 수정하기
//	@ResponseBody
	@PostMapping("/noticeUpdate")
	public String noticeUpdate(@RequestParam Map<String, Object> map) throws UnsupportedEncodingException {
		
		log.info("map : " + map.toString());
		
		int noticeUpdate = this.noticeService.noticeUpdate(map);
		
		log.info("noticeUpdate : " + noticeUpdate);
		
//		return "redirect:/notice/noticeDetail?ntcNo="+map.get("ntcNo") +"&projId="+map.get("projId") + "&pmemGrp=" +map.get("pmemGrp");
		return "redirect:/notice/noticeList/" + map.get("projId") + "/" + URLEncoder.encode((String)map.get("pmemGrp"), "UTF-8");
	}
	
	//공지사항 삭제하기
	@PostMapping("/noticeDelete")
	public String noticeDelete(NoticeVO noticeVO) throws UnsupportedEncodingException{
		//NoticeVO [ntcNo=19, pmemCd=0, ntcTtl=null, ntcCn=, ntcDy=null, ntcInq=0, projId=1, pmemGrp=전체]
		log.info("noticeVO : " + noticeVO.toString());
		int noticeDelete = this.noticeService.noticeDelete(Integer.parseInt(noticeVO.getNtcNo()));
		
		log.info("noticeDelete : " + noticeDelete);
		///notice/noticeList/1/전체
		return "redirect:/notice/noticeList/" + noticeVO.getProjId() +"/" + URLEncoder.encode(noticeVO.getPmemGrp(), "UTF-8");
	}
}

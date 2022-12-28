package kr.or.ddit.controller;



import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.BoardService;
import kr.or.ddit.service.HistoryService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.ReplyService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.HistoryVO;
import kr.or.ddit.vo.ReplyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/reply")
@Controller
public class ReplyController {
	@Inject
	ReplyService replyService;
	
	@Inject
	BoardService boardService;
	
	@Inject
	HistoryService historyService;
	
	@Inject
	AlertService alertService;
	
	@Inject
	ProjectService projectService;
	
	//게시글 댓글 작성하기	
	@PostMapping("/replyWrite")
	public String replyWrite(ReplyVO replyVO, BoardVO boardVO, HttpServletRequest request) throws UnsupportedEncodingException{
		
	/////////////pmemCd 가져오기/////////////
			
		HttpSession session = request.getSession();
		session.setAttribute("projId", boardVO.getProjId());
		session.setAttribute("grp", boardVO.getPmemGrp());
		boardVO.setMemNo((String)session.getAttribute("memNo"));
		
		boardVO.setPmemCd(this.boardService.getPmemCd(boardVO).getPmemCd());
		session.setAttribute("pmemCd", replyVO.getPmemCd());
		log.info("boardVO : " + boardVO.toString());
		
	/////////////////////////////////////
			
		log.info("replyVO : " + replyVO.toString());
		int replyInsert = this.replyService.replyInsert(replyVO);
		
		log.info("replyInsert : " + replyInsert);
		
		
		//작업 내역 테이블에 insert 시작
			HistoryVO hvo = new HistoryVO();
			hvo.setPmemCd(boardVO.getPmemCd());
			hvo.setHisKey(replyVO.getRplNo());
			hvo.setHisCn(replyVO.getRplCn());
			this.historyService.replyIn(hvo);
		//작업 내역 테이블에 insert 끝
		
		//헬프데스크 게시글에 댓글이 달리면 작성자에게 알림
		Map<String, Object> alertInfo = this.replyService.alertInfo(replyVO.getBrdNo());
		if(Integer.parseInt(String.valueOf(alertInfo.get("BRD_HEAD")))==2) {
			Map<String, Object> projInfo = this.projectService.projInfo(Integer.parseInt(String.valueOf(alertInfo.get("PROJ_ID"))));
			Map<String, Object> alertmap = new HashMap<String, Object>();
			alertmap.put("memNo", alertInfo.get("MEM_NO"));
			alertmap.put("altCn", projInfo.get("PROJ_TTL")+" "+boardVO.getPmemGrp()+" 그룹 "+alertInfo.get("BRD_TTL")+" 헬프데스크에 댓글이 작성되었습니다");
			alertmap.put("altSend", (String)session.getAttribute("memNo"));
			alertmap.put("altLink", "/board/boardDetail?brdNo="+replyVO.getBrdNo()+"&projId="+Integer.parseInt(String.valueOf(alertInfo.get("PROJ_ID")))+"&pmemGrp="+boardVO.getPmemGrp());
			this.alertService.alertInsert(alertmap);
		}
		
			
		return "redirect:/board/boardDetail?brdNo="+ boardVO.getBrdNo() + "&projId=" + boardVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(boardVO.getPmemGrp(), "UTF-8");
	}
	
	//게시글 댓글 수정하기
	@PostMapping("/replyUpdate")
	public String replyUpdate(ReplyVO replyVO, BoardVO boardVO, HttpServletRequest request) throws UnsupportedEncodingException{
		log.info("replyVO : " + replyVO.toString());
		
		int replyUpdate = this.replyService.replyUpdate(replyVO);
		log.info("replyUpdate : " + replyUpdate);
		
		//작업 내역 테이블에 insert 시작
			HistoryVO hvo = new HistoryVO();
			hvo.setPmemCd(Integer.parseInt(replyVO.getPmemCd()));
			hvo.setHisKey(replyVO.getRplNo());
			hvo.setHisCn(replyVO.getRplCn());
			this.historyService.replyUp(hvo);
		//작업 내역 테이블에 insert 끝
			
		return "redirect:/board/boardDetail?brdNo="+ boardVO.getBrdNo() + "&projId=" + boardVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(boardVO.getPmemGrp(), "UTF-8");
	}
	
	//게시글 댓글 삭제하기
	@PostMapping("/replyDelete")
	public String replyDelete(String rplNo, ReplyVO replyVO, BoardVO boardVO) throws UnsupportedEncodingException{
		log.info("replyVO : " + replyVO.toString());
		
		int replyDelete = this.replyService.replyDelete(rplNo);
		
		log.info("replyDelete : " + replyDelete);
		
		//작업 내역 테이블에 insert 시작
			HistoryVO hvo = new HistoryVO();
			hvo.setPmemCd(Integer.parseInt(replyVO.getPmemCd()));
			hvo.setHisKey(replyVO.getRplNo());
			this.historyService.replyDel(hvo);
		//작업 내역 테이블에 insert 끝
		
		return "redirect:/board/boardDetail?brdNo="+ boardVO.getBrdNo() + "&projId=" + boardVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(boardVO.getPmemGrp(), "UTF-8");
	}
}

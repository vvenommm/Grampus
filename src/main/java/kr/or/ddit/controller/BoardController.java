package kr.or.ddit.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.service.AttachService;
import kr.or.ddit.service.BoardService;
import kr.or.ddit.service.HistoryService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.service.ReplyService;
import kr.or.ddit.util.PageVO;
import kr.or.ddit.vo.AttachVO;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.HistoryVO;
import kr.or.ddit.vo.ProMemVO;
import kr.or.ddit.vo.ReplyVO;
import lombok.extern.slf4j.Slf4j;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@Slf4j
@RequestMapping("/board")
@Controller
public class BoardController {

	@Inject
	BoardService boardService;

	@Inject
	ReplyService replyService;

	@Inject
	AttachService attachService;
	
	@Inject
	HistoryService historyService;
	
	
	// 게시판 조회
	@GetMapping("/boardList")
	public String boardList(BoardVO boardVO, Model model, HttpServletRequest request, Map<String, Object> map, @RequestParam(defaultValue = "1") int currentPage) {
		
/////////////pmemCd 가져오기/////////////
		
		HttpSession session = request.getSession();
		session.setAttribute("projId", boardVO.getProjId());
		session.setAttribute("grp", boardVO.getPmemGrp());
		boardVO.setMemNo((String)session.getAttribute("memNo"));
		
		boardVO.setPmemCd(this.boardService.getPmemCd(boardVO).getPmemCd());
		session.setAttribute("pmemCd", boardVO.getPmemCd());
		log.info("boardVO : " + boardVO.toString());
		
/////////////////////////////////////
		
		//페이징을 위해 값 추가
		boardVO.setCurrentPage(currentPage);
		boardVO.setShow(20);
		
		
		List<BoardVO> boardVOList = new ArrayList<BoardVO>();
		boardVOList = this.boardService.boardList(boardVO);
		
		//프로젝트 명 불러오기
		BoardVO projTtl = this.boardService.projTtl(boardVO);
		log.info("projTtl : " + boardVO.getProjTtl());
	
		model.addAttribute("projTtl", projTtl);
		model.addAttribute("boardVOList", boardVOList);
		log.info("boardVO : " + boardVO.toString());
		
		
		
///////////////// 페이징 처리 시작 ////////////////////
		
		int total = this.boardService.totalPages(boardVO);
		PageVO page = new PageVO(total, currentPage, 20, 5, boardVOList);
		log.info("     boardList의 페이지vo!!!! : " + page.toString());
		session.setAttribute("list", page);
		
		
///////////////// 페이징 처리 끄읕 ////////////////////
		
		

		return "board/boardList";
	}

	// 게시판 상세보기 //댓글 리스트 //펌부파일 리스트 //게시판 조회수 증가
	@GetMapping("/boardDetail")
	public String boardDetail(BoardVO boardVO, ReplyVO replyVO, AttachVO attachVO, Model model, String brdNo, HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("projId", boardVO.getProjId());
		session.setAttribute("grp", boardVO.getPmemGrp());
		boardVO.setMemNo((String)session.getAttribute("memNo"));
		
		boardVO.setPmemCd(this.boardService.getPmemCd(boardVO).getPmemCd());
		session.setAttribute("pmemCd", boardVO.getPmemCd());
		//////// 세션 여기까지 ///////
		
		log.info("boardVO : " + boardVO.toString());
		log.info("attachVO : " + attachVO.toString());
		log.info("replyVO : " + replyVO.toString());
		
		//프로젝트 명 불러오기
		BoardVO projTtl = this.boardService.projTtl(boardVO);
		model.addAttribute("projTtl", projTtl);
		
		// 게시판 상세보기
		boardVO = this.boardService.boardDetail(boardVO);
		model.addAttribute("boardVO", boardVO);

		// 댓글 리스트
		List<ReplyVO> replyVOList = new ArrayList<ReplyVO>();
		replyVOList = this.replyService.replyList(replyVO);
		model.addAttribute("replyVOList", replyVOList);

		// 첨부파일 리스트
		List<AttachVO> attachVOList = new ArrayList<AttachVO>();
		attachVOList = this.attachService.attachList(attachVO);
		model.addAttribute("attachVOList", attachVOList);
		
		// 게시판 조회수 증가
		int boardHit = boardService.boardHit(brdNo);
		log.info("boardHit : " + boardHit);
		

		return "board/boardDetail";
	}

	// 게시글 작성하기 //첨부파일 작성
	@GetMapping("/boardWrite")
	public String boardWrite(@ModelAttribute BoardVO boardVO, @ModelAttribute AttachVO attachVO, HttpServletRequest request) {
		// 게시글 작성
		log.info("boardVO : " + boardVO.toString());

		// 파일 첨부
		log.info("attachVO : " + attachVO.toString());
		
		HttpSession session = request.getSession();
		session.setAttribute("projId", boardVO.getProjId());
		session.setAttribute("grp", boardVO.getPmemGrp());
		boardVO.setMemNo((String)session.getAttribute("memNo"));
		
		boardVO.setPmemCd(this.boardService.getPmemCd(boardVO).getPmemCd());
		session.setAttribute("pmemCd", boardVO.getPmemCd());
		
		return "board/boardWrite";
	}

	@PostMapping("/boardWritePost")
	public String boardWritePost(@ModelAttribute BoardVO boardVO, MultipartFile[] uploadFile) throws UnsupportedEncodingException {
		// BoardVO [brdNo=null, pmemCd=1, brdHead=1, brdTtl=asdf, brdCn=, brdDy=null,
		// brdInq=0
		// ,
		// uploadFile=[org.springframework.web.multipart.commons.CommonsMultipartFile@6fedf4af],
		// rplCn=null, profNm=null, projId=0, memId=null]
		log.info("boardVO : " + boardVO.toString());

		int boardInsert = this.boardService.boardInsert(boardVO);
		
		//작업내역 테이블에 들어갈 vo 생성 후 쿼리 실행 시작
			HistoryVO hvo = new HistoryVO();
			hvo.setPmemCd(boardVO.getPmemCd());
			hvo.setHisKey(boardVO.getBrdNo());
			hvo.setHisCn(boardVO.getBrdCn());
			this.historyService.boardIn(hvo);
		//작업내역 테이블에 들어갈 vo 생성 후 쿼리 실행 끝

		// 파일이 저장되는 경로
		String uploadFolder = "D:\\D_Other";

		// 파일 값 저장할 리스트
		List<AttachVO> attachVOList = new ArrayList<AttachVO>();

		for (MultipartFile multipartFile : uploadFile) {
			log.info("---------------------------");
			// 이미지 명
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			// uploadFolder : C:\\upload
			// multipartFile.getOriginalFilename() : img01.jpg
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			// 파일 값 정보
			AttachVO attachVO = new AttachVO();
			attachVO.setBrdNo(boardVO.getBrdNo());
			attachVO.setBattNm(multipartFile.getOriginalFilename());
			attachVO.setBattSz((int) multipartFile.getSize());
			
			log.info("attachVO : " + attachVO.toString());
			
			// 리스트에 파일 값 넣기
			attachVOList.add(attachVO);
			
			try {
				// 파일이 복사 됨
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException e) {
				log.error(e.getMessage());
				log.error("ellegal ====>> {}", saveFile.getPath());
			} catch (IOException e) {
				log.error(e.getMessage());
				log.error("io ====>> {}", saveFile.getPath());
			}
			
		} // end for
		
		// 리스트 만큼 삽입하기
		for (AttachVO attachVO : attachVOList) {
			int attachInsert = this.attachService.attachInsert(attachVO);
		}
		
		log.info("projId : " + boardVO.getPmemGrp());
		return "redirect:/board/boardList?brdHead="+ boardVO.getBrdHead() +"&projId="+boardVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(boardVO.getPmemGrp(), "UTF-8");
	}

	// 게시글 수정하기
	@PostMapping("/boardUpdate")
	public String boardUpdate(BoardVO boardVO, MultipartFile[] uploadFile) throws UnsupportedEncodingException{
		// 게시글 수정
		log.info("boardVO : " + boardVO.toString());
		
		//작업내역 테이블에 수정 내역 insert 시작
		HistoryVO hvo = new HistoryVO();
		hvo.setPmemCd(boardVO.getPmemCd());
		hvo.setHisKey(boardVO.getBrdNo());
		hvo.setHisCn(boardVO.getBrdCn());
		this.historyService.boardUp(hvo);
		//작업내역 테이블에 수정 내역 insert 끝

		// 파일이 저장되는 경로
		String uploadFolder = "D:\\D_Other";

		// 파일 값 저장할 리스트
		List<AttachVO> attachVOList = new ArrayList<AttachVO>();

		for (MultipartFile multipartFile : uploadFile) {
			log.info("---------------------------");
			// 이미지 명
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			// uploadFolder : C:\\upload
			// multipartFile.getOriginalFilename() : img01.jpg
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

			// 파일 값 정보
			AttachVO attachVO = new AttachVO();
			attachVO.setBrdNo(boardVO.getBrdNo());
			attachVO.setBattNm(multipartFile.getOriginalFilename());
			attachVO.setBattSz((int) multipartFile.getSize());

			log.info("attachVO : " + attachVO.toString());

			// 리스트에 파일 값 넣기
			attachVOList.add(attachVO);

			try {
				// 파일이 복사 됨
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException e) {
				log.error("ellegal ====>> {}", e.getMessage());
				log.error("ellegal ====>> {}", saveFile.getPath());
			} catch (IOException e) {
				log.error("IOEx ====> {}" ,e.getMessage());
				log.error("IOEx ====> {}" ,saveFile.getPath());
			}

		} // end for

		// 리스트 만큼 삽입하기
		for (AttachVO attachVO : attachVOList) {
			int attachInsert = this.attachService.attachInsert(attachVO);
		}

		int boardUpdate = this.boardService.boardUpdate(boardVO);
		log.info("boardUpdate : " + boardUpdate);

		log.info("pmemGrp : " + boardVO.getPmemGrp());
		return "redirect:/board/boardDetail?brdNo="+ boardVO.getBrdNo() + "&projId=" + boardVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(boardVO.getPmemGrp(), "UTF-8");
	}

	// 게시글 삭제하기
	@PostMapping("/boardDelete")
	public String boardDelete(String brdNo, BoardVO boardVO) throws UnsupportedEncodingException{

		log.info("boardVO : " + boardVO.toString()) ;
		
		//첨부파일 삭제
		int attachDelete = this.boardService.attachDel(brdNo);
		
		log.info("attachDelete : " + attachDelete);
		
		//게시글 삭제
		int boardDelete = this.boardService.boardDelete(brdNo);

		log.info("boardDelete : " + boardDelete);
		
		//작업내역 테이블에 insert 시작
			HistoryVO hvo = new HistoryVO();
			hvo.setPmemCd(boardVO.getPmemCd());
			hvo.setHisKey(boardVO.getBrdNo());
			this.historyService.boardDel(hvo);
		//작업내역 테이블에 insert 끝

		return "redirect:/board/boardList?brdHead="+ boardVO.getBrdHead() +"&projId="+boardVO.getProjId() +"&pmemGrp=" + URLEncoder.encode(boardVO.getPmemGrp(), "UTF-8");
	}

}

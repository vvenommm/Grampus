package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.QNAVO;
import kr.or.ddit.vo.ReplyVO;

public interface BoardService {
	//게시판 조회
	public List<BoardVO> boardList(BoardVO boardVO);
	
	//게시판 상세조회
	public BoardVO boardDetail(BoardVO boardVO);
	
	//게시판 조회수 +1
	public int boardHit(String brdNo);
	
	//게시판 작성
	public int boardInsert(BoardVO boardVO);
	
	//게시판 수정
	public int boardUpdate(BoardVO boardVO);
	
	//게시판 삭제
	public int boardDelete(String brdNo);
	
	//pmemCd 가져오기
	public BoardVO getPmemCd(BoardVO boardVO);

	//게시판 삭제 시 첨부파일 삭제
	public int attachDel(String brdNo);
	
	//프로젝트 명 가져오기
	public BoardVO projTtl(BoardVO boardVO);

	
	
	
	//페이징용
	//전체 글 갯수
	public int totalPages(BoardVO bvo);
}

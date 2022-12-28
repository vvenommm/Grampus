package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.BoardMapper;
import kr.or.ddit.service.BoardService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.ProjectVO;

@Service
public class BoardServiceImpl implements BoardService{
	@Inject
	BoardMapper boardMapper;
	
	//게시판 조회
	@Override
	public List<BoardVO> boardList(BoardVO boardVO){
		return this.boardMapper.boardList(boardVO);
	}
	
	//게시판 상세조회
	@Override
	public BoardVO boardDetail(BoardVO boardVO){
		return this.boardMapper.boardDetail(boardVO);
	}
	
	//게시판 조회수 +1
	@Override
	public int boardHit(String brdNo){
		return this.boardMapper.boardHit(brdNo);
	}
	
	//게시판 작성
	@Override
	public int boardInsert(BoardVO boardVO) {
		return this.boardMapper.boardInsert(boardVO);
	}
	
	//게시판 수정
	@Override
	public int boardUpdate(BoardVO boardVO) {
		return this.boardMapper.boardUpdate(boardVO);
	}
	
	//게시판 삭제
	@Override
	public int boardDelete(String brdNo) {
		return this.boardMapper.boardDelete(brdNo);
	}
	
	//pmemCd 가져오기
	@Override
	public BoardVO getPmemCd(BoardVO boardVO) {
		return this.boardMapper.getPmemCd(boardVO);
	}
	
	//게시판 삭제 시 첨부파일 삭제
	@Override
	public int attachDel(String brdNo){
		return this.boardMapper.attachDel(brdNo);
	}
	
	//프로젝트 명 가져오기
	@Override
	public BoardVO projTtl(BoardVO boardVO) {
		return this.boardMapper.projTtl(boardVO);
	}
	
	
	
	
	
	//페이징용
	//전체 글 갯수
	public int totalPages(BoardVO bvo) {
		return this.boardMapper.totalPages(bvo);
	}
	
}

package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.HistoryMapper;
import kr.or.ddit.service.HistoryService;
import kr.or.ddit.vo.HistoryVO;

@Service
public class HistoryServiceImpl implements HistoryService {
	
	@Autowired
	HistoryMapper hisMapper;
	
	
	//////////////////////////일감 //////////////////////////
	//일감 등록
	@Override
	public int taskIn(HistoryVO vo) {
		return this.hisMapper.taskIn(vo);
	}
	
	//일감 수정
	@Override
	public int taskUp(HistoryVO vo) {
		return this.hisMapper.taskUp(vo);
	}
	
	//일감 삭제
	@Override
	public int taskDel(HistoryVO vo) {
		return this.hisMapper.taskDel(vo);
	}
	
	
	////////////////////////// 이슈 //////////////////////////
	//이슈 등록
	@Override
	public int issueIn(HistoryVO vo) {
		return this.hisMapper.issueIn(vo);
	}
	
	//이슈 수정
	@Override
	public int issueUp(HistoryVO vo) {
		return this.hisMapper.issueUp(vo);
	}
	
	//이슈 삭제
	@Override
	public int issueDel(HistoryVO vo) {
		return this.hisMapper.issueDel(vo);
	}

	
	////////////////////////// 이슈 댓글 //////////////////////////
	//이슈 댓글 등록
	public int answerIn(HistoryVO vo) {
		return this.hisMapper.answerIn(vo);
	}
	
	//이슈 댓글 수정
	public int answerUp(HistoryVO vo) {
		return this.hisMapper.answerUp(vo);
	}
	
	//이슈 댓글 삭제
	public int answerDel(HistoryVO vo) {
		return this.hisMapper.answerDel(vo);
	}
	
	
	////////////////////////// 게시글 //////////////////////////
	//게시글 등록
	@Override
	public int boardIn(HistoryVO vo) {
		return this.hisMapper.boardIn(vo);
	}
	
	//게시글 수정
	@Override
	public int boardUp(HistoryVO vo) {
		return this.hisMapper.boardUp(vo);
	}
	
	//게시글 삭제
	@Override
	public int boardDel(HistoryVO vo) {
		return this.hisMapper.boardDel(vo);
	}
	
	
	////////////////////////// 댓글 //////////////////////////
	//댓글 등록
	@Override
	public int replyIn(HistoryVO vo) {
		return this.hisMapper.replyIn(vo);
	}
	
	//댓글 수정
	@Override
	public int replyUp(HistoryVO vo) {
		return this.hisMapper.replyUp(vo);
	}
	
	//댓글 삭제
	@Override
	public int replyDel(HistoryVO vo) {
		return this.hisMapper.replyDel(vo);
	}

}

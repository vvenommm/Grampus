package kr.or.ddit.service;

import kr.or.ddit.vo.HistoryVO;

public interface HistoryService {
	
	//////////////////////////일감 //////////////////////////
	//일감 등록
	public int taskIn(HistoryVO vo);
	
	//일감 수정 
	public int taskUp(HistoryVO vo);
	
	//일감 삭제
	public int taskDel(HistoryVO vo);
	
	
	////////////////////////// 이슈 //////////////////////////
	//이슈 등록
	public int issueIn(HistoryVO vo);
	
	//이슈 수정
	public int issueUp(HistoryVO vo);
	
	//이슈 삭제
	public int issueDel(HistoryVO vo);

	
	////////////////////////// 이슈 댓글 //////////////////////////
	//이슈 댓글 등록
	public int answerIn(HistoryVO vo);
	
	//이슈 댓글 수정
	public int answerUp(HistoryVO vo);
	
	//이슈 댓글 삭제
	public int answerDel(HistoryVO vo);
	
	
	////////////////////////// 게시글 //////////////////////////
	//게시글 등록
	public int boardIn(HistoryVO vo);
	
	
	//게시글 수정
	public int boardUp(HistoryVO vo);
	
	//게시글 삭제
	public int boardDel(HistoryVO vo);
	
	
	////////////////////////// 댓글 //////////////////////////
	//댓글 등록
	public int replyIn(HistoryVO vo);
	
	//댓글 수정
	public int replyUp(HistoryVO vo);
	
	//댓글 삭제
	public int replyDel(HistoryVO vo);

}

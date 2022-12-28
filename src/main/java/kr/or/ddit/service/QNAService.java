package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.QNAVO;

public interface QNAService {
	//QNA조회
	public List<QNAVO> qnaList(Map<String, Object> map);
	
	//QNA상세 조회
	public QNAVO qnaDetail(String qnaNo);
	
	//QNA 작성
	public int qnaInsert(QNAVO qnaVO);
	
	//QNA 수정
	public int qnaUpdate(QNAVO qnaVO);
	
	//QNA 삭제
	public int qnaDelete(String qnaNo);
	
	//QNA 댓글 등록 & 수정
	public int qnaReply(QNAVO qnaVO);
	
	//QNA 댓글 삭제
	public int qnaReplyDelete(QNAVO qnaVO);
}

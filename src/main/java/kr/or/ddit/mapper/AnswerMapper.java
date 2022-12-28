package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.AnswerVO;

public interface AnswerMapper {
	
	//이슈 댓글 출력
	public List<AnswerVO> issueAnswer(Map<String, Object> map);
	
	//이슈 댓글 등록
	public int newAnswer(Map<String, Object> map);
	
	//이슈 댓글 삭제
	public int deleteAnswer(int ansNo);
	
	//이슈 댓글 수정
	public int updateAnswer(AnswerVO answerVO);
	
	//이슈글 삭제시 댓글도 함께 삭제
	public int autoDelete(String issueNo);
}

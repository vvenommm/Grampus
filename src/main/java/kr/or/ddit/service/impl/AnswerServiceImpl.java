package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.AnswerMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.AnswerService;
import kr.or.ddit.vo.AnswerVO;

@Service
public class AnswerServiceImpl implements AnswerService{
	@Autowired
	AnswerMapper answerMapper;
	
	//이슈 댓글 출력
	@Override
	public List<AnswerVO> issueAnswer(Map<String, Object> map) {
		return this.answerMapper.issueAnswer(map);
	}
	
	//이슈 댓글 등록
	@Override
	public int newAnswer(Map<String, Object> map) {
		return this.answerMapper.newAnswer(map);
	}
	
	//이슈 댓글 삭제
	@Override
	public int deleteAnswer(int ansNo) {
		return this.answerMapper.deleteAnswer(ansNo);
	}
	
	//이슈 댓글 수정
	@Override
	public int updateAnswer(AnswerVO answerVO) {
		return this.answerMapper.updateAnswer(answerVO);
	}
	
	//이슈글 삭제시 댓글도 함께 삭제
	@Override
	public int autoDelete(String issueNo) {
		return this.answerMapper.autoDelete(issueNo);
	}
}

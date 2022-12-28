package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.QNAMapper;
import kr.or.ddit.service.QNAService;
import kr.or.ddit.vo.QNAVO;

@Service
public class QNAServiceImpl implements QNAService{
	@Inject
	QNAMapper qnaMapper;
	
	//QNA조회
	@Override
	public List<QNAVO> qnaList(Map<String, Object> map){
		return this.qnaMapper.qnaList(map);
	}
	
	//QNA상세조회
	@Override
	public QNAVO qnaDetail(String qnaNo) {
		return this.qnaMapper.qnaDetail(qnaNo);
	}
	
	//QNA 작성
	@Override
	public int qnaInsert(QNAVO qnaVO) {
		return this.qnaMapper.qnaInsert(qnaVO);
	}
	
	//QNA 수정
	@Override
	public int qnaUpdate(QNAVO qnaVO) {
		return this.qnaMapper.qnaUpdate(qnaVO);
	}
	
	//QNA 삭제
	@Override
	public int qnaDelete(String qnaNo) {
		return this.qnaMapper.qnaDelete(qnaNo);
	}
	
	//QNA 댓글 등록 & 수정
	@Override
	public int qnaReply(QNAVO qnaVO) {
		return this.qnaMapper.qnaReply(qnaVO);
	}
	
	//QNA 댓글 사제
	@Override
	public int qnaReplyDelete(QNAVO qnaVO) {
		return this.qnaMapper.qnaReplyDelete(qnaVO);
	}
	
}

package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ReplyMapper;
import kr.or.ddit.service.ReplyService;
import kr.or.ddit.vo.ReplyVO;

@Service
public class ReplyServiceImpl implements ReplyService{
	@Inject
	ReplyMapper replyMapper;
	
	//게시판 댓글 조회
	@Override
	public List<ReplyVO> replyList(ReplyVO replyVO){
		return this.replyMapper.replyList(replyVO);
	}
	
	//게시판 댓글 작성
	@Override
	public int replyInsert(ReplyVO replyVO) {
		return this.replyMapper.replyInsert(replyVO);
	}
	
	//게시판 댓글 수정
	@Override
	public int replyUpdate(ReplyVO replyVO) {
		return this.replyMapper.replyUpdate(replyVO);
	}
	
	//게시판 댓글 삭제
	@Override
	public int replyDelete(String rplNo) {
		return this.replyMapper.replyDelete(rplNo);
	}
	
	//pmemCd 가져오기
	@Override
	public ReplyVO pmemCdGet(ReplyVO replyVO) {
		return this.replyMapper.pmemCdGet(replyVO);
	}
	
	//알림 전송을 위한 정보 가져오기
	public Map<String, Object> alertInfo(String brdNo){
		return this.replyMapper.alertInfo(brdNo);
	};
	
}

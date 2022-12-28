package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ReplyVO;

public interface ReplyMapper {
	
	//게시판 댓글 조회
	public List<ReplyVO> replyList(ReplyVO replyVO);
	
	//게시판 댓글 작성
	public int replyInsert(ReplyVO replyVO);
	
	//게시판 댓글 수정
	public int replyUpdate(ReplyVO replyVO);
	
	//게시판 댓글 삭제
	public int replyDelete(String rplNo);
	
	//pmemCd 가져오기
	public ReplyVO pmemCdGet(ReplyVO replyVO);
	
	//알림 전송을 위한 정보 가져오기
	public Map<String, Object> alertInfo(String brdNo);
}

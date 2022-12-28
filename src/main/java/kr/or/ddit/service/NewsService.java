package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.NewsLikeVO;
import kr.or.ddit.vo.NewsVO;

public interface NewsService {
	
	//글 등록하기
	public int insert(Map<String, Object> map);
	
	//사진 업데이트
	public int updateImg(Map<String, Object> map);
	
	//글 목록보기
	public List<Map<String, Object>> list(Map<String, Object> map);
	
	//좋아요 눌렀을 때
	public int updateHeart(Map<String, Object> map);
	
	//글 상세보기
	public Map<String, Object> getDetail(int newsNo);
	
	//글 수정하기
	public int update(Map<String, Object> map);
	
	//글 삭제하기
	public int delete(int newsNo);

}

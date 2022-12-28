package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.NoticeVO;

public interface NoticeService {
	
	//공지사항 조회
	public List<NoticeVO> noticeList(Map<String, Object> map);
	
	//공지사항 상세조회
	public NoticeVO noticeDetail(NoticeVO noticeVO);
	
	//공지사항 조회수 +1
	public int noticeHit(String ntcNo);
	
	//공지사항 작성
	public int noticeInsert(Map<String, Object> map);
	
	//공지사항 수정
	public int noticeUpdate(Map<String, Object> map);
	
	//공지사항 삭제
	public int noticeDelete(int ntcNo);
	
	//pmemCd 가져오기
	public Map<String, Object> getPmemCd(Map<String, Object> map);
	
	//같은 그룹 내 사람들 불러오기
	public List<Map<String, Object>> getProjGrp(Map<String, Object> map);
	
}

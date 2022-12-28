package kr.or.ddit.service;

import java.util.Map;

public interface MarkService {
	//북마크 등록
	public int insertMark(Map<String, Object> map);
	
	//북마크 삭제
	public int deleteMark(Map<String, Object> map);
	
	//북마크 등록여부
	public int markCheck(Map<String, Object> map);

	public int deleteBookMark(int projId);
}

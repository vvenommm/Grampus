package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CalendarVO;

public interface CalendarService {
	
	//개인 일정
	public List<Map<String, Object>> selectCalendar(Map<String, Object> map);
	
	//일정 삭제
	public int deleteCalendar(String calNo);
	
	//일정 모두 삭제
	public int deleteAllCalendar();
	
	//일정 수정
	public int updateCalendar(CalendarVO calendarVO);
	
	//calNo max값 구하기
	public String maxcalNo();
	
	//새 일정 생성
	public int createCalendar(CalendarVO calendarVO);
	
	//프로젝트 멤버 코드 구하기
	public int selectPmemCd(Map<String, Object> map);
	
	//그룹 일정 가져오기(PM용)
	public List<Map<String, Object>> groupCalendarPm(Map<String, Object> map);
	
	//그룹 일정 가져오기(나머지용)
	public List<Map<String, Object>> groupCalendarOther(Map<String, Object> map);
}

package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.CalendarMapper;
import kr.or.ddit.service.CalendarService;
import kr.or.ddit.vo.CalendarVO;

@Service
public class CalendarServiceImpl implements CalendarService{
	@Autowired
	CalendarMapper calendarMapper;
	
	//개인 일정
	@Override
	public List<Map<String, Object>> selectCalendar(Map<String, Object> map) {
		return calendarMapper.selectCalendar(map);
	}
	
	//일정 삭제
	@Override
	public int deleteCalendar(String calNo) {
		return calendarMapper.deleteCalendar(calNo);
	}
	
	//일정 모두 삭제
	@Override
	public int deleteAllCalendar() {
		return calendarMapper.deleteAllCalendar();
	}
	
	//일정 수정
	@Override
	public int updateCalendar(CalendarVO calendarVO) {
		return calendarMapper.updateCalendar(calendarVO);
	}
	
	//calNo max값 구하기
	@Override
	public String maxcalNo() {
		return calendarMapper.maxcalNo();
	}

	//새 일정 생성
	@Override
	public int createCalendar(CalendarVO calendarVO) {
		return calendarMapper.createCalendar(calendarVO);
	}

	//프로젝트 멤버 코드 구하기
	@Override
	public int selectPmemCd(Map<String, Object> map) {
		return this.calendarMapper.selectPmemCd(map);
	}
	
	//그룹 일정 가져오기(PM용)
	@Override
	public List<Map<String, Object>> groupCalendarPm(Map<String, Object> map) {
		return this.calendarMapper.groupCalendarPm(map);
	}

	//그룹 일정 가져오기(나머지용)
	@Override
	public List<Map<String, Object>> groupCalendarOther(Map<String, Object> map) {
		return this.calendarMapper.groupCalendarOther(map);
	}




}

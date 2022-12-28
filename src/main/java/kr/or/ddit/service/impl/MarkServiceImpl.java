package kr.or.ddit.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MarkMapper;
import kr.or.ddit.service.MarkService;

@Service
public class MarkServiceImpl implements MarkService{
	@Autowired
	MarkMapper markMapper;
	
	//북마크 등록
	@Override
	public int insertMark(Map<String, Object> map) {
		return markMapper.insertMark(map);
	};
	
	//북마크 삭제
	@Override
	public int deleteMark(Map<String, Object> map) {
		return markMapper.deleteMark(map);
	};
	
	//북마크 등록여부
	@Override
	public int markCheck(Map<String, Object> map) {
		return markMapper.markCheck(map);
	};
	
	//마이페이지 북마크 삭제
	@Override
	public int deleteBookMark(int projId) {
		return this.markMapper.deleteBookMark(projId);
	}
}

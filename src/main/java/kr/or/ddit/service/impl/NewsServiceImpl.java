package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.NewsMapper;
import kr.or.ddit.service.NewsService;
import kr.or.ddit.vo.NewsLikeVO;
import kr.or.ddit.vo.NewsVO;

@Service
public class NewsServiceImpl implements NewsService{

	@Autowired
	private NewsMapper mapper;
	
	//글 등록
	@Override
	public int insert(Map<String, Object> map) {
		return this.mapper.insert(map);
	}
	
	//사진 업데이트
	public int updateImg(Map<String, Object> map) {
		return this.mapper.updateImg(map);
	}
	
	//글 목록보기
	@Override
	public List<Map<String, Object>> list(Map<String, Object> map) {
		if(map.get("memNo")==null) {
			map.put("memNo", " ");
		}
		return this.mapper.list(map);
	}
	
	//좋아요 눌렀을 때
	@Override
	public int updateHeart(Map<String, Object> map) {
		return this.mapper.updateHeart(map);
	}

	//글 상세보기
	@Override
	public Map<String, Object> getDetail(int newsNo) {
		return this.mapper.getDetail(newsNo);
	}

	//글 수정하기
	@Override
	public int update(Map<String, Object> map) {
		return this.mapper.update(map);
	}
	
	//글 삭제하기
	@Override
	public int delete(int newsNo) {
		return this.mapper.delete(newsNo);
	}
	


}

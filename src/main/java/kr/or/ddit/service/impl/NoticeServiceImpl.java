package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.NoticeMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.NoticeService;
import kr.or.ddit.vo.NoticeVO;

@Service
public class NoticeServiceImpl implements NoticeService{
	
	@Autowired
	private NoticeMapper noticeMapper;

	//공지사항 조회
	@Override
	public List<NoticeVO> noticeList(Map<String, Object> map) {
		return this.noticeMapper.noticeList(map);
	}

	//공지사항 상세조회
	@Override
	public NoticeVO noticeDetail(NoticeVO noticeVO) {
		return this.noticeMapper.noticeDetail(noticeVO);
	}

	//공지사항 조회수 +1
	@Override
	public int noticeHit(String ntcNo) {
		return this.noticeMapper.noticeHit(ntcNo);
	}

	//공지사항 작성
	@Override
	public int noticeInsert(Map<String, Object> map) {
		return this.noticeMapper.noticeInsert(map);
	}

	//공지사항 수정
	@Override
	public int noticeUpdate(Map<String, Object> map) {
		return this.noticeMapper.noticeUpdate(map);
	}

	//공지사항 삭제
	@Override
	public int noticeDelete(int ntcNo) {
		return this.noticeMapper.noticeDelete(ntcNo);
	}
	
	//pmemCd 가져오기
	@Override
	public Map<String, Object> getPmemCd(Map<String, Object> map) {
		return this.noticeMapper.getPmemCd(map);
	}
	
	//같은 그룹 내 사람들 불러오기
	@Override
	public List<Map<String, Object>> getProjGrp(Map<String, Object> map){
		return this.noticeMapper.getProjGrp(map);
	};

}

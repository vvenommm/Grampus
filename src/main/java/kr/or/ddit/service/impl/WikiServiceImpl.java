package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.WikiMapper;
import kr.or.ddit.service.WikiService;
import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.WikiVO;

@Service
public class WikiServiceImpl implements WikiService{
	
	@Inject
	WikiMapper wikiMapper;

	//위키리스트 조회
	@Override
	public List<WikiVO> wikiList(WikiVO wikiVO){
		return this.wikiMapper.wikiList(wikiVO);
	}

	//등록
	@Override
	public int wikiInsert(WikiVO wikiVO) {
		return this.wikiMapper.wikiInsert(wikiVO);
	}
	
	//수정
	@Override
	public int wikiUpdate(WikiVO wikiVO) {
		return this.wikiMapper.wikiUpdate(wikiVO);
	}
	
	//삭제
	@Override
	public int wikiDelete(int wikiNo) {
		return this.wikiMapper.wikiDelete(wikiNo);
	}
	
	//pm구하기
	@Override
	public ProfileVO wikiPm(ProfileVO profileVO){
		return this.wikiMapper.wikiPm(profileVO);
	}
	
	//프로젝트 명 가져오기
	@Override
	public WikiVO projTtl(WikiVO wikiVO) {
		return this.wikiMapper.projTtl(wikiVO);
	}
	
}

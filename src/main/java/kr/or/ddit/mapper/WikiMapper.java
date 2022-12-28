package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.WikiVO;

public interface WikiMapper {
	
	//위키리스트 조회
	public List<WikiVO> wikiList(WikiVO wikiVO);

	//등록
	public int wikiInsert(WikiVO wikiVO);
	
	//수정
	public int wikiUpdate(WikiVO wikiVO);
	
	//삭제
	public int wikiDelete(int wikiNo);
	
	//pm구하기
	public ProfileVO wikiPm(ProfileVO profileVO);
	
	//프로젝트 명 가져오기
	public WikiVO projTtl(WikiVO wikiVO);
}

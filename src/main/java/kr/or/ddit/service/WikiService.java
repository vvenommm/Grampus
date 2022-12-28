package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.ProfileVO;
import kr.or.ddit.vo.WikiVO;

public interface WikiService {

	//위키조회
	public List<WikiVO> wikiList(WikiVO wikiVO);

	//등록
	public int wikiInsert(WikiVO wikiVO);

	//수정
	public int wikiUpdate(WikiVO wikiVO);

	//삭제
	public int wikiDelete(int wikiNo);

	public ProfileVO wikiPm(ProfileVO profileVO);

	//프로젝트 명 가져오기
	public WikiVO projTtl(WikiVO wikiVO);
}

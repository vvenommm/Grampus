package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.FAQVO;

public interface FAQService {
	//FAQ조회
	public List<FAQVO> faqList();
	
	//FAQ상세 조회
	public FAQVO faqDetail(String faqNo);

	//FAQ 작성
	public int faqInsert(FAQVO faqVO);
}

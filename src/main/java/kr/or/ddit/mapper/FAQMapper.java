package kr.or.ddit.mapper;

import java.util.List;

import kr.or.ddit.vo.FAQVO;

public interface FAQMapper {

	//FAQ 리스트 조회
	public List<FAQVO> faqList();
	
	//FAQ 상세 조회
	public FAQVO faqDetail(String faqNo);
	
	//FAQ 작성
	public int faqInsert(FAQVO faqVO);

}

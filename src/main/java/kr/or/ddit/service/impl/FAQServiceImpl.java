package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.FAQMapper;
import kr.or.ddit.service.FAQService;
import kr.or.ddit.vo.FAQVO;

@Service
public class FAQServiceImpl implements FAQService{
	@Inject
	FAQMapper faqMapper;

	//FAQ 조회
	@Override
	public List<FAQVO> faqList(){
		return this.faqMapper.faqList();
	}
	
	//FAQ상세조회
	@Override
	public FAQVO faqDetail(String faqNo) {
		return this.faqMapper.faqDetail(faqNo);
	}
	
	//FAQ 작성
	@Override
	public int faqInsert(FAQVO faqVO) {
		return this.faqMapper.faqInsert(faqVO);
	}
}

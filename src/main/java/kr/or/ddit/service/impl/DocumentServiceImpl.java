package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.DocFileMapper;
import kr.or.ddit.mapper.DocumentMapper;
import kr.or.ddit.service.DocumentService;
import kr.or.ddit.vo.DocumentVO;

@Service
public class DocumentServiceImpl implements DocumentService{
	
	@Autowired
	DocumentMapper docMapper;
	
	@Autowired
	DocFileMapper docFileMapper;
	
	HttpServletRequest request;
	
	
	//1. 문서 리스트
	@Override
	public List<Map<String, Object>> docList(Map<String, Object> map) {
		return this.docMapper.docList(map);
	}
	
	//2. 문서 상세 조회
	@Override
	public Map<String, Object> docDetail(Map<String, Object> map) {
		return this.docMapper.docDetail(map);
	}

	//3. 문서 등록
	@Override
	public int docInsert(Map<String, Object> map) {
		return this.docMapper.docInsert(map);
	}
	
	//4. 문서 등록 시 필요한 pmemCd 가져오기
	public int getPmem(Map<String, Object> map) {
		return this.docMapper.getPmem(map);
	}
	
	//5. 문서 수정
	public int docEdit(DocumentVO vo) {
		return this.docMapper.docEdit(vo);
	}
	
	//6. 문서 삭제
	public int docDel(int docNo) {
		//관련 첨부파일도 삭제
		this.docFileMapper.deleteDof(docNo);
		return this.docMapper.docDel(docNo);
	}
	
	//문서 양식별 검색
	@Override
	public List<Map<String, Object>> selectType(Map<String, Object> map) {
		return this.docMapper.selectType(map);
	}
}

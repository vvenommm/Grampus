package kr.or.ddit.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.DocFileMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.DocFileService;
import kr.or.ddit.vo.DocFileVO;

@Service
public class DocFileServiceImpl implements DocFileService{
	
	@Inject
	DocFileMapper docFileMapper;
	
	//첨부파일 등록
	@Override
	public int fileInsert(DocFileVO docFileVO) {
		return this.docFileMapper.fileInsert(docFileVO);
	}

	//첨부파일 삭제
	@Override
	public int deleteDof(int docNo) {
		return this.docFileMapper.deleteDof(docNo);
	}
	
	//첨부파일 조회
	@Override
	public List<DocFileVO> selectFile(int docNo) {
		return this.docFileMapper.selectFile(docNo);
	}
	
	//다운로드할 파일 가져오기
	@Override
	public DocFileVO getDownload(int dcfNo) {
		return this.docFileMapper.getDownload(dcfNo);
	}
	
	//파일 삭제
	@Override
	public int delFile(int dcfNo) {
		return this.docFileMapper.delFile(dcfNo);
	}
	
	//문서번호 최대값
	@Override
	public int maxDcfNo() {
		return this.docFileMapper.maxDcfNo();
	}
}

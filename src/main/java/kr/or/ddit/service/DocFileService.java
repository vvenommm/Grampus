package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.DocFileVO;

public interface DocFileService {

	//첨부파일 등록
	public int fileInsert(DocFileVO docFileVO);
	
	//첨부파일 삭제
	public int deleteDof(int docNo);
	
	//첨부파일 조회
	public List<DocFileVO> selectFile(int docNo);
	
	//다운로드할 파일 가져오기
	public DocFileVO getDownload(int dcfNo);
	
	//파일 삭제
	public int delFile(int dcfNo);
	
	//문서번호 최대값
	public int maxDcfNo();
}

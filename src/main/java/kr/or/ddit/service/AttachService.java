package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.AttachVO;

public interface AttachService {
	
	//첨부파일 삽입하기
	public int attachInsert(AttachVO attachVO);
	
	//첨부파일 리스트
	public List<AttachVO> attachList(AttachVO attachVO);
	
	//첨부파일 삭제하기
	public int attachDelete(int battNo);

}

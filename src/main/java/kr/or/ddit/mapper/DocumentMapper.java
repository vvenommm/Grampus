package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.DocumentVO;

public interface DocumentMapper {

	//1. 문서 리스트
	public List<Map<String, Object>> docList(Map<String, Object> map);
	
	//2. 문서 상세 조회
	public Map<String, Object> docDetail(Map<String, Object> map);
	
	//3. 문서 등록
	public int docInsert(Map<String, Object> map);
	
	//4. 문서 등록 시 필요한 pmemCd 가져오기
	public int getPmem(Map<String, Object> map);
	
	//5. 문서 수정
	public int docEdit(DocumentVO vo);

	//6. 문서 삭제
	public int docDel(int docNo);
	
	//문서 양식별 검색
	public List<Map<String, Object>> selectType(Map<String, Object> map);
	
}

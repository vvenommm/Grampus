package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.AlertVO;

public interface AlertService {

	//마이페이지 알림함 리스트
	public List<AlertVO> alertList(AlertVO alertVO);

	//발신자별 알림 리스트
	public List<AlertVO> alertSendList(AlertVO alertVO);

	//알림 리스트 수
	public List<AlertVO> alertListCnt(AlertVO alertVO);

	//알림 상태 변경
	public int updateSendStts(AlertVO alertVO);

	//이메일 초대장 발송 시 알림함으로도 초대 알림 송신
	public int invitation(AlertVO avo);
	
	//알림 개수 카운트
	public int alertCount(String memNo);
	
	//알림 가져오기
	public List<Map<String, Object>> alertSelect(Map<String, Object> map);
	
	//알림 등록
	public int alertInsert(Map<String, Object> map);	
	
	//알림 확인시 확인 내역 변경
	public int alertCheck(int altNo);

	//알림 삭제
	public int alertDelete(int altNo);
}

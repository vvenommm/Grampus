package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.AlertMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.AlertService;
import kr.or.ddit.vo.AlertVO;

@Service
public class AlertServiceImpl implements AlertService{
	@Inject
	AlertMapper alertMapper;

	//마이페이지 알림함 리스트
	@Override
	public List<AlertVO> alertList(AlertVO alertVO){
		return this.alertMapper.alertList(alertVO);
	}
	
	//알림 발신자별 리스트
	@Override
	public List<AlertVO> alertSendList(AlertVO alertVO){
		return this.alertMapper.alertSendList(alertVO);
	}
	
	//알림 리스트 수
	@Override
	public List<AlertVO> alertListCnt(AlertVO alertVO){
		return this.alertMapper.alertListCnt(alertVO);
	}
	
	
	//알림 확인 시 확인 표시
	@Override
	public int updateSendStts(AlertVO alertVO) {
		return this.alertMapper.updateSendStts(alertVO);
	}

	//알림 삭제
	@Override
	public int alertDelete(int altNo) {
		return this.alertMapper.alertDelete(altNo);
	}
	//이메일 초대장 발송 시 알림함으로도 초대 알림 송신
	@Override
	public int invitation(AlertVO avo) {
		return this.alertMapper.invitation(avo);
	}
	
	//알림 개수 카운트
	@Override
	public int alertCount(String memNo) {
		return this.alertMapper.alertCount(memNo);
	};
	
	//알림 가져오기
	@Override
	public List<Map<String, Object>> alertSelect(Map<String, Object> map){
		return this.alertMapper.alertSelect(map);
	};
	
	//알림 등록
	@Override
	public int alertInsert(Map<String, Object> map) {
		return this.alertMapper.alertInsert(map);
	};
	
	//알림 확인시 확인 내역 변경
	@Override
	public int alertCheck(int altNo) {
		return this.alertMapper.alertCheck(altNo);
	};	
}

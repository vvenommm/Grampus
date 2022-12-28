package kr.or.ddit.mapper;

import kr.or.ddit.vo.InvitationVO;
import kr.or.ddit.vo.ProMemVO;

public interface InvitationMapper {
	
	//초대장 발송 시 테이블에 등록
	public int inviSend(InvitationVO ivo);
	
	//ranKey 가져오는 쿼리
	public InvitationVO getRanKey(InvitationVO ivo);
	
	//코드 중복 발행 방지 및 회원가입 시 초대장 코드 입력 시 비교하기
	public InvitationVO inviCdChk(InvitationVO ivo);
	
	//이미 초대장 보냈는지 확인하는 select
	public InvitationVO inviChk(InvitationVO ivo);
	
	//초대장으로 가입 시킨 후에 테이블에서 삭제
	public int inviDel(InvitationVO ivo);
	
	//이메일 초대장 못 받아서 다시 초대장 보낼 때 인증코드 update 시키기
	public int invCdUp(InvitationVO ivo);
	
	//유효시간 지났는지 확인하기(알림함에서 사용할 용도로)
	public InvitationVO isitExpired(InvitationVO ivo);
	
	//유효시간 지난 초대 코드 삭제
	public int delInvitation();
	
	public ProMemVO inviCdJoining(String invCd);
	
	public int invitation(InvitationVO ivo);
}

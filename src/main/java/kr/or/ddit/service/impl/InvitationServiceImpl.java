package kr.or.ddit.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.controller.MailSendService;
import kr.or.ddit.mapper.AlertMapper;
import kr.or.ddit.mapper.InvitationMapper;
import kr.or.ddit.mapper.MemberMapper;
import kr.or.ddit.service.InvitationService;
import kr.or.ddit.vo.AlertVO;
import kr.or.ddit.vo.InvitationVO;
import kr.or.ddit.vo.ProMemVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InvitationServiceImpl implements InvitationService {

	@Autowired
	InvitationMapper inviMapper;
	
	@Inject
	MemberMapper memberMapper;
	
	@Inject
	AlertMapper alertMapper;
	
	@Inject
	MailSendService mailService;
	
	//초대장 발송 시 테이블에 등록
	@Override
	public int inviSend(InvitationVO ivo) {
		return this.inviMapper.inviSend(ivo);
	}
	
	//ranKey 가져오는 쿼리
	public InvitationVO getRanKey(InvitationVO ivo) {
		return this.inviMapper.getRanKey(ivo);
	}
	
	//코드 중복 발행 방지 및 회원가입 시 초대장 코드 입력 시 비교하기
	@Override
	public InvitationVO inviCdChk(InvitationVO ivo) {
		return this.inviMapper.inviCdChk(ivo);
	}
	
	//이미 초대장 보냈는지 확인하는 select
	@Override
	public InvitationVO inviChk(InvitationVO ivo) {
		InvitationVO resVO = this.inviMapper.inviChk(ivo);
		if(resVO == null) {
			resVO = new InvitationVO();
			resVO.setInvNo(0);
		}
		return resVO;
	}
	
	//초대장으로 가입 시킨 후에 테이블에서 삭제
	@Override
	public int inviDel(InvitationVO ivo) {
		return this.inviMapper.inviDel(ivo);
	}
	
	//이메일 초대장 못 받아서 다시 초대장 보낼 때 인증코드 update 시키기
	@Override
	public int invCdUp(InvitationVO ivo) {
		return this.inviMapper.invCdUp(ivo);
	}

	//유효시간 지났는지 확인하기(알림함에서 사용할 용도로)
	@Override
	public InvitationVO isitExpired(InvitationVO ivo) {
		return this.inviMapper.isitExpired(ivo);
	}

	//유효시간 지난 초대 코드 삭제
	@Override
	public int delInvitation() {
		return this.inviMapper.delInvitation();
	}
	
	@Override
	public ProMemVO inviCdJoining(String invCd) {
		return this.inviMapper.inviCdJoining(invCd);
	}

	@Override
	public int invitation(InvitationVO ivo) {
		log.info("     ivo 넘어왔나요? : {}", ivo);
		
		//초대장 받았었는지 확인하기
		InvitationVO haveYou = this.inviMapper.inviChk(ivo);
		
		boolean flag = true;
		
		//랜덤 키 중복 검사
		while(flag) {
			String ranKey = this.mailService.getKey(10);
			log.info("      ranKey : " + ranKey);
			ivo.setInvCd(ranKey);
			log.info("      invCdChk에 보낼 ivo : " + ivo);
			InvitationVO v = this.inviCdChk(ivo);
			log.info("      invCdChk의 결과값 ivo : " + ivo);
			log.info("      invCdChk의 결과로 while 끝내는 InvitationVO : " + v);
			if(v == null) { //rankey 중복 아니라 보내도 되니 while 끝내기
				flag = false;
			}
		}

		//이메일 전송
		this.mailService.invitationForm(ivo);
		
		if(haveYou == null) {
			//초대장 처음 보냄 -> insert하기
			this.inviMapper.inviSend(ivo);
		}else {
			//초대장 보낸 적 있음 -> update하기
			this.inviMapper.invCdUp(ivo);
		}
		
		//회원인지 확인하기
		Map<String, Object> dubChk = new HashMap<String, Object>();
		dubChk.put("memId", ivo.getInvEmail());
		int res = this.memberMapper.dupChk(dubChk);
		
		if(res == 1) {
			//회원임
			//memNo 가져오기
			dubChk = this.memberMapper.googleLogin(dubChk);
			
			//알림 보내기
			
			String cn = String.format("<p id='ttl' data-ttl='%s'>[GRAMPUS] 초대장</p><p><%s>에서 초대장을 보냈습니다.</p>"
					+ "<p>프로젝트 상세 내용은 이메일로 확인해주세요.</p>"
					+ "<p id='invCd' data-invCd='%s'>인증 코드 : %s (유효기간 : 3일)</p>"
					+ "<button type='button' id='okBtn' class='btn btn-primary okBtn' data-projId='%d'>수락</button> "
					+ "<button type='button' id='noBtn' class='btn btn-danger noBtn' data-pmemGrp='%s'>거절</button>"
					,ivo.getTtl(), ivo.getTtl(), ivo.getInvCd(), ivo.getInvCd(), ivo.getProjId(), ivo.getPmemGrp());
			
			
			AlertVO avo = new AlertVO();
			avo.setAltSend(ivo.getMemNo()); //보내는 사람
			avo.setMemNo((String)dubChk.get("memNo")); //받는 사람
			avo.setAltCn(cn); //내용
			avo.setAltLink("/alert/alertSendList?memNo="+(String)dubChk.get("memNo")+"&altSend="+ivo.getMemNo());
			log.info("      avo 값 : " + avo);
			int result = this.alertMapper.invitation(avo);
			
		}
		
		return 0;
	}
}

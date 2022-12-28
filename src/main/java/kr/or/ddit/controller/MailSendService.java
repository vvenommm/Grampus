package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import kr.or.ddit.service.AlertService;
import kr.or.ddit.service.InvitationService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.vo.AlertVO;
import kr.or.ddit.vo.InvitationVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class MailSendService {
	@Autowired
	private JavaMailSenderImpl mailSender;
	private int authNumber;
	
	@Autowired
	InvitationService inviService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	AlertService alertService;
	
		//인증 코드 만들기
		public void makeRandomNumber() {
			// 난수의 범위 111111 ~ 999999 (6자리 난수)
			Random r = new Random();
			int checkNum = r.nextInt(888888) + 111111;
			log.info("인증번호 : " + checkNum);
			authNumber = checkNum;
		}
		
		//이메일 보낼 양식
		public String joinEmail(String email) {
			makeRandomNumber();
			String setFrom = "shgok123@naver.com"; // 이메일 인증 빈에서 설정한 자신의 이메일 주소를 입략
			String toMail = email;
			String title = "Grampus 회원 가입 인증 이메일 입니다."; //이메일 제목
			String content =
					"Grampus를 방문해주셔서 감사합니다." + //html 형식으로 작성
			"<br><br>" +
					"인증 번호는 " + authNumber + "입니다." +
					"<br>" +
					"해당 인증번호를 인증번호 확인란에 기입하여 주세요."; //이메일 내용 작성
			mailSend(setFrom, toMail, title, content);
			return Integer.toString(authNumber);
		}
		
		//이메일 전송 메소드
		public void mailSend(String setFrom, String toMail, String title, String content) {
			MimeMessage message = mailSender.createMimeMessage();
			//true 매개값을 전달하면 multipart 형식의 메세지 전달이 가능하며 문자 인코딩 설정도 가능하다.
			try {
				MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
				helper.setFrom(setFrom);
				helper.setTo(toMail);
				helper.setSubject(title);
				//true 전달 => html 형식으로 전송, 작성하지 않으면 단순 텍스트로 전달.
				helper.setText(content,true);
				mailSender.send(message);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		
		//이메일 전송 메소드
		public void mailSend3(String setFrom, String toMail, String title, String content) {
			MimeMessage message = mailSender.createMimeMessage();
			//true 매개값을 전달하면 multipart 형식의 메세지 전달이 가능하며 문자 인코딩 설정도 가능하다.
			try {
				MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
				helper.setFrom(setFrom);
				helper.setTo(toMail);
				helper.setSubject(title);
				//true 전달 => html 형식으로 전송, 작성하지 않으면 단순 텍스트로 전달.
				helper.setText(content,true);
				mailSender.send(message);
			} catch (Exception e) {
				log.info("~~~~~ 실패~~~~ " + e.getMessage());
				
			}
			
		}
		
		//초대 인증키 생성
		public String getKey(int key_len) {
			Random rnd=new Random();
			StringBuffer buf=new StringBuffer();
			for(int i=1;i<=key_len;i++) {
				if(rnd.nextBoolean())
					buf.append((char)(rnd.nextInt(26)+65));   // 0~25(26개) + 65 
				else
					buf.append(rnd.nextInt(10));
			}
			return buf.toString();
		}
		
		//초대장
		public void invitationForm(InvitationVO ivo) {
			
			log.info(" 초대장 invitationFrom의 파라미터 ivo " + ivo);
			
//			InvitationVO ivo = new InvitationVO();
//			ivo.setInvEmail((String)map.get("email"));
//			ivo.setProjId((int)map.get("projId"));
//			ivo.setPmemGrp((String)map.get("pmemGrp"));
			
			
			String setFrom = "shgok123@naver.com"; // 이메일 인증 빈에서 설정한 자신의 이메일 주소를 입략
			String toMail = ivo.getInvEmail();
			log.info("    누구한테 보내는 메일? : " + toMail);
			String title = String.format("[GRAMPUS] %s님이 초대장을 보냈습니다.", ivo.getMemNm()); //이메일 제목
			String ttl = String.format("%s님이 %s에 초대하였습니다.", ivo.getMemNm(), ivo.getTtl());
			
			
			String content =	"<link href=\"https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css\" rel=\"stylesheet\">" +
								"<link href=\"/resources/velzon/dist/assets/css/bootstrap.min.css\" rel=\"stylesheet\" type=\"text/css\" />" +
								"<div class='col-12'>\r\n" + 
								"	<table class='body-wrap' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: transparent; margin: 0;'>\r\n" + 
								"		<tbody><tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"			<td style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;' valign='top'></td>\r\n" + 
								"				<td class='container' width='600' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto;' valign='top'>\r\n" + 
								"					<div class='content' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;'>\r\n" + 
								"						<table class='main' width='100%' cellpadding='0' cellspacing='0' itemprop='action' itemscope='' itemtype='http://schema.org/ConfirmAction' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; margin: 0; border: none;'>\r\n" + 
								"							<tbody><tr style='font-family: 'Roboto', sans-serif; font-size: 14px; margin: 0;'>\r\n" + 
								"								<td class='content-wrap' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; color: #495057; font-size: 14px; vertical-align: top; margin: 0;padding: 30px; box-shadow: 0 3px 15px rgba(30,32,37,.06); ;border-radius: 7px; background-color: #fff;' valign='top'>\r\n" + 
								"									<meta itemprop='name' content='Confirm Email' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"									<table width='100%' cellpadding='0' cellspacing='0' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"										<tbody><tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"											<td class='content-block' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;' valign='top'>\r\n" + 
								"												<div style='text-align: center;margin-bottom: 15px;'>\r\n" + 
								"													<img src='resources/image/grampusLogo.png' alt='' height='23'>\r\n" + 
								"												</div>\r\n" + 
								"											</td>\r\n" + 
								"										</tr>\r\n" + 
								"										<tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"											<td class='content-block' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 24px; vertical-align: top; margin: 0; padding: 0 0 10px;  text-align: center;' valign='top'>\r\n" + 
								"												<h4 style='font-family: 'Roboto', sans-serif; font-weight: 500;'>" + ttl + "</h4>\r\n" + 
								"											</td>\r\n" + 
								"										</tr>\r\n" + 
								"										<tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"											<td class='content-block' style='font-family: 'Roboto', sans-serif; color: #878a99; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 26px; text-align: center;' valign='top'>\r\n" + 
								"												[Grampus] 본 메일은 " + ivo.getMemNm() + "님으로부터 발송되었습니다." + 
								"												<p style='margin-bottom: 13px;'> 프로젝트명 : " + ivo.getTtl() + "</p>\r\n" + 
								"												<p style='margin-bottom: 20px;'> 프로젝트 내용 : " + ivo.getProjCn() + "</p>\r\n" + 
								"											</td>\r\n" + 
								"										</tr>\r\n" + 
								"										<tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"											<td class='content-block' style='font-family: 'Roboto', sans-serif; color: #878a99; box-sizing: border-box; font-size: 15px; vertical-align: top; margin: 0; padding: 0 0 26px; text-align: center;' valign='top'>\r\n" + 
								"												<p style='margin-bottom: 13px;'>" + ivo.getMemNm() + "님이 " + toMail + "님과 함께하길 바라고 있습니다.</p>\r\n" + 
								"												<p style='margin-bottom: 13px;'>" + ivo.getMemNm() + "님과 " + ivo.getTtl() + "의 일원이 되어 프로젝트를 함께 하시겠습니까?</p>\r\n" + 
								"											</td>\r\n" + 
								"										</tr>\r\n" + 
								"										<tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"											<td class='content-block' itemprop='handler' itemscope='' itemtype='http://schema.org/HttpActionHandler' style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 22px; text-align: center;' valign='top'>\r\n" + 
								"												<p style='margin-bottom: 13px;'>참여를 원하시면 인증 코드를 입력해주세요.</p>\r\n" + 
								"											</td>\r\n" + 
								"										</tr>\r\n" + 
								"										<tr style='font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;'>\r\n" + 
								"											<td class='content-block' style='color: #878a99; text-align: center;font-family: 'Roboto', sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0; padding-top: 5px' valign='top'>\r\n" + 
								"												<p style='margin-bottom: 10px;'>인증 코드 : " + ivo.getInvCd() + "</p>\r\n" + 
								"												<p style='margin-bottom: 10px; font-weight:500;'>인증 코드는 3일동안 유효합니다.</p>\r\n" + 
								"												<a target='_blank' href='http://192.168.191.4/main' style='cursor:pointer;'><button type='buton' style='color:white; background-color:#0275d8; border-radius:5px; border:none;'>이동하기</button></a>\r\n" + 
								"											</td>\r\n" + 
								"										</tr>\r\n" + 
								"									</tbody></table>\r\n" + 
								"								</td>\r\n" + 
								"							</tr>\r\n" + 
								"						</tbody></table>\r\n" + 
								"						<div style='text-align: center; margin: 25px auto 0px auto;font-family: 'Roboto', sans-serif;'>\r\n" + 
								"							<h4 style='font-weight: 500; line-height: 1.5;font-family: 'Roboto', sans-serif;'>도움이 필요하신가요?</h4> <a href='' style='font-weight: 500;'>grampus@grampus.com</a>\r\n" + 
								"							<p style='color: #878a99; line-height: 1.5;'>본 메일은 발신 전용으로 회신이 불가합니다.</p>\r\n" + 
								"							<p style='font-family: 'Roboto', sans-serif; font-size: 14px;color: #98a6ad; margin: 0px;'>2022 GRAMPUS.</p>\r\n" + 
								"						</div>\r\n" + 
								"					</div>\r\n" + 
								"				</td>\r\n" + 
								"			</tr>\r\n" + 
								"		</tbody>\r\n" + 
								"	</table>\r\n" + 
								"</div>";
			
			log.info("    이메일 보내기 전 ");
			mailSend3(setFrom, toMail, title, content);
			log.info("    이메일 보내기 완 ");
			
			return;
		}
		
		//비밀번호 찾기 - 임시 비밀번호 발급
		
		//이메일 보낼 양식
		public String passEmail(String email) {
			
			String testPw = UUID.randomUUID().toString().replace("-", "");//-를 제거
			testPw = testPw.substring(0,6);//tempPw를 앞에서부터 10자리 잘라줌
			
			log.info("testPw : " + testPw);
			
			String setFrom = "shgok123@naver.com"; // 이메일 인증 빈에서 설정한 자신의 이메일 주소를 입략
			String toMail = email;
			String title = "Grampus 임시 비밀번호 입니다."; //이메일 제목
			String content =
					"Grampus를 이용해 주셔서 감사합니다." + //html 형식으로 작성
					"<br><br>" +
					"임시 비밀번호는  <span style='font: italic 1.5em/1em Georgia, serif; color: red;'>" + testPw + "</span> 입니다." +
					"<br>" +
					"임시 비밀번호로 로그인 해주세요."; //이메일 내용 작성
			passSend(setFrom, toMail, title, content);
			return testPw;
		}
		
		//이메일 전송 메소드
		public void passSend(String setFrom, String toMail, String title, String content) {
			MimeMessage message = mailSender.createMimeMessage();
			//true 매개값을 전달하면 multipart 형식의 메세지 전달이 가능하며 문자 인코딩 설정도 가능하다.
			try {
				MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
				helper.setFrom(setFrom);
				helper.setTo(toMail);
				helper.setSubject(title);
				//true 전달 => html 형식으로 전송, 작성하지 않으면 단순 텍스트로 전달.
				helper.setText(content,true);
				mailSender.send(message);
			} catch (Exception e) {
				log.info("~~~~~ 실패~~~~ " + e.getMessage());
				
			}

		}
}

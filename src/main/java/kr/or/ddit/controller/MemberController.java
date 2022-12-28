package kr.or.ddit.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.InvitationService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.vo.GoogleOAuthRequest;
import kr.or.ddit.vo.GoogleOAuthResponse;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	// DI(Dependency Indection : 의존성 주입)
	@Autowired
	MemberService memberService;
	@Autowired
	ProjectService projectService;
	@Autowired
	AdminService adminService;
	// 이메일 인증 빈 자동 등록
	@Autowired
	private MailSendService mailService;
	// 구글 로그인 빈 자동 등록
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;
	@Autowired
	InvitationService invitationService;
	@Inject
	ProMemService promemService;

	// 로그인 페이지로 포워딩
	// 동시에 구글code 발송
	// URI => http://localhost/member/loginMember
	@RequestMapping(value = "/login", method = { RequestMethod.GET, RequestMethod.POST })
	public String loginMember(Model model) {
		
//		//3일 지난 초대코드 자동 삭제 =>  수동으로 전환
//		this.invitationService.delInvitation();
//		//하루 지난 프로젝트 상태 신규에서 진행으로 =>  수동으로 전환
//		this.projectService.changeSTTS();
//		//종료날 지난 프로젝트 자동으로 상태 종료로 바꾸기
//		this.projectService.changeSTTSE(); =>  수동으로 전환
//
//		/* 구글code 발행 */
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);

		System.out.println("구글 : " + url);

		model.addAttribute("google_url", url);
		// forwarding
		return "login";
	}

	// 구글 Callback호출 메소드
	@RequestMapping(value = "/oauth2callback", method = { RequestMethod.GET, RequestMethod.POST })
	public String googleCallback(Model model, @RequestParam String code, HttpServletRequest request)
			throws IOException {
		System.out.println("여기는 googleCallback");

		HttpSession session = request.getSession();

		// HTTP Request를 위한 RestTemplate
		RestTemplate restTemplate = new RestTemplate();

		// Google OAuth Access Token 요청을 위한 파라미터 세팅
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId("700364105784-fgubl6198ff11i0sivk3bhgt0u6rj3uk.apps.googleusercontent.com");
		googleOAuthRequestParam.setClientSecret("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");
		googleOAuthRequestParam.setCode(code);
		googleOAuthRequestParam.setRedirectUri("http://localhost:80/oauth2callback");
		googleOAuthRequestParam.setGrantType("authorization_code");

		// JSON 파싱을 위한 기본값 세팅
		// 요청시 파라미터는 스네이크 케이스로 세팅되므로 Object mapper에 미리 설정해준다.
		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.setSerializationInclusion(Include.NON_NULL);

		// AccessToken 발급 요청
		ResponseEntity<String> resultEntity = restTemplate.postForEntity("https://oauth2.googleapis.com/token",
				googleOAuthRequestParam, String.class);

		// Token Request
		GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
		});

		// ID Token만 추출 (사용자의 정보는 jwt로 인코딩 되어있다)
		String jwtToken = result.getIdToken();
		String requestUrl = UriComponentsBuilder.fromHttpUrl("https://oauth2.googleapis.com/tokeninfo")
				.queryParam("id_token", jwtToken).toUriString();

		String resultJson = restTemplate.getForObject(requestUrl, String.class);

		Map<String, String> rst = mapper.readValue(resultJson, new TypeReference<Map<String, String>>() {
		});
		model.addAllAttributes(rst);
		model.addAttribute("token", result.getAccessToken());

		/*
		 * private String memNo; // private String memId; // private String memPw; //
		 * private String memNm; //name
		 */
		// result : {iss=https://accounts.google.com,
		// azp=700364105784-fgubl6198ff11i0sivk3bhgt0u6rj3uk.apps.googleusercontent.com,
//				aud=700364105784-fgubl6198ff11i0sivk3bhgt0u6rj3uk.apps.googleusercontent.com, sub=116745365586414853848, 
//				at_hash=cEk7Do1efGjPrOsJ0RKjyw, name=이루, 
//				picture=https://lh3.googleusercontent.com/a-/AFdZucqHutkbjLdwCOBNCYH3BrPnvbZnBbH9YKJjLR-x=s96-c, given_name=루, 
//				family_name=이, locale=ko, iat=1662338263, exp=1662341863, alg=RS256, kid=e847d9948e8545948fa8157b73e915c567302d4e, 
//				typ=JWT}\

		// 구글 로그인 회원 정보를 memberVO에 set하기
		Map<String, Object> memberVO = new HashMap<String, Object>();

		memberVO.put("memId", rst.get("email")); // test1212@test.com
		memberVO.put("memNm", rst.get("name")); // 이루
		memberVO.put("password", "0000");
		log.info("구글 로그인 회원 정보를 memberVO에 set하기 memberVO : " + memberVO);

		MemberVO vo = new MemberVO();
		vo.setMemId((String) memberVO.get("memId"));
		vo.setMemNm((String) memberVO.get("memNm"));

		// 구글 아이디 체크
		int cnt = this.memberService.dupChk(memberVO);
		log.info("cnt : " + cnt);

//				//processLogin 메소드와 동일하게 처리
//				session.setAttribute("id", rst.get("email"));
//				session.setAttribute("sessionId", memberVO);

		System.out.println("memberVO : " + memberVO.toString());
		System.out.println("result : " + rst);

		// 1 : 있다 / 0 : 없다
		if (cnt < 1) {

			// 아이디 체크에 따른 강제 가입 혹은 패스처리
			int googleInsert = this.memberService.insert2(memberVO);
			log.info("googleInsert : " + googleInsert);

			// 로그인 처리
			Map<String, Object> memSelect = this.memberService.memberLogin(memberVO);
			log.info("memSelect : " + memSelect);

			String email = "";

			email = (String) memberVO.get("memId"); // abc@abc.com
			log.info("memberVO : " + memberVO.toString());
			session.setAttribute("id", email); // 비밀번호는 vo에서 꺼내도 되니까 저장 따로 안 함
			session.setAttribute("memNo", memberVO.get("memNo"));
			vo.setMemNo((String) memberVO.get("memNo"));
			session.setAttribute("loginVO", vo);

			List<Map<String, Object>> projLogo = this.projectService.projLogo((String) memberVO.get("memNo"));

			session.setAttribute("projLogo", projLogo);

		} else {
			// 로그인 처리
			memberVO = this.memberService.googleLogin(memberVO);
			log.info("memberVO : " + memberVO);
			String email = "";
			if (memberVO != null) {
				email = (String) memberVO.get("memId"); // abc@abc.com
				log.info("memberVO : " + memberVO.toString());
				session.setAttribute("id", email); // 비밀번호는 vo에서 꺼내도 되니까 저장 따로 안 함
				session.setAttribute("memNo", memberVO.get("memNo"));
				vo.setMemNo((String) memberVO.get("memNo"));
				session.setAttribute("loginVO", vo);

//				List<Map<String, Object>> projLogo = this.projectService.projLogo((String) memberVO.get("memNo"));

//				session.setAttribute("projLogo", projLogo);
				
				List<Map<String, Object>> projOnList = this.projectService.projOnList((String)memberVO.get("memNo"));
				log.info("      projOnList : {}" , projOnList);
				session.setAttribute("projOnList", projOnList);
				
			}
		}
		return "redirect:/main/myMain";
	}

//	//카카오 로그인
//	@RequestMapping(value="/kakaoLogin", method=RequestMethod.GET)
//	public String kakaoLogin(@RequestParam(value="code", required = false) String code) {
//		//login.jsp에서 카카오 로그인 버튼 눌렀을 시 인증허가코드를 동시에 보내주고 잘 나왔는지 확인.
//		System.out.println("카카오 : " + code);
//		
//		//accessToken 추가
//		String access_Token =
//		
//		
//		return "member/login";
//	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		//3일 지난 초대코드 자동 삭제 =>  수동으로 전환
		this.invitationService.delInvitation();
		
		HttpSession session = request.getSession();

		session.invalidate();

		return "redirect:/main";
	}

	// http://localhost/member/login에서 입력한 id, password를 map으로 받음
	// 요청URI => /member/processLogin(post)
	@PostMapping("/processLogin")
	public String processLogin(@RequestParam Map<String, Object> map, HttpServletRequest request, Model model) {

		// request객체에 들어있는 session객체를 가져옴
		HttpSession session = request.getSession();

		// map : {id=a001, password=java}
		log.info("로그인 할 떄 입력한 값 map : " + map);

		if (map.get("memId").equals("admin")) {
			int result = this.adminService.adminLogin(map);
			if (result > 0) {
				map.put("memNm", "관리자");
				session.setAttribute("id", map.get("memId"));
				session.setAttribute("loginVO", map);

				return "main";
			} else {
				return "redirect:/login";
			}
		} else {

			// 로그인 처리
			Map<String, Object> memberVO = this.memberService.memberLogin(map);
			log.info("로그인 할 떄 입력한 값으로 불러온 memberVO : " + memberVO);

			// 로그인 성공 => session.setAttribute("sessionId", email)
			if (memberVO != null) {
				MemberVO vo = new MemberVO();
				vo.setMemId((String) memberVO.get("memId"));
				vo.setMemNm((String) memberVO.get("memNm"));
				vo.setMemNo((String) memberVO.get("memNo"));

				log.info("memberVO : " + memberVO.toString());
				session.setAttribute("id", memberVO.get("memId")); // abc@abc.com
				session.setAttribute("memNo", memberVO.get("memNo")); // 비밀번호는 vo에서 꺼내도 되니까 저장 따로 안 함
				session.setAttribute("loginVO", vo);

				// 현재 진행 중이고 내가 참여하는 프로젝트 중 로고 뽑아오기
//				List<Map<String, Object>> projLogo = this.projectService.projLogo((String) memberVO.get("memNo"));
//				if (projLogo != null && projLogo.size() > 0) {
//					for (int i = 0; i < projLogo.size(); i++) {
//						log.info("             현재 진행 중이고 내가 참여하는 프로젝트 중 로고 뽑아오기 projLogo" + projLogo.get(i));
//					}
//
//					session.setAttribute("projLogo", projLogo);
//				}
				
				List<Map<String, Object>> projOnList = this.projectService.projOnList((String)memberVO.get("memNo"));
				log.info("      projOnList : {}" , projOnList);
				session.setAttribute("projOnList", projOnList);

				return "redirect:/main/myMain";
			} else {
				// 로그인 실패
				// 로그인 페이지로 재요청
				return "redirect:/login";
			}

		}
	}

//	//로그인 성공
//	//요청URI => /member/(메인페이지)
//	@GetMapping("/resultMember")
//	public String resultMember(Model model) {
//		//msg : 0 => 회원정보 수정
//		//msg : 1 => 회원가입
//		//msg : 2 => 로그인성공
//		model.addAttribute("msg", 2);
//		
//		//forwarding
//		return "resultMember";
//	}

	// 회원가입창의 회원번호를 텍스트박스에 넣어두기
	// 요청 URI : /member/memberRegist
	@GetMapping("/memberRegist")
	public ModelAndView memberRegist(MemberVO memberVO) {
		memberVO.setMemNo(memberService.makeMemberNo());

		ModelAndView mav = new ModelAndView();
		// 회원의 번호를 모델에 담아서 jsp로 보냄
		mav.addObject("memNo", memberVO.getMemNo());
		mav.setViewName("memberRegist");

		// forwarding
		return mav;
	}

	// 아이디 중복 체크
	// 요청URI : /member/dupChk
	@ResponseBody
	@PostMapping("/dupChk")
	public Map<String, String> dupChk(@RequestBody Map<String, Object> memberVO) {
		log.info("memberVO : " + memberVO.toString());
		// 중복 아이디 체크
		int cnt = this.memberService.dupChk(memberVO);

		Map<String, String> map = new HashMap<String, String>();

		// 1 : 있다 / 0 : 없다
		if (cnt < 1) {
			map.put("result", "0");
		} else {
			map.put("result", "1");
		}

		return map;
	}

	// 이메일 인증 확인
//	@GetMapping("/mailCheck")
//	@ResponseBody
//	public void mailCheck(String email) {
//		log.info("이메일 인증 요청이 들어옴!");
//		log.info("이메일 인증 이메일 : " + email);
//	}

	// URI => http://localhost/member/loginMember
	@GetMapping("/mailCheck")
	@ResponseBody
	public String mailCheck(String email) {
		log.info("이메일 인증 요청이 들어옴!");
		log.info("이메일 인증 이메일 : " + email);

		// forwarding
		return mailService.joinEmail(email);
	}

	// 회원가입
	// 요청 URI => http://localhost/member/processMemberRegist
	// vo받으려면 => 골뱅이ModelAttribute
	// String 받으려면 => 골뱅이RequestParam
	// MemberVO 도메인 클래스(자바빈 클래스)에 입력값 검증을 활성화함
	// BindingResult 사용시 Model은 사용하지 않음
	@PostMapping("/memberRegistPost")
	public String processMemberRegist(@Validated MemberVO memberVO, BindingResult brResult)
			throws IllegalStateException, IOException {
		log.info("memberVO toString() : " + memberVO.toString());
		log.info("brResulthasErrors() : " + brResult.hasErrors());

		// 요청 파라미터와 도메인 클래스의 멤버변수가 바인딩(set)될 때 오류가 생겼다면
		if (brResult.hasErrors()) {
			// 검사 결과 오류 확인
			List<ObjectError> allErrors = brResult.getAllErrors();
			// 객체와 관련된 오류
			List<ObjectError> globalErrors = brResult.getGlobalErrors();
			// 멤버변수와 관련된 오류
			List<FieldError> fieldErrors = brResult.getFieldErrors();

			for (ObjectError objectError : allErrors) {
				log.info("allError : " + objectError);
			}

			for (ObjectError objectError : globalErrors) { 
				log.info("globalError : " + objectError);
			}

			for (FieldError fieldError : fieldErrors) {
				log.info("fieldError : " + fieldError.getDefaultMessage());
			}
			// forwarding
			return "memberRegist";
		}

		// 회원 insert
		int result = this.memberService.insert(memberVO);

		if (result > 0) {
			// 가입성공
			// redirect 처리
			// msg : 0 => 회원정보 수정
			// msg : 1 => 회원가입
			// msg : 2 => 로그인성공
			
			if(memberVO.getInviCd() != null) {
				//INV_NO, INV_EMAIL, INV_CD, PROJ_ID, PMEM_GRP, INV_DAY
				//일치하는 초대코드의 프로젝트 아이디와 그룹 셀렉트한 후 그 값으로 프로멤과 프로필 삽입
				ProMemVO pvo = this.invitationService.inviCdJoining(memberVO.getInviCd());
				if(pvo != null) {
					pvo.setMemNo(memberVO.getMemNo());
					this.promemService.inviJoining(pvo);
				}
			}

			return "login";
		} else {
			// 가입 실패 => 회원가입페이지를 재요청
			return "memberRegist";
		}
	}

	// 마이페이지(내정보 리스트, 멀티프로필,
	// 요청 URI
	public String memList() {
		return "";
	}

	// 전체 맴버 검색
	@ResponseBody
	@GetMapping("/searchMem")
	public List<Map<String, Object>> searchMem(@RequestParam String content, MemberVO memberVO, HttpServletRequest request) {
		HttpSession session = request.getSession();
		memberVO.setProjId((int)session.getAttribute("projId"));
		memberVO.setContent(content);
		log.info("         memberVO : {} ", memberVO);
		
		List<Map<String, Object>> list = memberService.searchMem(memberVO);
		return list;
	}

	
	
	// 비밀번호 찾기 - 임시 비밀번호 발급
	@GetMapping("/pwFind")
	public String pwFind(MemberVO memberVO) {
		// forwarding
		return "pwFind";
	}
	
	// 아이디 여부 체크
	@ResponseBody
	@PostMapping("/idCheck")
	public Map<String, String> idCheck(@RequestBody MemberVO memberVO) {
		log.info("memberVO : " + memberVO.toString());
		// 중복 아이디 체크
		memberVO = this.memberService.idCheck(memberVO);

		Map<String, String> map = new HashMap<String, String>();

		// 1 : 일치 / 0 : 불일치
		if (memberVO.getCnt() < 1) {
			map.put("result", "0");
		} else {
			map.put("result", "1");
		}

		return map;
	}

	
	// 이메일 인증 확인
	@GetMapping("/checkMail")
	@ResponseBody
	public String checkMail(String email) {
		log.info("이메일 인증 요청이 들어옴!");
		log.info("이메일 인증 이메일 : " + email);

		// forwarding
		return mailService.passEmail(email);
	}
	
	@PostMapping("/pwFindPost")
	public String pwFindPost( MemberVO memberVO){
		log.info("memberVO : " + memberVO.toString());

		// 비밀번호 업데이트 시
		int result = this.memberService.findPw(memberVO);
		log.info("result : " + result);

		return "pwFind";
	}
	
	//임시비밀번호 저장
	@PostMapping("/findPw")
	public String findPw(MemberVO memberVO){
		log.info("memberVO : " + memberVO.toString());

		// 비밀번호 업데이트 시
		int result = this.memberService.findPw(memberVO);
		log.info("result : " + result);

		return("pwEmail");
	}

	// 임시 비밀번호 전송 완료
	@GetMapping("/pwEmail")
	public String pwEmail() {
		return "pwEmail";
	}
	
	
	
	///////////////////////////////////////////////////// 초대장
	@ResponseBody
	@RequestMapping("/ifMem")
	public MemberVO ifMem (@RequestBody MemberVO mvo) {
		log.info("     ifMem 확인하려면 email 있어야함 : " + mvo);
		MemberVO resultVO = this.memberService.ifMem(mvo);
		log.info("     ifMem 확인한 결과 vo : " + resultVO);
		
		if(resultVO == null) {
			resultVO = new MemberVO();
			resultVO.setCnt(1);
		}
		return resultVO;
	}
}

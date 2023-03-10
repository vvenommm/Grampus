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
	// DI(Dependency Indection : ????????? ??????)
	@Autowired
	MemberService memberService;
	@Autowired
	ProjectService projectService;
	@Autowired
	AdminService adminService;
	// ????????? ?????? ??? ?????? ??????
	@Autowired
	private MailSendService mailService;
	// ?????? ????????? ??? ?????? ??????
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;
	@Autowired
	InvitationService invitationService;
	@Inject
	ProMemService promemService;

	// ????????? ???????????? ?????????
	// ????????? ??????code ??????
	// URI => http://localhost/member/loginMember
	@RequestMapping(value = "/login", method = { RequestMethod.GET, RequestMethod.POST })
	public String loginMember(Model model) {
		
//		//3??? ?????? ???????????? ?????? ?????? =>  ???????????? ??????
//		this.invitationService.delInvitation();
//		//?????? ?????? ???????????? ?????? ???????????? ???????????? =>  ???????????? ??????
//		this.projectService.changeSTTS();
//		//????????? ?????? ???????????? ???????????? ?????? ????????? ?????????
//		this.projectService.changeSTTSE(); =>  ???????????? ??????
//
//		/* ??????code ?????? */
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);

		System.out.println("?????? : " + url);

		model.addAttribute("google_url", url);
		// forwarding
		return "login";
	}

	// ?????? Callback?????? ?????????
	@RequestMapping(value = "/oauth2callback", method = { RequestMethod.GET, RequestMethod.POST })
	public String googleCallback(Model model, @RequestParam String code, HttpServletRequest request)
			throws IOException {
		System.out.println("????????? googleCallback");

		HttpSession session = request.getSession();

		// HTTP Request??? ?????? RestTemplate
		RestTemplate restTemplate = new RestTemplate();

		// Google OAuth Access Token ????????? ?????? ???????????? ??????
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId("700364105784-fgubl6198ff11i0sivk3bhgt0u6rj3uk.apps.googleusercontent.com");
		googleOAuthRequestParam.setClientSecret("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");
		googleOAuthRequestParam.setCode(code);
		googleOAuthRequestParam.setRedirectUri("http://localhost:80/oauth2callback");
		googleOAuthRequestParam.setGrantType("authorization_code");

		// JSON ????????? ?????? ????????? ??????
		// ????????? ??????????????? ???????????? ???????????? ??????????????? Object mapper??? ?????? ???????????????.
		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.setSerializationInclusion(Include.NON_NULL);

		// AccessToken ?????? ??????
		ResponseEntity<String> resultEntity = restTemplate.postForEntity("https://oauth2.googleapis.com/token",
				googleOAuthRequestParam, String.class);

		// Token Request
		GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
		});

		// ID Token??? ?????? (???????????? ????????? jwt??? ????????? ????????????)
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
//				at_hash=cEk7Do1efGjPrOsJ0RKjyw, name=??????, 
//				picture=https://lh3.googleusercontent.com/a-/AFdZucqHutkbjLdwCOBNCYH3BrPnvbZnBbH9YKJjLR-x=s96-c, given_name=???, 
//				family_name=???, locale=ko, iat=1662338263, exp=1662341863, alg=RS256, kid=e847d9948e8545948fa8157b73e915c567302d4e, 
//				typ=JWT}\

		// ?????? ????????? ?????? ????????? memberVO??? set??????
		Map<String, Object> memberVO = new HashMap<String, Object>();

		memberVO.put("memId", rst.get("email")); // test1212@test.com
		memberVO.put("memNm", rst.get("name")); // ??????
		memberVO.put("password", "0000");
		log.info("?????? ????????? ?????? ????????? memberVO??? set?????? memberVO : " + memberVO);

		MemberVO vo = new MemberVO();
		vo.setMemId((String) memberVO.get("memId"));
		vo.setMemNm((String) memberVO.get("memNm"));

		// ?????? ????????? ??????
		int cnt = this.memberService.dupChk(memberVO);
		log.info("cnt : " + cnt);

//				//processLogin ???????????? ???????????? ??????
//				session.setAttribute("id", rst.get("email"));
//				session.setAttribute("sessionId", memberVO);

		System.out.println("memberVO : " + memberVO.toString());
		System.out.println("result : " + rst);

		// 1 : ?????? / 0 : ??????
		if (cnt < 1) {

			// ????????? ????????? ?????? ?????? ?????? ?????? ????????????
			int googleInsert = this.memberService.insert2(memberVO);
			log.info("googleInsert : " + googleInsert);

			// ????????? ??????
			Map<String, Object> memSelect = this.memberService.memberLogin(memberVO);
			log.info("memSelect : " + memSelect);

			String email = "";

			email = (String) memberVO.get("memId"); // abc@abc.com
			log.info("memberVO : " + memberVO.toString());
			session.setAttribute("id", email); // ??????????????? vo?????? ????????? ????????? ?????? ?????? ??? ???
			session.setAttribute("memNo", memberVO.get("memNo"));
			vo.setMemNo((String) memberVO.get("memNo"));
			session.setAttribute("loginVO", vo);

			List<Map<String, Object>> projLogo = this.projectService.projLogo((String) memberVO.get("memNo"));

			session.setAttribute("projLogo", projLogo);

		} else {
			// ????????? ??????
			memberVO = this.memberService.googleLogin(memberVO);
			log.info("memberVO : " + memberVO);
			String email = "";
			if (memberVO != null) {
				email = (String) memberVO.get("memId"); // abc@abc.com
				log.info("memberVO : " + memberVO.toString());
				session.setAttribute("id", email); // ??????????????? vo?????? ????????? ????????? ?????? ?????? ??? ???
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

//	//????????? ?????????
//	@RequestMapping(value="/kakaoLogin", method=RequestMethod.GET)
//	public String kakaoLogin(@RequestParam(value="code", required = false) String code) {
//		//login.jsp?????? ????????? ????????? ?????? ????????? ??? ????????????????????? ????????? ???????????? ??? ???????????? ??????.
//		System.out.println("????????? : " + code);
//		
//		//accessToken ??????
//		String access_Token =
//		
//		
//		return "member/login";
//	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		//3??? ?????? ???????????? ?????? ?????? =>  ???????????? ??????
		this.invitationService.delInvitation();
		
		HttpSession session = request.getSession();

		session.invalidate();

		return "redirect:/main";
	}

	// http://localhost/member/login?????? ????????? id, password??? map?????? ??????
	// ??????URI => /member/processLogin(post)
	@PostMapping("/processLogin")
	public String processLogin(@RequestParam Map<String, Object> map, HttpServletRequest request, Model model) {

		// request????????? ???????????? session????????? ?????????
		HttpSession session = request.getSession();

		// map : {id=a001, password=java}
		log.info("????????? ??? ??? ????????? ??? map : " + map);

		if (map.get("memId").equals("admin")) {
			int result = this.adminService.adminLogin(map);
			if (result > 0) {
				map.put("memNm", "?????????");
				session.setAttribute("id", map.get("memId"));
				session.setAttribute("loginVO", map);

				return "main";
			} else {
				return "redirect:/login";
			}
		} else {

			// ????????? ??????
			Map<String, Object> memberVO = this.memberService.memberLogin(map);
			log.info("????????? ??? ??? ????????? ????????? ????????? memberVO : " + memberVO);

			// ????????? ?????? => session.setAttribute("sessionId", email)
			if (memberVO != null) {
				MemberVO vo = new MemberVO();
				vo.setMemId((String) memberVO.get("memId"));
				vo.setMemNm((String) memberVO.get("memNm"));
				vo.setMemNo((String) memberVO.get("memNo"));

				log.info("memberVO : " + memberVO.toString());
				session.setAttribute("id", memberVO.get("memId")); // abc@abc.com
				session.setAttribute("memNo", memberVO.get("memNo")); // ??????????????? vo?????? ????????? ????????? ?????? ?????? ??? ???
				session.setAttribute("loginVO", vo);

				// ?????? ?????? ????????? ?????? ???????????? ???????????? ??? ?????? ????????????
//				List<Map<String, Object>> projLogo = this.projectService.projLogo((String) memberVO.get("memNo"));
//				if (projLogo != null && projLogo.size() > 0) {
//					for (int i = 0; i < projLogo.size(); i++) {
//						log.info("             ?????? ?????? ????????? ?????? ???????????? ???????????? ??? ?????? ???????????? projLogo" + projLogo.get(i));
//					}
//
//					session.setAttribute("projLogo", projLogo);
//				}
				
				List<Map<String, Object>> projOnList = this.projectService.projOnList((String)memberVO.get("memNo"));
				log.info("      projOnList : {}" , projOnList);
				session.setAttribute("projOnList", projOnList);

				return "redirect:/main/myMain";
			} else {
				// ????????? ??????
				// ????????? ???????????? ?????????
				return "redirect:/login";
			}

		}
	}

//	//????????? ??????
//	//??????URI => /member/(???????????????)
//	@GetMapping("/resultMember")
//	public String resultMember(Model model) {
//		//msg : 0 => ???????????? ??????
//		//msg : 1 => ????????????
//		//msg : 2 => ???????????????
//		model.addAttribute("msg", 2);
//		
//		//forwarding
//		return "resultMember";
//	}

	// ?????????????????? ??????????????? ?????????????????? ????????????
	// ?????? URI : /member/memberRegist
	@GetMapping("/memberRegist")
	public ModelAndView memberRegist(MemberVO memberVO) {
		memberVO.setMemNo(memberService.makeMemberNo());

		ModelAndView mav = new ModelAndView();
		// ????????? ????????? ????????? ????????? jsp??? ??????
		mav.addObject("memNo", memberVO.getMemNo());
		mav.setViewName("memberRegist");

		// forwarding
		return mav;
	}

	// ????????? ?????? ??????
	// ??????URI : /member/dupChk
	@ResponseBody
	@PostMapping("/dupChk")
	public Map<String, String> dupChk(@RequestBody Map<String, Object> memberVO) {
		log.info("memberVO : " + memberVO.toString());
		// ?????? ????????? ??????
		int cnt = this.memberService.dupChk(memberVO);

		Map<String, String> map = new HashMap<String, String>();

		// 1 : ?????? / 0 : ??????
		if (cnt < 1) {
			map.put("result", "0");
		} else {
			map.put("result", "1");
		}

		return map;
	}

	// ????????? ?????? ??????
//	@GetMapping("/mailCheck")
//	@ResponseBody
//	public void mailCheck(String email) {
//		log.info("????????? ?????? ????????? ?????????!");
//		log.info("????????? ?????? ????????? : " + email);
//	}

	// URI => http://localhost/member/loginMember
	@GetMapping("/mailCheck")
	@ResponseBody
	public String mailCheck(String email) {
		log.info("????????? ?????? ????????? ?????????!");
		log.info("????????? ?????? ????????? : " + email);

		// forwarding
		return mailService.joinEmail(email);
	}

	// ????????????
	// ?????? URI => http://localhost/member/processMemberRegist
	// vo???????????? => ?????????ModelAttribute
	// String ???????????? => ?????????RequestParam
	// MemberVO ????????? ?????????(????????? ?????????)??? ????????? ????????? ????????????
	// BindingResult ????????? Model??? ???????????? ??????
	@PostMapping("/memberRegistPost")
	public String processMemberRegist(@Validated MemberVO memberVO, BindingResult brResult)
			throws IllegalStateException, IOException {
		log.info("memberVO toString() : " + memberVO.toString());
		log.info("brResulthasErrors() : " + brResult.hasErrors());

		// ?????? ??????????????? ????????? ???????????? ??????????????? ?????????(set)??? ??? ????????? ????????????
		if (brResult.hasErrors()) {
			// ?????? ?????? ?????? ??????
			List<ObjectError> allErrors = brResult.getAllErrors();
			// ????????? ????????? ??????
			List<ObjectError> globalErrors = brResult.getGlobalErrors();
			// ??????????????? ????????? ??????
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

		// ?????? insert
		int result = this.memberService.insert(memberVO);

		if (result > 0) {
			// ????????????
			// redirect ??????
			// msg : 0 => ???????????? ??????
			// msg : 1 => ????????????
			// msg : 2 => ???????????????
			
			if(memberVO.getInviCd() != null) {
				//INV_NO, INV_EMAIL, INV_CD, PROJ_ID, PMEM_GRP, INV_DAY
				//???????????? ??????????????? ???????????? ???????????? ?????? ???????????? ??? ??? ????????? ???????????? ????????? ??????
				ProMemVO pvo = this.invitationService.inviCdJoining(memberVO.getInviCd());
				if(pvo != null) {
					pvo.setMemNo(memberVO.getMemNo());
					this.promemService.inviJoining(pvo);
				}
			}

			return "login";
		} else {
			// ?????? ?????? => ???????????????????????? ?????????
			return "memberRegist";
		}
	}

	// ???????????????(????????? ?????????, ???????????????,
	// ?????? URI
	public String memList() {
		return "";
	}

	// ?????? ?????? ??????
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

	
	
	// ???????????? ?????? - ?????? ???????????? ??????
	@GetMapping("/pwFind")
	public String pwFind(MemberVO memberVO) {
		// forwarding
		return "pwFind";
	}
	
	// ????????? ?????? ??????
	@ResponseBody
	@PostMapping("/idCheck")
	public Map<String, String> idCheck(@RequestBody MemberVO memberVO) {
		log.info("memberVO : " + memberVO.toString());
		// ?????? ????????? ??????
		memberVO = this.memberService.idCheck(memberVO);

		Map<String, String> map = new HashMap<String, String>();

		// 1 : ?????? / 0 : ?????????
		if (memberVO.getCnt() < 1) {
			map.put("result", "0");
		} else {
			map.put("result", "1");
		}

		return map;
	}

	
	// ????????? ?????? ??????
	@GetMapping("/checkMail")
	@ResponseBody
	public String checkMail(String email) {
		log.info("????????? ?????? ????????? ?????????!");
		log.info("????????? ?????? ????????? : " + email);

		// forwarding
		return mailService.passEmail(email);
	}
	
	@PostMapping("/pwFindPost")
	public String pwFindPost( MemberVO memberVO){
		log.info("memberVO : " + memberVO.toString());

		// ???????????? ???????????? ???
		int result = this.memberService.findPw(memberVO);
		log.info("result : " + result);

		return "pwFind";
	}
	
	//?????????????????? ??????
	@PostMapping("/findPw")
	public String findPw(MemberVO memberVO){
		log.info("memberVO : " + memberVO.toString());

		// ???????????? ???????????? ???
		int result = this.memberService.findPw(memberVO);
		log.info("result : " + result);

		return("pwEmail");
	}

	// ?????? ???????????? ?????? ??????
	@GetMapping("/pwEmail")
	public String pwEmail() {
		return "pwEmail";
	}
	
	
	
	///////////////////////////////////////////////////// ?????????
	@ResponseBody
	@RequestMapping("/ifMem")
	public MemberVO ifMem (@RequestBody MemberVO mvo) {
		log.info("     ifMem ??????????????? email ???????????? : " + mvo);
		MemberVO resultVO = this.memberService.ifMem(mvo);
		log.info("     ifMem ????????? ?????? vo : " + resultVO);
		
		if(resultVO == null) {
			resultVO = new MemberVO();
			resultVO.setCnt(1);
		}
		return resultVO;
	}
}

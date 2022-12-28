package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ResumeVO;

public interface MemberService {

	public MemberVO memDetail(String memNo);

	public int memUpdate(MemberVO memberVO);
	
	//로그인
	public Map<String, Object> memberLogin(Map<String, Object> map);
	
	//구글로그인
	public Map<String, Object> googleLogin(Map<String, Object> map);
	
	//구글 로그인 강제 가입
	public int insert2(Map<String, Object> memberVO);
	
	//회원 번호 생성
	public String makeMemberNo();
	
	//중복 아이디 체크
	public int dupChk(Map<String, Object> memberVO);
	
	//회원가입
	public int insert(MemberVO memberVO);

	//회원 사진 변경
	public int memPhotoUpdate(ResumeVO resumeVO);
	
	//전체 맴버 검색
	public List<Map<String, Object>> searchMem(MemberVO memberVO);
	
	//초대장 보낼 때 회원한테 보내는 것인지 구분
	public MemberVO ifMem(MemberVO mvo);
	
	//아이디 여부 체크
	public MemberVO idCheck(MemberVO memberVO);
	
	//임시 비밀번호 발급
	public int findPw(MemberVO memberVO);
	
}

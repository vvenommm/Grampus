package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MemberMapper;
import kr.or.ddit.service.AdminService;
import kr.or.ddit.service.MemberService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ResumeVO;

@Service
public class MemberServiceImpl implements MemberService{
	
	@Inject
	private MemberMapper memMapper;
	@Autowired
	MemberMapper memberMapper;

	//마이페이지 조회
	@Override
	public MemberVO memDetail(String memNo) {
		return this.memMapper.memDetail(memNo);
	}
	
	//비밀번호 아이디 수정
	@Override
	public int memUpdate(MemberVO memberVO) {
		return this.memMapper.memUpdate(memberVO);
	}
	
	//로그인
	@Override
	public Map<String, Object> memberLogin(Map<String, Object> map) {
		return this.memberMapper.memberLogin(map);
	}
	
	//구글 로그인
	@Override
	public Map<String, Object> googleLogin(Map<String, Object> map) {
		return this.memberMapper.googleLogin(map);
	}
	
	//회원 번호 생성
	@Override
	public String makeMemberNo() {
		return this.memberMapper.makeMemberNo();
	}
	
	//중복 아이디 체크
	@Override
	public int dupChk(Map<String, Object> memberVO) {
		return this.memberMapper.dupChk(memberVO);
	}
	
	//회원가입
	@Override
	public int insert(MemberVO memberVO) {
		return this.memberMapper.insert(memberVO);
	}
	
	//구글 로그인 강제 가입
	@Override
	public int insert2(Map<String, Object> memberVO) {
		return this.memberMapper.insert2(memberVO);
	}
	//회원사진 변경
	@Override
	public int memPhotoUpdate(ResumeVO resumeVO) {
		return this.memberMapper.memPhotoUpdate(resumeVO);
	}
	
	//전체 맴버 검색
	@Override
	public List<Map<String, Object>> searchMem(MemberVO memberVO){
		return this.memberMapper.searchMem(memberVO);
	}
	
	//초대장 보낼 때 회원한테 보내는 것인지 구분
	@Override
	public MemberVO ifMem(MemberVO mvo) {
		return this.memberMapper.ifMem(mvo);
	}
	
	//아이디 여부 체크
	public MemberVO idCheck(MemberVO memberVO) {
		return this.memberMapper.idCheck(memberVO);
	}
	
	//임시 비밀번호 발급
	public int findPw(MemberVO memberVO) {
		return this.memMapper.findPw(memberVO);
	}

}

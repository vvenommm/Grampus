package kr.or.ddit.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.AdminMapper;
import kr.or.ddit.service.AdminService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminServiceImpl implements AdminService{

	@Autowired
	AdminMapper adminMapper;
	
	//관리자가 로그인
	public int adminLogin(Map<String, Object> map){
		log.info("관리자 로그인 구분하려고 넘긴 map 값 : " + map);
		
		Map<String, Object> adminMap = this.adminMapper.adminLogin();
		log.info("관리자 로그인 구분하려고 가져온 값 : " + adminMap);
		int result = 0;
		if(adminMap.get("ID").equals(map.get("memId")) && adminMap.get("PW").equals(map.get("password"))){
			result = 1;
		}
		return result;
	}
}
 
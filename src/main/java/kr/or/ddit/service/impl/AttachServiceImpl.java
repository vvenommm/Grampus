package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.AttachMapper;
import kr.or.ddit.service.AttachService;
import kr.or.ddit.vo.AttachVO;
import kr.or.ddit.vo.ReplyVO;

@Service
public class AttachServiceImpl implements AttachService{
	@Inject
	AttachMapper attachMapper;
	
	//첨부파일 삽입하기
	@Override
	public int attachInsert(AttachVO attachVO) {
		return this.attachMapper.attachInsert(attachVO);
	}
	
	//첨부파일 리스트
	@Override
	public List<AttachVO> attachList(AttachVO attachVO){
		return this.attachMapper.attachList(attachVO);
	}
	
	//첨부파일 삭제하기
	@Override
	public int attachDelete(int battNo) {
		return this.attachMapper.attachDelete(battNo);
	}

}

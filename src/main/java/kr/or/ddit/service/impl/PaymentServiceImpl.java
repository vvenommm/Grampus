package kr.or.ddit.service.impl;

import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.PaymentMapper;
import kr.or.ddit.service.PaymentService;
import kr.or.ddit.vo.PaymentVO;

@Service
public class PaymentServiceImpl implements PaymentService{

	@Inject
	PaymentMapper paymentMapper;
	
	//1. 결제
	public int pay(PaymentVO paymentVO) {
		
		return this.paymentMapper.pay(paymentVO);
	}
	
	//프로젝트별 결제 내역
	@Override
	public PaymentVO paymentHistory(int projId) {
		return this.paymentMapper.paymentHistory(projId);
	}

	//플랜 수정
	@Override
	public int planUpdate(PaymentVO paymentVO) {
		return this.paymentMapper.planUpdate(paymentVO);
	}
}

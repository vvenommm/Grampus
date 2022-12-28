package kr.or.ddit.mapper;

import java.util.Map;

import kr.or.ddit.vo.PaymentVO;

public interface PaymentMapper {

	//1. 결제
	public int pay(PaymentVO paymentVO);

	//프로젝트별 결제 내역
	public PaymentVO paymentHistory(int projId);
	
	//플랜 수정
	public int planUpdate(PaymentVO paymentVO);
}

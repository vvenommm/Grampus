package kr.or.ddit.service;

import java.util.Map;

import kr.or.ddit.vo.PaymentVO;

public interface PaymentService {
	
	//1. 결제
	public int pay(PaymentVO paymentVO);

	public PaymentVO paymentHistory(int projId);

	public int planUpdate(PaymentVO paymentVO);

	
}

package kr.or.ddit.vo;

public class FAQVO {

	private String faqNo;
	private String faqTtl;
	private String faqCn;
	public String getFaqNo() {
		return faqNo;
	}
	public void setFaqNo(String faqNo) {
		this.faqNo = faqNo;
	}
	public String getFaqTtl() {
		return faqTtl;
	}
	public void setFaqTtl(String faqTtl) {
		this.faqTtl = faqTtl;
	}
	public String getFaqCn() {
		return faqCn;
	}
	public void setFaqCn(String faqCn) {
		this.faqCn = faqCn;
	}
	@Override
	public String toString() {
		return "FAQVO [faqNo=" + faqNo + ", faqTtl=" + faqTtl + ", faqCn=" + faqCn + "]";
	}
	
}

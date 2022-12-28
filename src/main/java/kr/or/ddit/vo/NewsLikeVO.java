package kr.or.ddit.vo;

public class NewsLikeVO {

	private int newsNo;
	private String memNo;
	private int nlLike;
	
	public int getNewsNo() {
		return newsNo;
	}
	public void setNewsNo(int newsNo) {
		this.newsNo = newsNo;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public int getNlLike() {
		return nlLike;
	}
	public void setNlLike(int nlLike) {
		this.nlLike = nlLike;
	}
	
	@Override
	public String toString() {
		return "NewsLikeVO [newsNo=" + newsNo + ", memNo=" + memNo + ", nlLike=" + nlLike + "]";
	}
	
}

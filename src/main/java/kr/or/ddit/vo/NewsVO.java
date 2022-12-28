package kr.or.ddit.vo;

import java.util.Arrays;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class NewsVO {
	
	private int rnum;
	private int newsNo;
	private String newsTtl;
	private String newsCn;
	private String newsPhoto;
	private Date newsDy;
	//뉴스 좋아요 누적 숫자 표시
	private int newsLc;
	private int hit;
	private int memLike;
	
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getNewsNo() {
		return newsNo;
	}
	public void setNewsNo(int newsNo) {
		this.newsNo = newsNo;
	}
	public String getNewsTtl() {
		return newsTtl;
	}
	public void setNewsTtl(String newsTtl) {
		this.newsTtl = newsTtl;
	}
	public String getNewsCn() {
		return newsCn;
	}
	public void setNewsCn(String newsCn) {
		this.newsCn = newsCn;
	}
	public String getNewsPhoto() {
		return newsPhoto;
	}
	public void setNewsPhoto(String newsPhoto) {
		this.newsPhoto = newsPhoto;
	}
	public Date getNewsDy() {
		return newsDy;
	}
	public void setNewsDy(Date newsDy) {
		this.newsDy = newsDy;
	}
	public int getNewsLc() {
		return newsLc;
	}
	public void setNewsLc(int newsLc) {
		this.newsLc = newsLc;
	}
	
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public int getMemLike() {
		return memLike;
	}
	public void setMemLike(int memLike) {
		this.memLike = memLike;
	}
	@Override
	public String toString() {
		return "NewsVO [rnum=" + rnum + ", newsNo=" + newsNo + ", newsTtl=" + newsTtl + ", newsCn=" + newsCn
				+ ", newsPhoto=" + newsPhoto + ", newsDy=" + newsDy + ", newsLc=" + newsLc + ", hit=" + hit
				+ ", memLike=" + memLike + "]";
	}
	
	
	
	
	
	
}
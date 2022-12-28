package kr.or.ddit.vo;

import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

public class ProfileVO{

	private String memNo;
	private int projId;
	private String profNm;
	private String profPhoto;
	private String projTtl;
	private String payNo;
	private String planTtl;
	private int cnt;
	private String roleId;
	private String roleNm;
	private String pmemGrp;
	private String memId;
	
	private MultipartFile[] profImg;	
	
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getPlanTtl() {
		return planTtl;
	}
	public void setPlanTtl(String planTtl) {
		this.planTtl = planTtl;
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getPayNo() {
		return payNo;
	}
	public void setPayNo(String payNo) {
		this.payNo = payNo;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public String getProfPhoto() {
		return profPhoto;
	}
	public void setProfPhoto(String profPhoto) {
		this.profPhoto = profPhoto;
	}

	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public MultipartFile[] getProfImg() {
		return profImg;
	}
	public void setProfImg(MultipartFile[] profImg) {
		this.profImg = profImg;
	}
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	@Override
	public String toString() {
		return "ProfileVO [memNo=" + memNo + ", projId=" + projId + ", profNm=" + profNm + ", profPhoto=" + profPhoto
				+ ", projTtl=" + projTtl + ", payNo=" + payNo + ", planTtl=" + planTtl + ", cnt=" + cnt + ", roleId="
				+ roleId + ", roleNm=" + roleNm + ", pmemGrp=" + pmemGrp + ", memId=" + memId + ", profImg="
				+ Arrays.toString(profImg) + "]";
	}

}

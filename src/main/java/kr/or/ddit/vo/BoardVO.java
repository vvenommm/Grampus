package kr.or.ddit.vo;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class BoardVO{

	private String brdNo;
	private int pmemCd;
	private String brdHead;
	private String brdTtl;
	private String brdCn;
	private Date brdDy;
	private int brdInq;
	private MultipartFile[] uploadFile;
	private int rownum;

	//필요한 컬럼 추가
	private String rplCn;
	private String profNm;
	private int projId;
	private String memId;
	private String pmemGrp;
	private String memNo;
	private String projTtl;
	private String planTtl;
	
	
	//페이징에 필요한 값
	private int currentPage;
	private int show;
	private int rnum;
	
	public String getBrdNo() {
		return brdNo;
	}
	public void setBrdNo(String brdNo) {
		this.brdNo = brdNo;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public String getBrdHead() {
		return brdHead;
	}
	public void setBrdHead(String brdHead) {
		this.brdHead = brdHead;
	}
	public String getBrdTtl() {
		return brdTtl;
	}
	public void setBrdTtl(String brdTtl) {
		this.brdTtl = brdTtl;
	}
	public String getBrdCn() {
		return brdCn;
	}
	public void setBrdCn(String brdCn) {
		this.brdCn = brdCn;
	}
	public Date getBrdDy() {
		return brdDy;
	}
	public void setBrdDy(Date brdDy) {
		this.brdDy = brdDy;
	}
	public int getBrdInq() {
		return brdInq;
	}
	public void setBrdInq(int brdInq) {
		this.brdInq = brdInq;
	}
	
	//필요한 컬럼 추가
	public String getRplCn() {
		return rplCn;
	}
	public void setRplCn(String rplCn) {
		this.rplCn = rplCn;
	}
	public String getProfNm() {
		return profNm;
	}
	public void setProfNm(String profNm) {
		this.profNm = profNm;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}	
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	public MultipartFile[] getUploadFile() {
		return uploadFile;
	}
	public void setUploadFile(MultipartFile[] uploadFile) {
		this.uploadFile = uploadFile;
	}
	public String getPmemGrp() {
		return pmemGrp;
	}
	public void setPmemGrp(String pmemGrp) {
		this.pmemGrp = pmemGrp;
	}
	public String getMemNo() {
		return memNo;
	}
	public void setMemNo(String memNo) {
		this.memNo = memNo;
	}
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public String getProjTtl() {
		return projTtl;
	}
	public void setProjTtl(String projTtl) {
		this.projTtl = projTtl;
	}
	public String getPlanTtl() {
		return planTtl;
	}
	public void setPlanTtl(String planTtl) {
		this.planTtl = planTtl;
	}
	
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getShow() {
		return show;
	}
	public void setShow(int show) {
		this.show = show;
	}
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	@Override
	public String toString() {
		return "BoardVO [brdNo=" + brdNo + ", pmemCd=" + pmemCd + ", brdHead=" + brdHead + ", brdTtl=" + brdTtl
				+ ", brdCn=" + brdCn + ", brdDy=" + brdDy + ", brdInq=" + brdInq + ", uploadFile="
				+ Arrays.toString(uploadFile) + ", rownum=" + rownum + ", rplCn=" + rplCn + ", profNm=" + profNm
				+ ", projId=" + projId + ", memId=" + memId + ", pmemGrp=" + pmemGrp + ", memNo=" + memNo + ", projTtl="
				+ projTtl + ", planTtl=" + planTtl + ", currentPage=" + currentPage + ", show=" + show + ", rnum="
				+ rnum + "]";
	}
	
}

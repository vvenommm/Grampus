package kr.or.ddit.vo;

import java.util.Arrays;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class DocumentVO {

	private int docNo;
	private int projId;
	private String docType;
	private String docTtl;
	private String docCn;
	private Date docDy;
	private String docDate;
	private MultipartFile[] docFile;
	
	public String getDocDate() {
		return docDate;
	}
	public void setDocDate(String docDate) {
		this.docDate = docDate;
	}

	private int pmemCd;
	
	public int getDocNo() {
		return docNo;
	}
	public void setDocNo(int docNo) {
		this.docNo = docNo;
	}
	public int getProjId() {
		return projId;
	}
	public void setProjId(int projId) {
		this.projId = projId;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getDocTtl() {
		return docTtl;
	}
	public void setDocTtl(String docTtl) {
		this.docTtl = docTtl;
	}
	public String getDocCn() {
		return docCn;
	}
	public void setDocCn(String docCn) {
		this.docCn = docCn;
	}
	public Date getDocDy() {
		return docDy;
	}
	public void setDocDy(Date docDy) {
		this.docDy = docDy;
	}
	public int getPmemCd() {
		return pmemCd;
	}
	public void setPmemCd(int pmemCd) {
		this.pmemCd = pmemCd;
	}
	public MultipartFile[] getDocFile() {
		return docFile;
	}
	public void setUploadFile(MultipartFile[] docFile) {
		this.docFile = docFile;
	}
	
	@Override
	public String toString() {
		return "DocumentVO [docNo=" + docNo + ", projId=" + projId + ", docType=" + docType + ", docTtl=" + docTtl
				+ ", docCn=" + docCn + ", docDy=" + docDy + ", docDate=" + docDate + ", docFile="
				+ Arrays.toString(docFile) + ", pmemCd=" + pmemCd + "]";
	}
	
	
}

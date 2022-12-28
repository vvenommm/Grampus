package kr.or.ddit.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;import com.sun.mail.handlers.multipart_mixed;

import kr.or.ddit.service.DocFileService;
import kr.or.ddit.service.DocumentService;
import kr.or.ddit.service.ProMemService;
import kr.or.ddit.service.ProjectService;
import kr.or.ddit.vo.DocFileVO;
import kr.or.ddit.vo.DocumentVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.ProMemVO;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Slf4j
@RequestMapping("/doc")
@Controller
public class DocumentController {

	@Autowired
	DocumentService docService;
	
	@Autowired
	DocFileService docfService;
	
	@Autowired
	ProMemService promemService;
	
	@Autowired
	ProjectService projectService;
	
	//0. 문서 메인(해당 프로젝트의 문서 리스트)
	@RequestMapping("/docMain/{projId}/{grp}")
	public ModelAndView docList(@PathVariable("projId") int projId, @PathVariable("grp") String grp, ModelAndView mav, HttpServletRequest request) {
		
		log.info("             doc/main/projId : " + projId);
		log.info("             doc/main/grp : " + grp);
		ProMemVO vo = new ProMemVO();
		vo.setProjId(projId);
		vo.setPmemGrp(grp);
		
		HttpSession session = request.getSession();
		session.setAttribute("projId", projId);
		session.setAttribute("grp", grp);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", projId);
		map.put("grp", grp);
		
		if((String)session.getAttribute("id") != "admin") {
			MemberVO mvo = (MemberVO) session.getAttribute("loginVO");
			vo.setMemNo(mvo.getMemNo());
//			map.put("memNo", mvo.getMemNo());
		}
		log.info("             doc/main의 map : " + map);

		ProMemVO pvo = this.promemService.pmem(vo);
		log.info("             doc/main의 pvo : " + pvo);
		log.info("             doc/main의 pCd : " + pvo.getPmemCd());
		session.setAttribute("pCd", pvo.getPmemCd());
		
		List<Map<String, Object>> docList = this.docService.docList(map);
		log.info("             doc/main의 List : " + docList);
		
		map.put("memNo", session.getAttribute("memNo"));
		log.info("           map : " + map);
		
		pvo.setMemNo((String)session.getAttribute("memNo"));
		ProMemVO amIPM = this.promemService.iAmPm(pvo);
		int pm = 0;
		if(amIPM != null) pm = amIPM.getPm();
		log.info("           난 pm인가? : " + pm);
		vo.setPm(pm);
		session.setAttribute("iamPM", vo);
		log.info("           난 pm인가?vo : " + vo);

		Map<String, Object> projVO = this.projectService.projMain(map);
		session.setAttribute("projVO", projVO);
		log.info("           projVO : " + projVO);
		if(projVO != null) {
			mav.addObject("projVO", projVO);
			mav.addObject("grp", grp);
		}
		
		mav.addObject("docList", docList);
		mav.setViewName("doc/docMain");
		return mav;
	}
	
	//2. 문서 상세 초회
	@RequestMapping("/docDetail/{docNo}/{pmemCd}")
	public ModelAndView docDetail(@PathVariable("docNo") int docNo, @PathVariable("pmemCd") int pmemCd, ModelAndView mav) {
		log.info("                /docDetail docNo : " + docNo);
		log.info("                /docDetail pmemCd : " + pmemCd);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pmemCd", pmemCd);
		map.put("docNo", docNo);
		
		//문서 조회
		Map<String, Object> docVO = this.docService.docDetail(map);
		//docNo : 32
		
		//첨부파일 조회
		List<DocFileVO> fileList = this.docfService.selectFile(docNo);
		log.info("filelist : " + fileList);
		
		for(int i = 0; i < fileList.size(); i++) {
			String origin = fileList.get(i).getDcfNm();
			String nm = origin.substring(origin.lastIndexOf("_")+1);
			fileList.get(i).setDcfNm(nm);
		}
		mav.addObject("fileList", fileList);
		mav.addObject("docVO", docVO);
		mav.setViewName("doc/docDetail");
		
		return mav;
	}
	
	//3. 문서 등록 페이지
	@GetMapping("/docNew")
	public String docNew() {
		return "doc/docNew";
	}
	
	//4. 문서 등록하기
	@PostMapping("/docInsert")
	@ResponseBody
	public int docInsert(@RequestBody Map<String, Object> map) {
		log.info("           /docInsert map : " + map);
		
		//문서 등록
		int res = this.docService.docInsert(map);
		//위에서 등록한 문서 번호 가져오기
		if(res>0) {
			int docNo = (Integer)map.get("docNo");
			log.info("      docInsert/docNo 가져오기 : " + docNo);
			return docNo;
		}else {
			return 0;
		}
	}
	
	//4-2. 파일저장
	@PostMapping("/docInsertF")
	@ResponseBody
	public int docInsertF(MultipartHttpServletRequest mtr) {
		//파일 저장되는 경로
		String savePath = "W:\\docFile";
		
		int docNo = Integer.parseInt(mtr.getParameter("docNo"));
	
		//저장경로 존재하지 않으면 만들기
		File uploadPath = new File(savePath, getFolder());
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		List<MultipartFile> uploadFile = mtr.getMultiFileMap().get("uploadFile");
		log.info("docNo : " + docNo);
		log.info("uploadFile : " + uploadFile);
		
		DocFileVO vo = new DocFileVO();
		int result = 0;
		
		if(uploadFile != null) {
			for(MultipartFile multipartFile : uploadFile) {
				
				//경로를 제외한 파일명만 추출
				String uploadFileName = multipartFile.getOriginalFilename();
				uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
				
				//같은날 같은 이미지 업로드 시 중복 방지-------------------
				//java.util.UUID : 랜덤값 생성
				UUID uuid = UUID.randomUUID();		//임의의 값 생성
				//원래의 파일이름과 구분하기 위해 _를 붙임
				uploadFileName = uuid.toString() + "_" + uploadFileName;
				//같은날 같은 이미지 업로드 시 중복 끝---------------------
				
				File saveFile = new File(uploadPath, uploadFileName);
				
				vo.setDocNo(docNo);
				vo.setDcfNm(uploadFileName);
				vo.setDcfSz(multipartFile.getSize()/1000);
				
				vo.setDcfSavepath(String.valueOf(saveFile));
				vo.setDcfSe(multipartFile.getContentType().substring(multipartFile.getContentType().lastIndexOf("/")+1));
				
				result = this.docfService.fileInsert(vo);
				
				try {
					//파일 복사
					multipartFile.transferTo(saveFile);
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return result;
		
	}
	
	//upload폴더 내에 년월일 폴더 생성
	public static String getFolder() {
		//간단한 날짜 형식
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		//날짜 객체 생성(java.util패키지)
		Date date = new Date();
		//2022-07-22형식으로
		String str = sdf.format(date);
				
		return str.replace("-", File.separator);
	}
	
	//5. 문서 수정하기
	@RequestMapping("docEdit")
	@ResponseBody
	public int docEdit(@RequestBody DocumentVO vo) {
		log.info("        수정할 글 vo : " + vo);
		int res = this.docService.docEdit(vo);
		if(res>0) {
			int docNo = vo.getDocNo();
			log.info("      docInsert/docNo 가져오기 : " + docNo);
			return docNo;
		}else {
			return 0;
		}
	}
	
	//6. 문서 삭제하기
	@PostMapping("/docDel")
	@ResponseBody
	public int docDel(@RequestBody int docNo) {
		int result2 = this.docService.docDel(docNo); 
		return result2;
	}
	
	
	//문서 다운로드
	@GetMapping("/fileDownload")
	@ResponseBody
	public ResponseEntity<Resource> fileDownload(@RequestParam int dcfNo) {
		DocFileVO vo = new DocFileVO();
		vo = this.docfService.getDownload(dcfNo);
		log.info("dcfNm : " + vo.getDcfNm());
		
		Resource resource = new FileSystemResource(vo.getDcfSavepath());
		String resourceName = resource.getFilename().substring(resource.getFilename().lastIndexOf("_")+1);
		
		log.info("file~~~~~~~~~~~~~~ : " + vo.getDcfSavepath());
		log.info("resourceName : "+ resourceName);
		
		//header : 인코딩 정보, 파일명 정보
		HttpHeaders headers = new HttpHeaders();
		try {
			headers.add("Content-Disposition", "attachment;filename=" 
					+ new String(resourceName.getBytes("UTF-8"), "ISO-8859-1"));
		} catch (UnsupportedEncodingException e) {
			log.info(e.getMessage());
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	
	//문서 양식별 검색
	@PostMapping("/selectType")
	@ResponseBody
	public List<Map<String, Object>> selectType(@RequestBody String docType, HttpServletRequest request) {
		log.info("docType : " + docType);
		//세션 가져오기
		HttpSession session = request.getSession();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projId", session.getAttribute("projId"));
		map.put("pmemGrp", session.getAttribute("grp"));
		map.put("docType", docType);
		
		List<Map<String, Object>> listMap = new ArrayList<Map<String,Object>>();
		listMap = this.docService.selectType(map);
		
		return listMap;
	}
	
	//문서 양식 전체
	@PostMapping("/typeAll")
	@ResponseBody
	public List<Map<String, Object>> typeAll(@RequestBody Map<String, Object> map) {
		List<Map<String, Object>> docList = this.docService.docList(map);
		return docList;
	}
	
	//문서번호 최대값
	@PostMapping("/maxDcfNo")
	@ResponseBody
	public int maxDcfNo() {
		return this.docfService.maxDcfNo();
	}
	
	
}

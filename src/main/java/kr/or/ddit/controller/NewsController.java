package kr.or.ddit.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.service.NewsLikeService;
import kr.or.ddit.service.NewsService;
import kr.or.ddit.vo.NewsLikeVO;
import kr.or.ddit.vo.NewsVO;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;

@Slf4j
@Controller
public class NewsController {
	
	@Autowired
	private NewsService service;
	
	//뉴스 페이지를 불러오면서 뉴스 리스트를 화면에 보여줌
	@RequestMapping("/newsList")
	public String newsList(@RequestParam(value = "listcnt", defaultValue = "1") String listcnt,  Model model, HttpServletRequest request)throws ParseException {
		
		//session에 admin이 있는지 없는지 확인하기 위한 코드를 작성해야 함
		HttpSession session = request.getSession();
		
		//뉴스 더보기 설정
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listcnt", Integer.parseInt(listcnt)*8);
		map.put("memNo",session.getAttribute("memNo"));

		//뉴스 리스트 화면에 뿌리기
		List<Map<String, Object>> list = this.service.list(map);
		
		log.info("list : " + list);
		
		
		//select 결과 list를 보냄
		model.addAttribute("list", list);
		model.addAttribute("listcnt",Integer.parseInt(listcnt));
		
		//forwarding
		return "newsList";
	}
	
	//빈 하트 클릭시 꽉 찬 하트 저장
	@ResponseBody
	@RequestMapping("/saveHeart")
	public int saveHeart(@RequestBody Map<String, Object> map, HttpServletRequest request,  Model model) {
		
		HttpSession session = request.getSession();
		map.put("memNo",session.getAttribute("memNo"));

		
		if(map.get("memNo")==null) {
			map.put("memNo","비회원");
//			map.put("memNm","관리자");
			log.info("map : " + map);
		}
		
		model.addAttribute("memNo", map.get("memNo"));
		int res = this.service.updateHeart(map);
		log.info("res : " + res);
		return res;
		
//		return 0;
	}

	
	
	//뉴스 상세보기
	//요청 URI /news/newsDetail?newsNo=1
	// 스프링에서는 요청 파라미터(articleNo=1)를 매개변수로 받을 수 있음
	// 파라미터는 String인데 spring에서 int로 자동 형변환해줌
	@GetMapping("/detail")
	public String detail(int newsNo, Model model,HttpServletRequest request,HttpServletResponse response, HttpSession session) {
		
		log.info("newsNo : " + newsNo);
		
		Map<String, Object> newsVO = this.service.getDetail(newsNo);
		
		model.addAttribute("newsVO", newsVO);
		
		return "newsDetail";
	}
	
	//골뱅이ModelAttribute NewsVO newsVO의 newsVO이름과
	//<form:form modelAttribute="newsVO" 이름을 통해
	//뷰(jsp)와 컨트롤러(java) 간에 연결이 됨
	//요청 URI : /news/newsWrite
	//글 등록
	@GetMapping("/newsWrite")
	public String write() {
		
		
		//forwarding
		return "newsWrite";
	}
	
	//요청 URI : /news/writePost
		//골뱅이Validated : 입력값 검증 기능을 활성화
		/* p.384
		  BindingResult에는 요청 파라미터의 바인딩 오류와 입력값 검증(숫자타입의 멤버변수에 문자가 옴)  오류 정보가 저장됨
		   - hasErrors() : 오류 발생 시 true를 반환 
		 */
	@ResponseBody
	@PostMapping("/writePost")
	public int writePost(@RequestBody Map<String, Object> map) {
		log.info("         writePost map : " + map);
		int res = service.insert(map);
		if(res>0) {
			int tem1 = (Integer)map.get("curr");
			return tem1;
		}else {
			return 0;
		}
	}
	
	//뉴스 사진 업로드
	@ResponseBody
	@PostMapping("/newsImg")
	public int projImg(@RequestParam MultipartFile file, @RequestParam String newsNo) {
		String fileName = file.getOriginalFilename();
		String fileExtension = fileName.substring(fileName.lastIndexOf("."),fileName.length());
		String uploadFolder = "C:\\eGovFrameDev-3.10.0-64bit\\workspace\\grampus\\src\\main\\webapp\\resources\\image";
		UUID uuid = UUID.randomUUID();
		String[] uuids = uuid.toString().split("-");
		String uniqueName = uuids[0];
		File saveFile = new File(uploadFolder+"\\"+uniqueName + fileExtension);
		try {
			file.transferTo(saveFile);
			
			//썸네일 만들기 시작--------------------
			//이미지인지 체킹
			if(UploadController.checkImageType(saveFile)) {
				//썸네일 => s_이미지파일명(바이너리 파일 생성)
				FileOutputStream thumbnail = 
						new FileOutputStream(
								new File(uploadFolder, "s_" + uniqueName + fileExtension)
								);
				//InputStream과 java.io.File 객체를 이용하여
				//썸네일 파일 생성. width:100px, height:100px
				
//				FileInputStream fis = new FileInputStream(saveFile);
//				Thumbnailator.createThumbnail(
//						fis,thumbnail,50,50
//						);
				
				//썸네일 사이즈 조정
				Thumbnails.of(uploadFolder+"\\"+uniqueName + fileExtension)
//		          .sourceRegion(Positions.CENTER, 100, 100) 중앙을 기준으로 이미지를 자름.
		          .size(200, 200) //썸네일 크기
		          .toFile(uploadFolder + "s_" + uniqueName + fileExtension); //경로설정
				
				
				thumbnail.close();
			}
		//썸네일 만들기 끝--------------------
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("newsPhoto", uniqueName+fileExtension);
		map.put("newsNo", Integer.parseInt(newsNo));
		int res = service.updateImg(map);
		return res;
	}
	
	//글 수정하기
	//요청 URI : /news/updatePost
	@ResponseBody
	@RequestMapping("/updatePost")
	public int updatePost(//RedirectAttributes rat,
			@RequestBody Map<String, Object> map
			) {
		
		//map : {newsTtl=범고래 icon, newCn=<p>고래 cion</p>, newsPhoto={}, newsNo=47}
		log.info("map : " + map);
//		// /news/detail?newsNo=1
//		rat.addFlashAttribute("newsNo", map.get("newsNo"));
		
		//테이블 업데이트 처리 로직
		int res = this.service.update(map);
		
		
		return res;
		
		
	}
	
	//글 삭제하기
	//요청 URI : /deletePost
	@PostMapping("/deletePost")
	public String delete(int newsNo) {
	
		int result = this.service.delete(newsNo);
		
		log.info("result : " + result);
		
		
		return "redirect:/newsList";
	}
	
	
	
}

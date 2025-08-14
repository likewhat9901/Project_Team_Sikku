package com.edu.springboot.mydiary;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import utils.MyFunctions;
import utils.PagingUtil;

@Controller
public class MyDiaryController {

	@Autowired
	IMyDiaryMapper dao;

	@Autowired
	private com.edu.springboot.dict.IDictService dictDao;

	@RequestMapping("/mydiary/list.do")
	public String mydiaryList(Model model, HttpServletRequest req, 
			@ModelAttribute ParameterDTO parameterDTO) {
		//디버깅
//		System.out.println(">>> DTO: start=" + parameterDTO.getStart() + 
//				", end=" + parameterDTO.getEnd());
		
		//로그인한 회원이 자신의 게시물만 볼 수 있음
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    String userId = auth.getName();
		
	    System.out.println(">>> 로그인한 유저 ID: " + userId);
	    parameterDTO.setUserId(userId);
	    
		// 게시물의 갯수 카운트(검색어가 있는 경우 파라미터는 DTO에 자동으로 저장됨)
		int totalCount = dao.getTotalCount(parameterDTO);

		// 페이징을 위한 설정값(하드코딩)
		int pageSize = 3; // 페이지 당 출력할 게시물의 갯수
		int blockPage = 5; // 한 블럭당 출력할 페이지번호의 갯수

		int pageNum = (req.getParameter("pageNum") == null || req.getParameter("pageNum").equals("")) ? 1
				: Integer.parseInt(req.getParameter("pageNum"));

		int start = (pageNum - 1) * pageSize + 1;
		int end = pageNum * pageSize;
//		System.out.println("시작:"+start);
//		System.out.println("끝:"+end);
		// 계산의 결과는 DTO에 저장
		parameterDTO.setStart(start);
		parameterDTO.setEnd(end);

		// View에서 게시물의 가상번호 계산을 위한 값을 Map에 저장
		Map<String, Object> maps = new HashMap<String, Object>();
		maps.put("totalCount", totalCount);
		maps.put("pageSize", pageSize);
		maps.put("pageNum", pageNum);
		model.addAttribute("maps", maps);

		// DB에서 인출한 게시물의 목록을 영역에 저장
		ArrayList<MyDiaryDTO> lists = dao.listPage(parameterDTO);
		model.addAttribute("lists", lists);

		// 게시판 하단에 출력할 페이지번호를 String으로 저장한 후 영역에 저장
		String pagingImg = PagingUtil.pagingImg(totalCount, pageSize, blockPage, pageNum,
				req.getContextPath() + "/mydiary/list.do?");
		
//		System.out.println("페이징" + pagingImg);
		model.addAttribute("pagingImg", pagingImg);

		// View로 포워드
		return "/mydiary/list";
	}

	// 입력1 : 작성페이지 매핑
	@GetMapping("/mydiary/write.do")
	public String mydiaryWrite(Model model) {
		// plantdict -> JSP 라디오 렌더링
		model.addAttribute("plants", dictDao.selectAll()); 
		return "mydiary/write";
	}

	// 입력2 : 사용자가 작성한 값으로 입력 처리. with 첨부파일
	@PostMapping("/mydiary/write.do")
	public String mydiaryWrite(HttpServletRequest req, MyDiaryDTO myDiaryDTO,
			@RequestParam(value="plantidx", required=false) Long plantidx) {
		try {
			//로그인한 사용자의 userid 추출
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			String userId = auth.getName(); 
			
			myDiaryDTO.setUserId(userId);
			
			MultipartFile file = myDiaryDTO.getOfile();
			System.out.println("로그인한 userid:"+userId);
			if (file != null && !file.isEmpty()) {
				// 저장 폴더 경로
				String uploadDir = ResourceUtils.getFile("classpath:static/uploads/").toPath().toString();
				System.out.println("물리적 경로: " + uploadDir);

				// 원본 파일명
				String originalFileName = file.getOriginalFilename();
				myDiaryDTO.setOfileName(originalFileName); // 원본 파일명 DTO에 저장

				// 파일 저장
				File destFile = new File(uploadDir, originalFileName);
				file.transferTo(destFile);

				// UUID 리네임 처리
				String savedFileName = MyFunctions.renameFile(uploadDir, originalFileName);
				myDiaryDTO.setSfile(savedFileName); // 저장된 파일명 DTO에 저장
			}

			// 나머지 정보 폼값 매핑
			myDiaryDTO.setDescription(req.getParameter("description"));
			myDiaryDTO.setTemperature(Float.parseFloat(req.getParameter("temperature")));
			myDiaryDTO.setHumidity(Float.parseFloat(req.getParameter("humidity")));
			myDiaryDTO.setSunlight(Float.parseFloat(req.getParameter("sunlight")));
			myDiaryDTO.setHeight(Float.parseFloat(req.getParameter("height")));
			myDiaryDTO.setFruit(Integer.parseInt(req.getParameter("fruit")));
			//추가 : 라디오 plantIdx (미선택 가능)
			myDiaryDTO.setPlantidx(plantidx);
				        
			// 테이블에 insert 처리
			int result = dao.write(myDiaryDTO);
			if (result == 1)
				System.out.println("입력 성공");
			else
				System.out.println("입력 실패");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("업로드 실패");
		}
		// 글쓰기 완료 후 목록이로 이동
		return "redirect:list.do";
	}

	// 열람 : 클릭시 전달되는 일련번호는 DTO를 통해 받은 후 사용
	@GetMapping("/mydiary/view.do")
	public String mydiaryView(Model model, MyDiaryDTO myDiaryDTO) {
		// DTO를 view함수 호출시 전달
		if (myDiaryDTO.getDiaryIdx() != null) {
			myDiaryDTO = dao.view(myDiaryDTO);
			myDiaryDTO.setDescription(myDiaryDTO.getDescription().replace("\r\n", "<br/"));
			model.addAttribute("myDiaryDTO", myDiaryDTO);
			return "mydiary/view";
		} else {
			return "mydiary/error";
		}
	}

	// 수정1 : 기존 내용을 읽어와서 수정폼에 설정
	@GetMapping("/mydiary/edit.do")
	public String mydiaryEditGet(Model model, MyDiaryDTO myDiaryDTO) {
		// 열람에서 사용한 메서드를 그대로 사용
		myDiaryDTO = dao.view(myDiaryDTO);
		model.addAttribute("myDiaryDTO", myDiaryDTO);
		model.addAttribute("plants", dictDao.selectAll());
		return "mydiary/edit";
	}

	// 수정2 : 사용자가 입력한 내용을 전송하여 update 처리
	@PostMapping("/mydiary/edit.do")
	public String mydiaryEditPost(HttpServletRequest req, MyDiaryDTO myDiaryDTO,
			@RequestParam(value="plantidx", required=false) Long plantidx) {
		try {
			MultipartFile file = myDiaryDTO.getOfile();

			if (file != null && !file.isEmpty()) {
				// 새 이미지 업로드가 있을 경우에만 처리
				String uploadDir = ResourceUtils.getFile("classpath:static/uploads/").toPath().toString();
				String originalFileName = file.getOriginalFilename();

				myDiaryDTO.setOfileName(originalFileName);
				File destFile = new File(uploadDir, originalFileName);
				file.transferTo(destFile);

				String savedFileName = MyFunctions.renameFile(uploadDir, originalFileName);
				myDiaryDTO.setSfile(savedFileName);
			} else {
				// 새 파일이 없으면 기존 파일명 유지
				MyDiaryDTO origin = dao.view(myDiaryDTO);
				myDiaryDTO.setOfileName(origin.getOfileName());
				myDiaryDTO.setSfile(origin.getSfile());
			}
			
			myDiaryDTO.setPlantidx(plantidx);
			// 수정 후 결과는 int형으로 반환
			int result = dao.edit(myDiaryDTO);
			System.out.println("글수정결과:" + result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 수정이 완료되면 열람페이지로 이동. 일련번호가 파라미터로 전달됨.
		return "redirect:view.do?diaryIdx=" + myDiaryDTO.getDiaryIdx();
	}

	// 삭제 : request 내장객체를 통해 폼값 받음
	@PostMapping("/mydiary/delete.do")
	public String mydiaryDeletePost(HttpServletRequest req) {
		//삭제할 다이어리 번호
		String diaryIdx = req.getParameter("diaryIdx");
		//로그인한 사용자의 userid 추출
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userId = auth.getName(); 
		
//		System.out.println("삭제할 다이어리 번호"+diaryIdx);
		Map<String, Object> params = new HashMap<>();
	    params.put("diaryIdx", diaryIdx);
	    params.put("userId", userId);
	    
		int result = dao.delete(params);
		System.out.println("글삭제결과:" + result);
		return "redirect:list.do";
	}
	
	// 입력1 : 작성페이지 매핑
	@GetMapping("/mydiary/calendar.do")
	public String calender() {
		return "mydiary/calendar";
	}

}

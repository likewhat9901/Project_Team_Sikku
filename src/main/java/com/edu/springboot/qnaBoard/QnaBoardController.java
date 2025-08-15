package com.edu.springboot.qnaBoard;

import java.security.Principal;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

import com.edu.springboot.jpaboard.MemberEntity;
import com.edu.springboot.jpaboard.MemberRepository;

@Controller
public class QnaBoardController {
	
	@Autowired
	private QnaBoardService qnaService;
	@Autowired
	private QnaBoardRepository qnaRepo;
	@Autowired
	private MemberRepository memberRepo;
	
	//================== List 페이지 ==========================
	private final int pageSize = 10;
	
	// List 페이지 이동
    @GetMapping("/qnaBoardList.do")
    public String list(@RequestParam(name = "page", defaultValue = "1") int page, Model model) {
    	model.addAttribute("noticeRows", qnaService.getNoticeList());
    	
    	Page<QnaBoardEntity> qnaPage = qnaService.getQnaList(page, pageSize);

        model.addAttribute("qnaRows", qnaPage);
        model.addAttribute("totalPages", qnaPage.getTotalPages());
        
        return "boards/qna/qnaBoardList"; // JSP 경로
    }
    
    // 검색 기능
    @GetMapping("/qna/search.do")
    public String search(
		@RequestParam(name = "page", defaultValue = "1") int page,
        @RequestParam("type") String type,
        @RequestParam("keyword") String keyword,
        Model model) {
    	
    	//공지글은 고정
    	model.addAttribute("noticeRows", qnaService.getNoticeList());
    	
    	//검색된 게시글로 업데이트
        if (keyword == null || keyword.trim().isEmpty()) {
            model.addAttribute("qnaRows", qnaService.getQnaList(page, pageSize)); // ← 공지 제외된 일반글
        } else {
            model.addAttribute("qnaRows", qnaService.qnaSearch(type, keyword, page, pageSize));
        }
        
        return "boards/qna/qnaBoardList";
    }
    
    //================== View 페이지 ==========================
  	// View 페이지 이동
    @GetMapping("/qnaBoardView.do")
    public String view(@RequestParam("idx") Long idx, 
    		Model model, Principal principal, HttpSession session) {
    	/*============== 조회수 증가 =================*/
        // 로그인한 사용자 id, 게시글 idx
        String userId = principal.getName();
        String viewKey = "viewed_qna_" + idx;
        
        // 이전에 본 적 없는 경우만 조회수 증가
        if (session.getAttribute(viewKey) == null) {
            qnaService.increaseViews(idx, userId);
            session.setAttribute(viewKey, true);
        }
    	
        /*============== 게시글 하나 가져오기 =================*/
        QnaBoardEntity qna = qnaService.getQnaOneById(idx);
        
        // 예외상황 대비
        if (qna == null) {
        	model.addAttribute("errorMsg", "존재하지 않는 게시글입니다.");
            return "redirect:/qnaBoardList.do";
        }

        model.addAttribute("qna", qna);
        
        /*============== 관리자 계정 확인 =================*/
        MemberEntity member = memberRepo.findByUserId(userId).orElse(null);
        String authority = member.getAuthority();
        
        if (member != null) {
            model.addAttribute("userRole", member.getAuthority());
        } else {
            model.addAttribute("userRole", "ROLE_USER"); // 기본값
        }
        
        return "boards/qna/qnaBoardView"; // JSP 경로
    }
    
    // 삭제 기능
    @GetMapping("/qnaBoardDelete.do")
    public String delete(@RequestParam("idx") Long idx) {
        qnaService.deletePost(idx);
        return "redirect:/qnaBoardList.do"; // 삭제 후 목록으로 이동
    }
    
    @PostMapping("/qnaBoardAnswer.do")
    public String submitAnswer(@RequestParam("idx") Long idx,
                               @RequestParam("answercontent") String answerContent) {

        // 답변 내용 DB에 업데이트
        qnaService.updateAnswer(idx, answerContent);

        return "redirect:/qnaBoardView.do?idx=" + idx;
    }

    
    
    
    //================== Write 페이지 ==========================
  	// Write 페이지 이동
    @GetMapping("/qnaBoardWrite.do")
    public String write(Model model, Principal principal) {
    	
    	//유저 아이디 가져오기
    	QnaBoardEntity qEntity = new QnaBoardEntity();
    	String writerid = principal.getName();
    	qEntity.setWriterid(writerid);
    	
    	//멤버 테이블에서 닉네임 가져오기
    	Optional<MemberEntity> memberOpt = memberRepo.findById(writerid);
    	String writer = memberOpt.get().getUsername();
    	System.out.println("writer는 뭘까여->"+ writer);
    	
    	//모델에 담기
    	model.addAttribute("writerid", writerid);
    	model.addAttribute("writer", writer);
        
        return "boards/qna/qnaBoardWrite"; // JSP 경로
    }
    
  	// Write 글쓰기 처리 (Create) 
    @PostMapping("/qnaBoardWriteProc.do")
    public String writeProc(@RequestParam("title") String title,
                           @RequestParam("content") String content,
                           @RequestParam("category") String category,
                           @RequestParam("writer") String writer,
                           @RequestParam("writerid") String writerid,
                           @RequestParam(value="secretflag", required = false) String secretflag
    ) {
        // 직접 새 객체 생성
        QnaBoardEntity qEntity = new QnaBoardEntity();
        qEntity.setTitle(title);
        qEntity.setContent(content);
        qEntity.setCategory(category);
        qEntity.setWriter(writer);
        qEntity.setWriterid(writerid);
        qEntity.setSecretflag("Y".equals(secretflag) ? "Y" : "N");
        
        // 기본값들은 Entity에서 처리하거나 여기서 설정
        
        qnaRepo.save(qEntity);
        return "redirect:/qnaBoardList.do";
    }


}

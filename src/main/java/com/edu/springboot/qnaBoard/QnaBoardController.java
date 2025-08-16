package com.edu.springboot.qnaBoard;

import java.security.Principal;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
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
	// List 페이지 이동
    @GetMapping("/qnaBoardList.do")
    public String list(Model model) {
    	
        model.addAttribute("noticeRows", qnaService.getNoticeList());
        model.addAttribute("qnaRows", qnaService.getQnaList());
        
        return "boards/qna/qnaBoardList"; // JSP 경로
    }
    
    // 검색 기능
    @GetMapping("/qna/search.do")
    public String search(
        @RequestParam("type") String type,
        @RequestParam("keyword") String keyword,
        Model model) {
    	
    	//공지글은 고정
    	model.addAttribute("noticeRows", qnaService.getNoticeList());
    	
    	//검색된 게시글로 업데이트
        if (keyword == null || keyword.trim().isEmpty()) {
            model.addAttribute("qnaRows", qnaService.getQnaList()); // ← 공지 제외된 일반글
        } else {
            model.addAttribute("qnaRows", qnaService.qnaSearch(type, keyword));
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
        
        model.addAttribute("userId", userId);
    	
        /*============== 게시글 하나 가져오기 =================*/
        QnaBoardEntity qna = qnaService.getQnaOneById(idx);
        
        // 예외상황 대비
        if (qna == null) {
        	model.addAttribute("errorMsg", "존재하지 않는 게시글입니다.");
            return "redirect:/qnaBoardList.do";
        }

        model.addAttribute("qna", qna);
        
        return "boards/qna/qnaBoardView"; // JSP 경로
    }
    
    // 삭제 기능
    @GetMapping("/qnaBoardDelete.do")
    public String delete(@RequestParam("idx") Long idx) {
        qnaService.deletePost(idx);
        return "redirect:/qnaBoardList.do"; // 삭제 후 목록으로 이동
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
    public String writeProc(QnaBoardEntity qEntity) {
        
    	//secretFlag(비밀글 여부)는 체크박스로 받기때문에 체크를 안하면 null이다.
    	//따라서 secretFlag만 "N"으로 초기화해준다. 
    	if(qEntity.getSecretflag()==null) {
    		qEntity.setSecretflag("N");
    	}
        
        qnaRepo.save(qEntity);
        
        return "redirect:/qnaBoardList.do";
    }
    
    
    //================== Write 페이지 ==========================
  	// Edit 페이지 이동
    @GetMapping("/qnaBoardEdit.do")
    public String edit(Model model, @RequestParam("idx") Long idx) {
    	
    	Optional<QnaBoardEntity> qBoardOpt = qnaRepo.findById(idx);
    	QnaBoardEntity qna = qBoardOpt.get();
    	
    	System.out.println("qna 가져와->" + qna.getIdx());
    	
    	model.addAttribute("qna", qna);
        
        return "boards/qna/qnaBoardEdit"; // JSP 경로
    }
    
    
    

  	// Edit 수정하기 처리 (Update)
    @PostMapping("/qnaBoardEditProc.do")
    public String editProc(Model model, QnaBoardEntity qEntity) {
    	
    	//null값 방지를 위해 "N"으로 초기화. (Write 와 동일)
    	if(qEntity.getSecretflag()==null) {
    		qEntity.setSecretflag("N");
    	}
        
        qnaRepo.save(qEntity);
        
    	return "redirect:/qnaBoardView.do?idx=" + qEntity.getIdx();
    }

}

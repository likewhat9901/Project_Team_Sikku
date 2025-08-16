package com.edu.springboot.qnaBoard;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    		Model model, Principal principal, HttpSession session,
    		RedirectAttributes redirectAttributes) {
    	// 로그인한 사용자 id, 게시글 idx
    	String userId = principal.getName();
    	String viewKey = "viewed_qna_" + idx;
        
        /*============== 게시글 하나 가져오기 =================*/
        QnaBoardEntity qna = qnaService.getQnaOneById(idx);
        
        // 예외상황 대비
        if (qna == null) {
        	model.addAttribute("errorMsg", "존재하지 않는 게시글입니다.");
            return "redirect:/qnaBoardList.do";
        }
        
        /*============== 비밀글 접근 제한(본인, 관리자), 관리자 계정 확인 =================*/
        MemberEntity member = memberRepo.findByUserId(userId).orElse(null);
        // 관리자 체크
        String authority = (member != null) ? member.getAuthority() : "ROLE_USER";
        
        boolean isAdmin = authority.equals("ROLE_ADMIN");
        boolean isOwner = qna.getWriterid().equals(userId);
        boolean isSecret = "Y".equalsIgnoreCase(qna.getSecretflag());
        
        if (isSecret && !(isOwner || isAdmin)) {
            redirectAttributes.addFlashAttribute("errorMsg", "비밀글은 본인 또는 관리자만 열람할 수 있습니다.");
            return "redirect:/qnaBoardList.do";
        }
        
        /*============== 조회수 증가 =================*/
        // 이전에 본 적 없는 경우만 조회수 증가
        if (session.getAttribute(viewKey) == null) {
        	qnaService.increaseViews(idx, userId);
        	session.setAttribute(viewKey, true);
        }
        
        model.addAttribute("qna", qna);
        model.addAttribute("userId", userId);
        model.addAttribute("userRole", authority);
        
        return "boards/qna/qnaBoardView"; // JSP 경로
    }
    
    // 삭제 기능
    @GetMapping("/qnaBoardDelete.do")
    public String delete(@RequestParam("idx") Long idx) {
        qnaService.deletePost(idx);
        return "redirect:/qnaBoardList.do"; // 삭제 후 목록으로 이동
    }
    
    // 관리자 답변
    @PostMapping("/qnaBoardAnswer.do")
    public String submitAnswer(@RequestParam("idx") Long idx,
                               @RequestParam("answercontent") String answerContent) {

        // 답변 내용 DB에 업데이트
        qnaService.updateAnswer(idx, answerContent);

        return "redirect:/qnaBoardView.do?idx=" + idx;
    }
    
    // 좋아요 기능
    @PostMapping("/qnaBoardLike.do")
    @ResponseBody
    public Map<String, Object> like(@RequestBody Map<String, Object> payload,
						    		HttpSession session,
						            Principal principal) {
    	Map<String, Object> result = new HashMap<>();
    	
    	//게시글 번호
    	//Long.valueOf -> 문자열을 Long 객체로 변환
        Long idx = Long.valueOf(payload.get("idx").toString()) ; // Object → String → Long
        String userId = principal.getName(); // 로그인한 사용자
        
        // 작성자 key
        String likeKey = "liked_" + idx + "_" + userId;
        
        // 게시글 가져오기
        QnaBoardEntity qna = qnaService.findById(idx);
        
        // 내 글일 때
        if (qna.getWriterid().equals(userId)) {
            result.put("success", false);
            result.put("message", "내 글에는 좋아요를 누를 수 없습니다.");
            return result;
        }
        
        // 이미 좋아요 눌렀을때
        if (session.getAttribute(likeKey) != null) {
            result.put("success", false);
            result.put("message", "이미 좋아요를 눌렀습니다.");
            return result;
        }
        
        // 좋아요 수 증가 처리
        int updatedLikes = qnaService.increaseLikeCount(idx);
        
        session.setAttribute(likeKey, true); // 세션 기록

        result.put("success", true);
        result.put("likes", updatedLikes);
        return result;
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

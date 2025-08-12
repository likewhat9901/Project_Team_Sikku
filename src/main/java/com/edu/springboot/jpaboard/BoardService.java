package com.edu.springboot.jpaboard;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.edu.springboot.jpaboard.dto.LikedPostDto;
import com.edu.springboot.jpaboard.dto.MyPostDto;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class BoardService {
	
    @Autowired
    private BoardRepository boardRepository;

    @Autowired
    private BoardRepository br;
    @Autowired
    private LikeRepository lr;

    // 목록 (검색어X)
    public Page<BoardEntity> selectList(Pageable pageable) {
        return br.findAll(pageable);
    }

    // 목록 (검색어O)
    public Page<BoardEntity> selectListSearch(String search, Pageable pageable) {
        return br.findByTitleLike(search, pageable);
    }

    // 상세보기
    public Optional<BoardEntity> selectPost(Long boardIdx) {
        Optional<BoardEntity> board = br.findById(boardIdx);

        // 조회수 +1
        BoardEntity be = board.orElseThrow(() -> new IllegalArgumentException("게시물을 찾을 수 없습니다."));
        int visitcount = (be.getVisitcount() == null) ? 0 : be.getVisitcount();
        be.setVisitcount(visitcount + 1);
        br.save(be);

        return Optional.of(be);
    }

    // 좋아요 토글
    @Transactional
    public Map<String, Object> toggleLike(Long boardIdx, String userId) {
        BoardEntity board = br.findById(boardIdx)
                .orElseThrow(() -> new IllegalArgumentException("게시물을 찾을 수 없습니다."));

        // 해당 유저가 이미 좋아요 했는지 확인
        Optional<LikeEntity> existingLike = board.getLikes().stream()
                .filter(like -> like.getUserId().equals(userId))
                .findFirst();

        boolean isLiked;

        if (existingLike.isPresent()) {
            // 좋아요 취소
            board.getLikes().remove(existingLike.get());
            lr.delete(existingLike.get());
            isLiked = false;
        } else {
            // 좋아요 추가
            LikeEntity newLike = new LikeEntity();
            newLike.setBoard(board);
            newLike.setUserId(userId);
            newLike.setLikedDate(LocalDateTime.now());

            board.getLikes().add(newLike);
            lr.save(newLike);
            isLiked = true;
        }

        // hboard.likes 컬럼 동기화
        int newLikesCount = board.getLikes().size();
        board.setLikesCount(newLikesCount);
        br.save(board);

        Map<String, Object> result = new HashMap<>();
        result.put("likesCount", newLikesCount);
        result.put("isLiked", isLiked);
        return result;
    }

    // 글쓰기
    public void insertPost(BoardEntity be) {
        br.save(be);
    }

    // 수정
    public void updatePost(BoardEntity be) {
        br.save(be);
    }

    // 삭제
    public void deletePost(Long boardIdx) {
        br.deleteById(boardIdx);
    }

    // 카테고리별 좋아요 TOP10
    public List<BoardEntity> getTop10BoardsByCategory(Integer category) {
        return br.findTop10ByCategoryOrderByLikesDesc(category);
    }

    // 마이페이지: 내가 좋아요 누른 글 목록 조회  
    public List<LikedPostDto> getLikedPostsOf(String userId) {
        return lr.findLikedPostsByUser(userId);
    }
    
    public List<MyPostDto> getMyPostsOf(String userId) {
        return boardRepository.findMyPosts(userId);
    }
}

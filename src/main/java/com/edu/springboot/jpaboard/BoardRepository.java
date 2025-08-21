package com.edu.springboot.jpaboard;

import java.util.List;

import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.edu.springboot.jpaboard.dto.IBoardRow;
import com.edu.springboot.jpaboard.dto.MyPostDto;

// public interface BoardRepository extends JpaRepository<BoardEntity, Long> {

// 커스텀 레포지토리를 만든 후 기존 레포지토리와 연결.
public interface BoardRepository extends JpaRepository<BoardEntity, Long>,
														BoardRepositoryCustom {

	
	// 카테고리를 기준으로 데이터 가져오기
	Page<BoardEntity> findByCategory(Pageable pageable, Integer category);
	
	// 검색 기능
	Page<BoardEntity> findByCategoryAndTitleContaining(Pageable pageable, Integer category, String title);
    
	
	
    List<BoardEntity> findTop10ByCategoryOrderByLikesCountDesc(Integer category);
    
    
    
//    // 게시글 내용(content)에 대한 검색
//    Page<BoardEntity> findByContentLike(String content, Pageable pageable);
//
//    // 게시글 제목 또는 내용에서 검색
//    Page<BoardEntity> findByTitleContainingOrContentContaining(String title, String content, Pageable pageable);
//
//    // 특정 작성자의 게시글만
//    Page<BoardEntity> findByWriter(String writer, Pageable pageable);
    
    
    @Query("""
            select new com.edu.springboot.jpaboard.dto.MyPostDto(
                b.boardIdx, b.title, b.postdate
            )
            from BoardEntity b
            where b.userId = :userId
            order by b.postdate desc
        """)
        List<MyPostDto> findMyPosts(@Param("userId") String userId);

    
    @Query("""
    	    select b.boardIdx as boardIdx,
    	           b.title as title,
    	           b.postdate as postdate,
    	           count(l) as likeCount
    	    from BoardEntity b
    	    left join b.likes l
    	    where b.category = :category
    	    group by b.boardIdx, b.title, b.postdate
    	    order by count(l) desc
    	""")
    	Page<IBoardRow> findTopByCategory(@Param("category") Integer category, Pageable pageable);
    
}

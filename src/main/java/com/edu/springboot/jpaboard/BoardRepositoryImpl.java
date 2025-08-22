package com.edu.springboot.jpaboard;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;

import lombok.RequiredArgsConstructor;

/* 커스텀 레포지토리 */
// 2) 구현체
// 실제 복합 검색 로직(QueryDSL 기반)을 구현
@RequiredArgsConstructor
public class BoardRepositoryImpl implements BoardRepositoryCustom {

	private final JPAQueryFactory queryFactory;  // 쿼리를 실행하는 핵심객체
	
	@Override
	public Page<BoardEntity> searchComplex(Pageable pageable, BoardSearchCondDTO condDTO) {
		
		QBoardEntity b = QBoardEntity.boardEntity;
		BooleanBuilder where = new BooleanBuilder();
		
	    if(condDTO.getSearchWord() != null && !condDTO.getSearchWord().isEmpty()) {
	        // 띄어쓰기 단위로 검색어 분리
	        String[] keywords = condDTO.getSearchWord().split(" ");
	        for(String word : keywords) {
	            // 제목 또는 내용에 검색어가 포함되는지 확인.
	            where.or(b.title.containsIgnoreCase(word)
	                  .or(b.content.containsIgnoreCase(word)));
	        }
	    }
		
		List<BoardEntity> content = queryFactory
				.selectFrom(b)
				.where(where)
				.orderBy(b.postdate.desc())
				.offset(pageable.getOffset())
				.limit(pageable.getPageSize())
				.fetch();
		
		long total = queryFactory
				.select(b.count())
				.from(b)
				.where(where)
				.fetchOne();
		
		// 스프링 데이터가 제공하는 Page 인터페이스의 구현체인 PageImpl 객체를 생성하여 반환.
		return new PageImpl<>(content, pageable, total);
		
		/*
		 * content: 현재 페이지에 해당하는 실제 게시글 목록 (이전 코드에서 .fetch()로 가져온 리스트).

		 * pageable: 현재 페이지 정보 (페이지 번호, 한 페이지당 보여줄 개수 등).

		 * total: 전체 데이터의 총 개수 (방금 .count()로 계산한 값).
		 */
	}
	
	@Override
    public List<WeeklyPostCountDTO> countWeeklyPosts() {
        QBoardEntity b = QBoardEntity.boardEntity;

        LocalDate today = LocalDate.now();
        LocalDate sevenDaysAgo = today.minusDays(6);

        
        List<WeeklyPostCountDTO> result = queryFactory
        		.select(Projections.constructor(WeeklyPostCountDTO.class,
    	            // SQL DATE(postdate) → LocalDate로 매핑
    	            Expressions.dateTemplate(LocalDate.class, "DATE({0})", b.postdate),
    	            b.count()
    	        ))
    	        .from(b)
    	        .where(b.postdate.between(sevenDaysAgo.atStartOfDay(), today.plusDays(1).atStartOfDay()))
    	        .groupBy(Expressions.dateTemplate(LocalDate.class, "DATE({0})", b.postdate))
    	        .orderBy(Expressions.dateTemplate(LocalDate.class, "DATE({0})", b.postdate).asc())
    	        .fetch();
        
        return result;
    }
	
}

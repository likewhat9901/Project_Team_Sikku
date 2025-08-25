package com.edu.springboot.jpaboard;

import java.time.LocalDate;
import java.util.List;
import com.querydsl.core.Tuple;
import com.querydsl.jpa.impl.JPAQueryFactory;

import lombok.RequiredArgsConstructor;

/* 커스텀 레포지토리 */
// 2) 구현체
// 실제 복합 검색 로직(QueryDSL 기반)을 구현
@RequiredArgsConstructor
public class MemberRepositoryImpl implements MemberRepositoryCustom {

	private final JPAQueryFactory queryFactory;
	
	
	@Override
    public List<WeeklyUserDTO> findWeeklyUsers() {
        QBoardEntity b = QBoardEntity.boardEntity;
        QCommentEntity c = QCommentEntity.commentEntity;
        QMemberEntity m = QMemberEntity.memberEntity;
        
        LocalDate today = LocalDate.now();
        LocalDate sevenDaysAgo = today.minusDays(6);
        
        
        //DB에서 해당쿼리문을 이용하면 게시물,댓글 발행량이 많은 유저 5명을 List<Tuple>에 담음
        List<Tuple> rows = queryFactory
            .select(m.userId,
            		b.countDistinct().coalesce(0L),
            		c.countDistinct().coalesce(0L))
            .from(m)
            .leftJoin(b).on(b.userId.eq(m.userId)
            		.and(b.postdate.between(sevenDaysAgo.atStartOfDay(),
            				today.plusDays(1).atStartOfDay()
    				)))
            .leftJoin(c).on(c.member.userId.eq(m.userId)
            		.and(c.postdate.between(sevenDaysAgo.atStartOfDay(),
            				today.plusDays(1).atStartOfDay()
    				)))
            .groupBy(m.userId)
            .having(b.count().add(c.count()).gt(0))
            .orderBy(b.count().add(c.count()).desc())
            .limit(5)
            .fetch();
        
        return rows.stream()
        	    .map(row -> new WeeklyUserDTO(
        	        row.get(0, String.class),  // userId
        	        row.get(1, Long.class),    // postCount  
        	        row.get(2, Long.class)     // commentCount
        	    ))
        	    .toList();
    }
	
}

package com.edu.springboot.jpaboard;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.DateExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.NumberExpression;
import com.querydsl.core.types.dsl.StringExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class CommentRepositoryImpl implements CommentRepositoryCustom {

	private final JPAQueryFactory queryFactory;  // 쿼리를 실행하는 핵심객체

	
	@Override
    public List<WeeklyPostCountDTO> countWeeklyComments() {
        QCommentEntity b = QCommentEntity.commentEntity;

        LocalDate today = LocalDate.now();
        LocalDate sevenDaysAgo = today.minusDays(6);
        
        // postdate 칼럼에 있는 날짜를 '2025-08-22' 같은 문자열로 바꿔줌
        StringExpression dayStr = Expressions.stringTemplate(
                "TO_CHAR({0}, 'YYYY-MM-DD')", b.postdate);
        
        NumberExpression<Long> cnt = b.commentIdx.count();

        //DB에서 해당쿼리문을 이용하면 7일, 즉 7개의 행들(rows)을 List<Tuple>에 담음
        List<Tuple> rows = queryFactory
            .select(dayStr, cnt)
            .from(b)
            .where(b.postdate.between(
        		sevenDaysAgo.atStartOfDay(),
                today.plusDays(1).atStartOfDay()   // 오늘 포함
            ))
            .groupBy(dayStr)
            .orderBy(dayStr.asc())
            .fetch();

        DateTimeFormatter f = DateTimeFormatter.ISO_LOCAL_DATE;

        return rows.stream()
            .map(t -> new WeeklyPostCountDTO(
                LocalDate.parse(t.get(dayStr), f), // 문자열 → LocalDate
                t.get(cnt)
            ))
            .toList();
    }
	
}

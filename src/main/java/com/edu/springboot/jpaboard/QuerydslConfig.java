package com.edu.springboot.jpaboard;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.querydsl.jpa.impl.JPAQueryFactory;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/*
QueryDSL 설정
JPAQueryFactory는 QueryDSL로 쿼리를 날릴 때 필요한 핵심 객체.

*/
@Configuration
public class QuerydslConfig {

	@PersistenceContext
	private EntityManager em;  // JPA가 기본으로 제공하는 DB와의 연결 객체
	
	
	// 스프링 빈으로 등록해서 Service/Repository 어디서든 주입해서 사용 가능하도록함.
	@Bean
	public JPAQueryFactory jpaQueryFactory() {
		// EntityManager 기반으로 QueryDSL을 사용할 수 있게 해줌
		return new JPAQueryFactory(em);
	}
	
}

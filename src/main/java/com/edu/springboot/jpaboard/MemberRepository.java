package com.edu.springboot.jpaboard;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<MemberEntity, String> {
    // 기본적인 CRUD + findAll(Sort sort) 등 제공
	
	Optional<MemberEntity> findByUserId(String userId);
	boolean existsByUserId(String userId);
	
}

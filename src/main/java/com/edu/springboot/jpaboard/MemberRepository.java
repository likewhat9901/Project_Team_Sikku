package com.edu.springboot.jpaboard;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<MemberEntity, String>,
													MemberRepositoryCustom {
	
	Optional<MemberEntity> findByUserId(String userId);
	boolean existsByUserId(String userId);
	
}

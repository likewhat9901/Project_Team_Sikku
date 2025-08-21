package com.edu.springboot.flutteruser;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<User, String>{
	boolean existsByUserid(String userid);
}
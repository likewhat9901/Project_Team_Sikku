package com.edu.springboot.jpaboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LikeService {
	
	@Autowired
	LikeRepository lr;

	public Long getLikesCount(Long boardIdx) {
		
		Long getLikesCount = lr.countByBoard_BoardIdx(boardIdx);
		
		return getLikesCount;
		
	
		
			
	}
	
}

package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.edu.springboot.jpaboard.dto.MyCommentDto;


@Service
public class MemberService {
	
	//DAO역할의 인터페이스
	@Autowired
	private MemberRepository mr;
	
	
    /**********************************************************************/
    
    // 최근 7일 게시글 통계 가져오기
    public List<WeeklyUserDTO> getWeeklyUsers() {
    	return mr.findWeeklyUsers();
    }
	
}
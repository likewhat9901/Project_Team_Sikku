package com.edu.springboot.mydiary;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CalendarService {
	
	//db에서 데이터 조회
	@Autowired
	IMyDiaryMapper dao;
	
	public List<DiaryPostResponse> getPostsByMonth(int year, int month, String userId) {
		String yearStr = String.valueOf(year);
		String monthStr = String.format("%02d", month);
		//디버깅
		System.out.println(year+","+yearStr);
		System.out.println(month+","+monthStr);
		//
		List<DiaryPostResponse> diaryList = 
				dao.selectByMonth(yearStr, monthStr, userId).stream()
				.filter(dto -> dto.getImageUrl() != null && !dto.getImageUrl().isEmpty())
				.collect(Collectors.toList());
		
		return diaryList;
	}

}

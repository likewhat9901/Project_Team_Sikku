package com.edu.springboot.mydiary;

import java.sql.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MyDiaryDTO {
	private Long diaryIdx;
	private String userId;
	private MultipartFile ofile; //서버에 업로드된 파일
	private String ofileName; 	//원본 파일명
	private String sfile;		//db에 저장할 파일 이름
	private Date postdate;
	private String description;
	private float temperature; 
	private float humidity; 
	private float sunlight; 	
	private float height;
	private int fruit;
	private Long plantidx;
}

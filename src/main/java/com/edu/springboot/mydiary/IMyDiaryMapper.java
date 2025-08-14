package com.edu.springboot.mydiary;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IMyDiaryMapper {
	//목록 : 게시물 갯수 카운트
	public int getTotalCount(ParameterDTO parameterDTO);
	//목록 : 한페이지에 출력할 게시물 인출
	public ArrayList<MyDiaryDTO> listPage(ParameterDTO parameterDTO);
	//작성
	public int write(MyDiaryDTO myDiaryDTO);
	//열람 
	public MyDiaryDTO view(MyDiaryDTO myDiaryDTO);
	//수정
	public int edit(MyDiaryDTO myDiaryDTO);
	//삭제
	public int delete(Map<String, Object> params);
	//이미지 캘린더에 썸네일로 넣기
	List<DiaryPostResponse> selectByMonth(@Param("year") String year, 
			@Param("month") String month, @Param("userId") String userId);
	//카드 계산
	MyDiaryDTO selectLatestByUserAndPlant(@Param("userId") String userId,
            @Param("plantidx") Long plantidx);

	List<MyDiaryDTO> selectByUserAndPlantSince(@Param("userId") String userId,
                 @Param("plantidx") Long plantidx,
                 @Param("since") Date since);
	
}

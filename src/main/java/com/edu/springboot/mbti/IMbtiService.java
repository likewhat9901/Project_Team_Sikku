package com.edu.springboot.mbti;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface IMbtiService {
	public List<MbtiDTO> MbtiSelectAll();
	public List<MbtiDTO> MbtiSelectOneByName(String mbtiName);
	public List<MbtiDTO> MbtiSelectDistinct();
}

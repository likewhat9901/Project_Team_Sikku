package com.edu.springboot.dict;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IDictService {
	public DictDTO selectOne(int plantidx);
	public List<DictDTO> selectAll();
	public List<DictDTO> selectPlantsByUser(@Param("userId") String userId);
}

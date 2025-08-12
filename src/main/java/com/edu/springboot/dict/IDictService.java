package com.edu.springboot.dict;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface IDictService {
	public DictDTO selectOne(int plantidx);
	public List<DictDTO> selectAll();
}

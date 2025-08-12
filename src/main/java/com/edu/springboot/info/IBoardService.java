package com.edu.springboot.info;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface IBoardService {
	public BoardDTO selectOne(int plant_idx);
	public List<BoardDTO> selectAll();
}

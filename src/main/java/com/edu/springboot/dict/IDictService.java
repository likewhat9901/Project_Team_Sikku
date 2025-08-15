package com.edu.springboot.dict;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IDictService {
	public DictDTO selectOne(int plantidx);
	public List<DictDTO> selectAll();
	public List<Integer> selectAllPlantidx();
	public List<DictDTO> selectPlantsByUser(@Param("userId") String userId);
	
	 // 관리자 기능
	void insertPlantDict(DictDTO dto);

    List<DictDTO> selectAllPlants();

    public int deletePlantDict(int plantidx);
}

package com.edu.springboot.dict;

import java.sql.Date;

import lombok.Data;

@Data
public class DictDTO {
	private Long plantidx;
	private String name;
	private String engname;
	private String category;
	private String imgpath;
	private String growseason;
	private String bloomingseason;
	private String sunlight;
	private String humidity;
	private String temperature;
	private String water;
	private String disease;
	private String summary;
	private String note;
	private Date postdate;
	private String feature;

}

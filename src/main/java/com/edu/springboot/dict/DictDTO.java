package com.edu.springboot.dict;

import java.sql.Date;

import lombok.Data;

@Data
public class DictDTO {
	private int plantidx;
	private String name;
	private String imgpath;
	private String summary;
	private String note;
	private String growseason;
	private String bloomingseason;
	private String humidity;
	private String sunlight;
	private int temperaturemin;
	private int temperaturemax;
	private Date postdate;
}

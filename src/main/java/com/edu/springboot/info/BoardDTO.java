package com.edu.springboot.info;

import java.sql.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private int plantidx;
	private String name;
	private String ofile;
	private String sfile;
	private String growseason;
	private String bloomingseason;
	private String humidity;
	private String sunlight;
	private int temperaturemin;
	private int temperaturemax;
	private Date postdate;
	private String userId;
	private String description;
}

package com.edu.springboot.info;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ParameterDTO {
	private int PLANTIDX;
	private String name;
	private String OFILE;
	private String SFILE;
	private String GROWSEASON;
	private String BLOOMINGSEASON;
	private String HUMIDITY;
	private String SUNLIGHT;
	private int TEMPERATUREMIN;
	private int TEMPERATUREMAX;
	private Date POSTDATE;
	private String userId;
	private String DESCRIPTION;
}

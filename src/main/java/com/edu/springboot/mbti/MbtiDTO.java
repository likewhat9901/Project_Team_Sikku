package com.edu.springboot.mbti;

import lombok.Data;

@Data
public class MbtiDTO {
	private int mbtiIdx;
	private String name;
	private String imgfile;
	private String indoor;
	private String inreason;
	private String outdoor;
	private String outreason;
	private String note;
}

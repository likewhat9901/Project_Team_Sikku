package com.edu.springboot.mbti;

import lombok.Data;

@Data
public class MbtiDTO {
	private int mbtiidx;
	private String name;
	private String imgFile;
	private String category;
	private String plants;
	private String character;
	private String growperiod;
	private String growenv;
	private String difflevel;
	private String reason;
}

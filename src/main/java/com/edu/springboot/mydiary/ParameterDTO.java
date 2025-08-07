package com.edu.springboot.mydiary;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ParameterDTO {
//	private String searchField;
//	private String searchKeyword;
	private int start;
	private int end;
	private String userId;
}

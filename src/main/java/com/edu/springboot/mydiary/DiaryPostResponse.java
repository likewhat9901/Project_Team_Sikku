package com.edu.springboot.mydiary;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
@AllArgsConstructor
public class DiaryPostResponse {
	// yyyy-MM-dd (db의 postdate)
    private String postdate;
    // sfile 값 (서버 파일명)
    private String imageUrl;
}

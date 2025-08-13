package com.edu.springboot.jpaboard;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;


@Service
public class BoardImageService {
	
	@Autowired
	private BoardImageRepository ir;
	
	//게시글과 첨부 파일 목록을 받아와서 서버와 DB에 저장
	public void saveBoardImage (BoardEntity board, List<MultipartFile> files,
											String uploadDir) throws IOException {
		
		
		List<BoardImageEntity> ilist = new ArrayList<>() ;
		
		for(MultipartFile file : files) {
			if(!file.isEmpty()) {
				String originalName = file.getOriginalFilename();
				String savedName = UUID.randomUUID() + "_" + originalName;
				
				/* 컨트롤러에서 설정한 경로 "classpath:static/uploads/board"로
				 이미지가 저장 안되는 이슈 발생. */
				// 파일 시스템 경로 구분자(File.separator)를 추가
				String filePath = uploadDir + File.separator + savedName;
				
				// 메모리에 임시로 올라와있던 file을 filePath로 이동시킨다.
				file.transferTo(new File(filePath));
				
				//이미지 엔티티 생성
				BoardImageEntity ie = BoardImageEntity.builder()
						.board(board)
						.originalName(originalName)
						.savedName(savedName)
						.filePath(filePath)
						.build();
				
				ilist.add(ie);
			}
		}
		
		ir.saveAll(ilist);
	}

	
	
}

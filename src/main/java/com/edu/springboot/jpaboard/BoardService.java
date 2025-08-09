package com.edu.springboot.jpaboard;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
public class BoardService {
	
	//DAO역할의 인터페이스
	@Autowired
	private BoardRepository br;
	
	
	
	// 목록 (검색어X)
	public Page<BoardEntity> selectList(Pageable pageable) {
		Page<BoardEntity> boardRows = br.findAll(pageable);
		return boardRows;
	}
	
	// 목록 (검색어O)
	public Page<BoardEntity> selectListSearch(String search, Pageable pageable) {
		Page<BoardEntity> boardRows = br.findByTitleLike(search, pageable);
		return boardRows;
	}
	
	// 상세보기
	public Optional<BoardEntity> selectPost(Long boardIdx) {
		Optional<BoardEntity> row = br.findById(boardIdx);
		
		//조회수 1증가시키고 저장
		BoardEntity be = row.get();
		int visitcount = (be.getVisitcount() == null) ? 0 : be.getVisitcount();
		be.setVisitcount(visitcount+1);
		br.save(be);
		
		return row;
	}
	
	// 글쓰기
	public void insertPost(BoardEntity be) {
		br.save(be);
	}
	
	
    //수정
    public void updatePost(BoardEntity be) {
        br.save(be);
    }

    //삭제
    public void deletePost(Long boardIdx) {
        br.deleteById(boardIdx);
    }

	
}
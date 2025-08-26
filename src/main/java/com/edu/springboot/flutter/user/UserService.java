package com.edu.springboot.flutter.user;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.edu.springboot.flutter.auth.JwtTokenProvider;
import com.edu.springboot.flutter.user.dto.ProfileResponse;
import com.edu.springboot.jpaboard.BoardEntity;
import com.edu.springboot.jpaboard.BoardRepository;
import com.edu.springboot.jpaboard.CommentRepository;
import com.edu.springboot.jpaboard.LikeRepository;
import com.edu.springboot.jpaboard.MemberEntity;
import com.edu.springboot.jpaboard.MemberRepository;
import com.edu.springboot.jpaboard.dto.LikedPostDto;
import com.edu.springboot.jpaboard.dto.MyCommentDto;


@Service
public class UserService {

	@Autowired
    private MemberRepository memberRepository;
	@Autowired
    private BoardRepository boardRepository;
	@Autowired
    private CommentRepository commentRepository;
	@Autowired
    private LikeRepository likeRepository;

	
    public ProfileResponse profile(String jwtToken) {
    	
    	// 1) 토큰 검증
        if (!JwtTokenProvider.validateToken(jwtToken)) {
            throw new IllegalArgumentException("Invalid or expired token");
        }

        // 2) 토큰에서 사용자 아이디 추출 (메소드명은 구현체에 맞게)
        String userId = JwtTokenProvider.getUseridFromToken(jwtToken);
        
        MemberEntity member = memberRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalStateException("User not found: " + userId));
    	
    	return ProfileResponse.fromEntity(member);
    }    
    
    public List<String> getLikedPostTitles(String jwtToken) {
        if (!JwtTokenProvider.validateToken(jwtToken)) {
            throw new IllegalArgumentException("Invalid or expired token");
        }

        String userId = JwtTokenProvider.getUseridFromToken(jwtToken);

        List<LikedPostDto> likedPosts = likeRepository.findLikedPostsByUser(userId);

        // 제목만 추출해서 리스트로
        return likedPosts.stream()
                    .map(c -> c.title())
                    .collect(Collectors.toList());
    }
    
    public List<String> getMyCommentContents(String jwtToken) {
        if (!JwtTokenProvider.validateToken(jwtToken)) {
            throw new IllegalArgumentException("Invalid or expired token");
        }

        String userId = JwtTokenProvider.getUseridFromToken(jwtToken);

        List<MyCommentDto> comments = commentRepository.findMyComments(userId);

        // 제목만 추출해서 리스트로
        return comments.stream()
                    .map(c -> c.content())
                    .collect(Collectors.toList());
    }
    
    public List<String> getMyPostTitles(String jwtToken) {
        if (!JwtTokenProvider.validateToken(jwtToken)) {
            throw new IllegalArgumentException("Invalid or expired token");
        }

        String userId = JwtTokenProvider.getUseridFromToken(jwtToken);

        List<BoardEntity> posts = boardRepository.findByUserId(userId);

        // 제목만 추출해서 리스트로
        return posts.stream()
                    .map(BoardEntity::getTitle)
                    .collect(Collectors.toList());
    }
}
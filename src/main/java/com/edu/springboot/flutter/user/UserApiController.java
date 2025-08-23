package com.edu.springboot.flutter.user;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edu.springboot.flutter.user.dto.ProfileResponse;


@RestController
@RequestMapping("/api/flutter")
public class UserApiController {
	
	@Autowired
	private UserService userService;

	@CrossOrigin(origins = "*")
    @GetMapping("/profile")
    public ResponseEntity<?> getProfile(@RequestHeader("Authorization") String token) {
		try {
			String pureToken = token.replace("Bearer ", "");
			
			ProfileResponse response = userService.profile(pureToken);
            return ResponseEntity.ok()
            		.header(HttpHeaders.CONTENT_TYPE, "application/json; charset=UTF-8")
            		.body(response);
		} catch (Exception e) {
			return ResponseEntity.status(401).body("인증 실패: " + e.getMessage());
		}
		
	}
	
	@GetMapping("/liked-posts")
	public ResponseEntity<?> getLikedPosts(@RequestHeader("Authorization") String token) {
	    try {
	        String pureToken = token.replace("Bearer ", "");
	        List<String> titles = userService.getLikedPostTitles(pureToken);
	        
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
	        
	        return new ResponseEntity<>(titles, headers, HttpStatus.OK);
	    } catch (Exception e) {
	        return ResponseEntity.status(401).body(List.of("error", e.getMessage()));
	    }
	}
	
	@GetMapping("/my-comments")
	public ResponseEntity<?> getMyComments(@RequestHeader("Authorization") String token) {
	    try {
	        String pureToken = token.replace("Bearer ", "");
	        List<String> comments = userService.getMyCommentContents(pureToken);
	        
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
	        
	        return new ResponseEntity<>(comments, headers, HttpStatus.OK);
	    } catch (Exception e) {
	        return ResponseEntity.status(401).body(List.of("error", e.getMessage()));
	    }
	}
	
	@GetMapping("/my-posts")
	public ResponseEntity<?> getMyPosts(@RequestHeader("Authorization") String token) {
	    try {
	        String pureToken = token.replace("Bearer ", "");
	        List<String> titles = userService.getMyPostTitles(pureToken);
	        
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
	        
	        return new ResponseEntity<>(titles, headers, HttpStatus.OK);
	    } catch (Exception e) {
	        return ResponseEntity.status(401).body(List.of("error", e.getMessage()));
	    }
	}
	
}

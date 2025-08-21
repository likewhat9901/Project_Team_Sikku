package com.edu.springboot.flutter.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.edu.springboot.flutter.auth.dto.LoginResponse;
import com.edu.springboot.flutter.auth.dto.RegisterRequest;
import com.edu.springboot.jpaboard.MemberEntity;
import com.edu.springboot.jpaboard.MemberRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

	@Autowired
    private MemberRepository memberRepository;
	@Autowired
	private PasswordEncoder passwordEncoder;

	
	
    public LoginResponse login(String userid, String userpw) {
        MemberEntity member = memberRepository.findByUserId(userid)
                .orElseThrow(() -> new RuntimeException("존재하지 않는 아이디입니다."));
        
        // ✅ bcrypt 비교 (userpw(raw) vs encoded)
        if (!passwordEncoder.matches(userpw, member.getUserpw())) {
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }
        
        String token = JwtTokenProvider.generateToken(member.getUserId());
        String username = member.getUsername();

        return new LoginResponse(token, username); // DTO로 반환
    }
    
    // 회원가입: 중복 체크 → 비번 인코딩 → 저장 → (선택) 토큰 발급
    public void register(RegisterRequest req) {
        // 1) 필수값 체크
        if (req.getUserid() == null || req.getUserid().isBlank()
                || req.getUserpw() == null || req.getUserpw().isBlank()) {
            throw new IllegalArgumentException("userid와 userpw는 필수입니다.");
        }

        // 2) 중복 체크
        if (memberRepository.findByUserId(req.getUserid()).isPresent()) {
            throw new IllegalStateException("이미 존재하는 아이디입니다.");
        }

        // 3) 비번 인코딩
        String encodedPw = passwordEncoder.encode(req.getUserpw());
        
        // 3-1) 전화번호 포맷 변환
        String rawPhone = req.getPhoneNumber(); // ex: "01012345678"
        String formattedPhone = rawPhone.replaceAll("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");


        // 4) 엔티티 생성/저장 (권한/상태 기본값 설정)
        MemberEntity member = new MemberEntity();
        member.setUserId(req.getUserid());
        member.setUserpw(encodedPw);
        member.setUsername(req.getUsername());
        member.setEmail(req.getEmail());
        member.setPhonenumber(formattedPhone);
        member.setAuthority("ROLE_USER");
        member.setEnabled(1);

        memberRepository.save(member);
    }
    
    // 회원가입 - 아이디 중복 확인 비즈니스 로직
    public boolean isUserIdAvailable(String userid) {
        return !memberRepository.existsByUserId(userid);  // 사용 가능 여부 반환
    }
}

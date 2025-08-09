package com.edu.springboot.auth;

import java.security.Principal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {
	
    @Autowired
    private DataSource dataSource;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;
    

    @RequestMapping("/signup.do")
    public String signup() {
        return "member/signup";
    }
    
    /* 마이페이지 추가*/
    @GetMapping("/mypage.do")
    public String myPage(Principal principal, Model model) {
        try {
            String userid = principal.getName();

            Connection conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT username, email FROM members WHERE userid = ?"
            );
            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String activityName = rs.getString("username");
                String email = rs.getString("email");

                model.addAttribute("username", activityName);
                model.addAttribute("email", email);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "member/mypage";  // JSP 경로
    }


    @RequestMapping("/admin/index.do")
    public String adminPage(Model model, Principal principal) {
        String userId = principal.getName(); // 여기서 로그인 정보 정상 획득
        model.addAttribute("userId", userId);
        return "admin"; 
    }
    
    @RequestMapping("/myLogin.do")
    public String login1(Principal principal, Model model) {
        try {
            String userid = principal.getName();
            model.addAttribute("userid", userid);

            Connection conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT username FROM members WHERE userid = ?"
            );
            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String activityName = rs.getString("username");
                model.addAttribute("username", activityName);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            System.out.println("로그인 전입니다");
        }
        return "member/login";
    }
    
    @RequestMapping("/signupAction.do")
    public String signupAction(@RequestParam("userid") String userid,
            @RequestParam("userpw") String userpw,
            @RequestParam("userpw_confirm") String userpw_confirm,
            @RequestParam("username") String username,
            @RequestParam("phone1") String phone1,
            @RequestParam("phone2") String phone2,
            @RequestParam("phone3") String phone3,
            @RequestParam("email_id") String email_id,
            @RequestParam("email_domain") String email_domain,
            @RequestParam(value = "address", required = false) String address,
            Model model) {

        String email = email_id + "@" + email_domain;
        String phonenumber = phone1 + "-" + phone2 + "-" + phone3;

        // 1. 비밀번호 일치 여부 확인
        if (!userpw.equals(userpw_confirm)) {
            model.addAttribute("pwError", "비밀번호가 일치하지 않습니다.");
            return "member/signup";
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = dataSource.getConnection();

            // 2. 아이디 중복 확인
            String checkIdSql = "SELECT COUNT(*) FROM members WHERE userid = ?";
            ps = conn.prepareStatement(checkIdSql);
            ps.setString(1, userid);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                model.addAttribute("idError", "이미 존재하는 아이디입니다.");
                return "auth/signup";
            }
            rs.close();
            ps.close();

            // 3. 이메일 중복 확인
            if (email != null && !email.isEmpty()) {
                String checkEmailSql = "SELECT COUNT(*) FROM members WHERE email = ?";
                ps = conn.prepareStatement(checkEmailSql);
                ps.setString(1, email);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    model.addAttribute("emailError", "이미 사용 중인 이메일입니다.");
                    return "auth/signup";
                }
                rs.close();
                ps.close();
            }

            // 4. 활동명 중복 확인
            String checkActivitySql = "SELECT COUNT(*) FROM members WHERE username = ?";
            ps = conn.prepareStatement(checkActivitySql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                model.addAttribute("activityNameError", "이미 사용 중인 활동명입니다.");
                return "member/signup";
            }
            rs.close();
            ps.close();
            
            //5. 전화번호 중복 확인
            String checkPhoneSql = "SELECT COUNT(*) FROM members WHERE phonenumber = ?";
            ps = conn.prepareStatement(checkPhoneSql);
            ps.setString(1, phonenumber);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                model.addAttribute("phoneError", "중복된 번호가 존재합니다.");
                return "member/signup";
            }
            rs.close();
            ps.close();

            // 6. 비밀번호 암호화
            String encodedPassword = bCryptPasswordEncoder.encode(userpw);

            // 7. 회원 정보 저장
            String insertSql = "INSERT INTO members (userid, userpw, authority, enabled, " +
                               "username, phonenumber, email, address) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertSql);
            ps.setString(1, userid);
            ps.setString(2, encodedPassword);
            ps.setString(3, "ROLE_USER");
            ps.setInt(4, 1);
            ps.setString(5, username);
            ps.setString(6, phonenumber);
            ps.setString(7, email);
            ps.setString(8, address);

            ps.executeUpdate();

            return "redirect:/myLogin.do";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("signupError", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
            return "member/signup";
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
         
        }
    }
	
}

package com.edu.springboot.auth;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;

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

    @GetMapping("/mypage.do")
    public String myPage(Principal principal, Model model, HttpSession session) {
        try {
            String userid = principal.getName();
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT username, email, profileImgPath FROM members WHERE userid = ?")) {
                ps.setString(1, userid);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        model.addAttribute("username", rs.getString("username"));
                        model.addAttribute("email", rs.getString("email"));
                        String path = rs.getString("profileImgPath");
                        model.addAttribute("profileImgPath", path);
                        if (path != null && !path.isEmpty()) {
                            session.setAttribute("profileImgPath", path); // ★ 세션에도 넣어 전역 사용
                        } else {
                            session.removeAttribute("profileImgPath");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        model.addAttribute("timestamp", System.currentTimeMillis());
        return "member/mypage";
    }

    // ⬇️ 업로드: JSON으로 새 경로 반환 + 세션 갱신
    @PostMapping("/mypage/uploadProfile")
    public ResponseEntity<Map<String, String>> uploadProfile(
            @RequestParam("profileImage") MultipartFile file,
            Principal principal,
            HttpSession session) {

        String userid = principal.getName();

        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        try {
            String uploadDir = WebConfig.UPLOAD_ROOT;
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            // 유니크 파일명
            String ext = Optional.ofNullable(file.getOriginalFilename())
                    .filter(n -> n.contains("."))
                    .map(n -> n.substring(n.lastIndexOf(".")))
                    .orElse("");
            String fileName = userid + "_" + System.currentTimeMillis() + ext;

            Path filePath = Paths.get(uploadDir, fileName);
            Files.write(filePath, file.getBytes());

            // 웹 접근 경로
            String dbPath = "/uploads/profile/" + fileName;

            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE members SET profileImgPath = ? WHERE userid = ?")) {
                ps.setString(1, dbPath);
                ps.setString(2, userid);
                ps.executeUpdate();
            }

            //세션 갱신
            session.setAttribute("profileImgPath", dbPath);

            Map<String, String> body = new HashMap<>();
            body.put("path", dbPath);
            return ResponseEntity.ok(body);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    @PostMapping("/mypage/resetProfile")
    public String resetProfile(Principal principal, Model model, HttpSession session) {
        try {
            String userid = principal.getName();
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "UPDATE members SET profileImgPath = NULL WHERE userid = ?")) {
                ps.setString(1, userid);
                ps.executeUpdate();
            }
            // 세션 정리
            session.removeAttribute("profileImgPath");
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "기본 이미지로 변경 중 오류 발생");
            return myPage(principal, model, session);
        }
        return "redirect:/mypage.do";
    }

    @GetMapping("/mypageEdit.do")
    public String mypageEdit(Principal principal, Model model) {
        try {
            String userid = principal.getName();
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT username, phonenumber, email FROM members WHERE userid = ?")) {
                ps.setString(1, userid);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        model.addAttribute("username", rs.getString("username"));
                        model.addAttribute("email", rs.getString("email"));
                        String phone = rs.getString("phonenumber");
                        if (phone != null) {
                            phone = phone.replaceAll("-", "");
                            if (phone.length() == 11) {
                                model.addAttribute("phone1", phone.substring(0, 3));
                                model.addAttribute("phone2", phone.substring(3, 7));
                                model.addAttribute("phone3", phone.substring(7));
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "member/mypageEdit";
    }

    @PostMapping("/mypage/profileAction")
    public String handleProfileAction(
            @RequestParam("action") String action,
            @RequestParam(value = "profileImage", required = false) MultipartFile file,
            Principal principal,
            Model model,
            HttpSession session) {

        if ("upload".equals(action)) {
            return "redirect:/mypage.do";
        } else if ("reset".equals(action)) {
            return resetProfile(principal, model, session);
        }
        return "redirect:/mypage.do";
    }

    /* 회원 수정 + 중복 처리 */
    @RequestMapping("/mypageEditAction.do")
    public String updateUserInfo(
            Principal principal,
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam(value = "newPassword", required = false) String newPassword,
            @RequestParam("username") String username,
            @RequestParam("phone1") String phone1,
            @RequestParam("phone2") String phone2,
            @RequestParam("phone3") String phone3,
            @RequestParam("email") String email,
            Model model) {

        String userid = principal.getName();
        String phonenumber = phone1 + "-" + phone2 + "-" + phone3;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = dataSource.getConnection();
            ps = conn.prepareStatement(
                    "SELECT userpw, username, phonenumber, email FROM members WHERE userid = ?");
            ps.setString(1, userid);
            rs = ps.executeQuery();

            String currentUsername = null;
            String currentPhone = null;
            String currentEmail = null;
            String storedPassword = null;

            if (rs.next()) {
                storedPassword = rs.getString("userpw");
                currentUsername = rs.getString("username");
                currentPhone = rs.getString("phonenumber");
                currentEmail = rs.getString("email");
            } else {
                model.addAttribute("errorMsg", "사용자 정보를 찾을 수 없습니다.");
                return mypageEdit(principal, model);
            }
            rs.close();
            ps.close();

            if (!bCryptPasswordEncoder.matches(currentPassword, storedPassword)) {
                model.addAttribute("errorMsg", "현재 비밀번호가 일치하지 않습니다.");
                return mypageEdit(principal, model);
            }

            if (!username.equals(currentUsername)) {
                ps = conn.prepareStatement(
                        "SELECT COUNT(*) FROM members WHERE username = ? AND userid != ?");
                ps.setString(1, username);
                ps.setString(2, userid);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    model.addAttribute("errorMsg", "이미 사용 중인 활동명입니다.");
                    return mypageEdit(principal, model);
                }
                rs.close();
                ps.close();
            }

            if (!phonenumber.equals(currentPhone)) {
                ps = conn.prepareStatement(
                        "SELECT COUNT(*) FROM members WHERE phonenumber = ? AND userid != ?");
                ps.setString(1, phonenumber);
                ps.setString(2, userid);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    model.addAttribute("errorMsg", "이미 사용 중인 전화번호입니다.");
                    return mypageEdit(principal, model);
                }
                rs.close();
                ps.close();
            }

            if (!email.equals(currentEmail)) {
                ps = conn.prepareStatement(
                        "SELECT COUNT(*) FROM members WHERE email = ? AND userid != ?");
                ps.setString(1, email);
                ps.setString(2, userid);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    model.addAttribute("errorMsg", "이미 사용 중인 이메일입니다.");
                    return mypageEdit(principal, model);
                }
                rs.close();
                ps.close();
            }

            String updateSql;
            if (newPassword != null && !newPassword.isEmpty()) {
                String encodedPw = bCryptPasswordEncoder.encode(newPassword);
                updateSql = "UPDATE members SET userpw = ?, username = ?, phonenumber = ?, email = ? WHERE userid = ?";
                ps = conn.prepareStatement(updateSql);
                ps.setString(1, encodedPw);
                ps.setString(2, username);
                ps.setString(3, phonenumber);
                ps.setString(4, email);
                ps.setString(5, userid);
            } else {
                updateSql = "UPDATE members SET username = ?, phonenumber = ?, email = ? WHERE userid = ?";
                ps = conn.prepareStatement(updateSql);
                ps.setString(1, username);
                ps.setString(2, phonenumber);
                ps.setString(3, email);
                ps.setString(4, userid);
            }
            ps.executeUpdate();
            return "redirect:/mypage.do";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "수정 중 오류 발생: " + e.getMessage());
            return mypageEdit(principal, model);
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

    @RequestMapping("/admin/index.do")
    public String adminPage(Model model, Principal principal) {
        String userId = principal.getName();
        model.addAttribute("userId", userId);
        return "admin";
    }

    @RequestMapping("/myLogin.do")
    public String login1(Principal principal, Model model, HttpSession session) {
        try {
            String userid = principal.getName();
            model.addAttribute("userid", userid);

            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT username, profileImgPath FROM members WHERE userid = ?")) {
                ps.setString(1, userid);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String activityName = rs.getString("username");
                        String path = rs.getString("profileImgPath");
                        model.addAttribute("username", activityName);

                        // 세션에 프로필 경로 반영
                        if (path != null && !path.isEmpty()) {
                            session.setAttribute("profileImgPath", path);
                        } else {
                            session.removeAttribute("profileImgPath");
                        }
                    }
                }
            }
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

        if (!userpw.equals(userpw_confirm)) {
            model.addAttribute("pwError", "비밀번호가 일치하지 않습니다.");
            return "member/signup";
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = dataSource.getConnection();

            // 아이디 중복
            ps = conn.prepareStatement("SELECT COUNT(*) FROM members WHERE userid = ?");
            ps.setString(1, userid);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                model.addAttribute("idError", "이미 존재하는 아이디입니다.");
                return "member/signup";
            }
            rs.close(); ps.close();

            // 이메일 중복
            if (email != null && !email.isEmpty()) {
                ps = conn.prepareStatement("SELECT COUNT(*) FROM members WHERE email = ?");
                ps.setString(1, email);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    model.addAttribute("emailError", "이미 사용 중인 이메일입니다.");
                    return "member/signup";
                }
                rs.close(); ps.close();
            }

            // 활동명 중복
            ps = conn.prepareStatement("SELECT COUNT(*) FROM members WHERE username = ?");
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                model.addAttribute("activityNameError", "이미 사용 중인 활동명입니다.");
                return "member/signup";
            }
            rs.close(); ps.close();

            // 전화번호 중복
            ps = conn.prepareStatement("SELECT COUNT(*) FROM members WHERE phonenumber = ?");
            ps.setString(1, phonenumber);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                model.addAttribute("phoneError", "중복된 번호가 존재합니다.");
                return "member/signup";
            }
            rs.close(); ps.close();

            // 비밀번호 암호화
            String encodedPassword = bCryptPasswordEncoder.encode(userpw);

            // 저장
            ps = conn.prepareStatement(
                "INSERT INTO members (userid, userpw, authority, enabled, username, phonenumber, email, address) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
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

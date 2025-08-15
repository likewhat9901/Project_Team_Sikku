package com.edu.springboot;

import java.security.Principal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.edu.springboot.dict.DictDTO;
import com.edu.springboot.dict.IDictService;

@Controller
public class MainController {

    @Autowired
    IDictService dao;

    @Autowired
    private DataSource dataSource;

    @RequestMapping("/")
    public String main() {
        return "intro/about";
    }

    @GetMapping("/main/member.do")
    public String member(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = auth.getName();
        List<DictDTO> plants = dao.selectPlantsByUser(userId);
        model.addAttribute("plants", plants);
        return "main/member";
    }

    @GetMapping("/main/nonMember.do")
    public String nonMember() {
        return "main/nonMember";
    }

    @GetMapping("/dict/callback")
    public String ajax_local_callback() {
        return "dict/ajax_local_callback";
    }

    @RequestMapping("/admin/index.do")
    public String adminPage(
            @RequestParam(value = "searchUserId", required = false) String searchUserId,
            Model model,
            Principal principal) {

        String userId = principal.getName();
        model.addAttribute("userId", userId);

        // ===== 회원 목록 =====
        String sql = "SELECT userid, username, phonenumber, email, authority, enabled FROM members";
        if (searchUserId != null && !searchUserId.trim().isEmpty()) {
            sql += " WHERE userid LIKE ?";
        }
        sql += " ORDER BY userid";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (searchUserId != null && !searchUserId.trim().isEmpty()) {
                ps.setString(1, "%" + searchUserId + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> members = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("userid", rs.getString("userid"));
                    m.put("username", rs.getString("username"));
                    m.put("phonenumber", rs.getString("phonenumber"));
                    m.put("email", rs.getString("email"));
                    m.put("authority", rs.getString("authority"));
                    m.put("enabled", rs.getInt("enabled"));
                    members.add(m);
                }
                model.addAttribute("members", members);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "회원 목록 불러오기 실패");
        }

        // ===== 신고된 게시글 목록 (최신 1건)=====
        String reportSql =
                "SELECT b.boardidx, b.userid, b.title, " +
                "       (SELECT COUNT(*) FROM board_report r WHERE r.board_idx = b.boardidx) AS reportCount, " +
                "       (SELECT content FROM board_report r WHERE r.board_idx = b.boardidx ORDER BY r.report_date DESC FETCH FIRST 1 ROWS ONLY) AS content " +
                "FROM hboard b " +
                "WHERE b.boardidx IN (SELECT board_idx FROM board_report) " +
                "ORDER BY reportCount DESC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(reportSql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String, Object>> reportedPosts = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("boardIdx", rs.getLong("boardidx"));
                post.put("userId", rs.getString("userid"));
                post.put("title", rs.getString("title"));
                post.put("reportCount", rs.getInt("reportCount"));
                post.put("content", rs.getString("content")); 
                reportedPosts.add(post);
            }

            model.addAttribute("reportedPosts", reportedPosts);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "신고 게시글 조회 실패: " + e.getMessage());
        }

        return "admin/admin";
    }

    // ===== 회원 비활성화 =====
    @RequestMapping("/admin/disableMember.do")
    public String disableMember(@RequestParam("userid") String userid, RedirectAttributes redirectAttrs) {
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE members SET enabled = 0 WHERE userid = ?")) {

            ps.setString(1, userid);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                redirectAttrs.addFlashAttribute("successMsg", "회원이 비활성화되었습니다.");
            } else {
                redirectAttrs.addFlashAttribute("errorMsg", "해당 회원을 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "회원 비활성화 중 오류: " + e.getMessage());
        }
        return "redirect:/admin/index.do";
    }

    // ===== 회원 활성화 =====
    @RequestMapping("/admin/enableMember.do")
    public String enableMember(@RequestParam("userid") String userid, RedirectAttributes redirectAttrs) {
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE members SET enabled = 1 WHERE userid = ?")) {

            ps.setString(1, userid);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                redirectAttrs.addFlashAttribute("successMsg", "회원이 활성화되었습니다.");
            } else {
                redirectAttrs.addFlashAttribute("errorMsg", "해당 회원을 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "회원 활성화 중 오류: " + e.getMessage());
        }
        return "redirect:/admin/index.do";
    }

    // ===== 회원 권한 변경 =====
    @RequestMapping("/admin/changeAuthority.do")
    public String changeAuthority(
            @RequestParam("userid") String userid,
            @RequestParam("authority") String authority,
            RedirectAttributes redirectAttrs) {

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE members SET authority = ? WHERE userid = ?")) {

            ps.setString(1, authority);
            ps.setString(2, userid);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                redirectAttrs.addFlashAttribute("successMsg", "회원 권한이 변경되었습니다.");
            } else {
                redirectAttrs.addFlashAttribute("errorMsg", "해당 회원을 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "권한 변경 중 오류: " + e.getMessage());
        }

        return "redirect:/admin/index.do";
    }
}

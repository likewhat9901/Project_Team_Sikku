 package com.edu.springboot;

import java.nio.file.*;
import java.security.Principal;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.edu.springboot.dict.DictDTO;
import com.edu.springboot.dict.IDictService;

@Controller
public class MainController {

    @Autowired
    private IDictService dao;

    @Autowired
    private DataSource dataSource;

    @RequestMapping("/")
    public String main() {
        return "intro/about";
    }

    @GetMapping("/main/member.do")
    public String member(Model model, Principal principal) {
        String userId = principal.getName();
        List<DictDTO> plants = dao.selectPlantsByUser(userId);
        model.addAttribute("plants", plants);
        return "main/member";
    }

    @GetMapping("/main/nonMember.do")
    public String nonMember() {
        return "main/nonMember";
    }

    @RequestMapping("/admin/index.do")
    public String adminPage(
            @RequestParam(value = "searchUserId", required = false) String searchUserId,
            Model model,
            Principal principal) {

        String userId = principal.getName();
        model.addAttribute("userId", userId);

        // 회원 목록
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

        // 신고 게시글
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

        // 식물도감 리스트
        try {
            List<DictDTO> plantList = dao.selectAll();
            model.addAttribute("plantList", plantList);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "식물도감 불러오기 실패: " + e.getMessage());
        }

        return "admin/admin";
    }

    // 🌱 식물도감 등록 (리다이렉트 방식)
    @PostMapping("/admin/dict/insert.do")
    public String insertPlantDict(
            DictDTO dto,
            @RequestParam("image") MultipartFile image,
            RedirectAttributes redirectAttrs) {

        try {
            long newIdx = dao.getMaxPlantIdx() + 1;
            dto.setPlantidx(newIdx);

            // 이미지 저장
            Path uploadRoot = Paths.get(new ClassPathResource("static/images/dict").getFile().getAbsolutePath());
            Files.createDirectories(uploadRoot);

            String ext = "";
            String original = image.getOriginalFilename();
            if (original != null && original.contains(".")) {
                ext = original.substring(original.lastIndexOf("."));
            }
            String savedName = "dict_" +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss_SSS")) + ext;

            Files.copy(image.getInputStream(),
                    uploadRoot.resolve(savedName),
                    StandardCopyOption.REPLACE_EXISTING);

            dto.setImgpath(savedName);
            dao.insertPlantDict(dto);

            redirectAttrs.addFlashAttribute("successMsg", "식물 등록 완료!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "등록 실패: " + e.getMessage());
        }

        return "redirect:/admin/index.do";
    }

    // 🌱 식물도감 삭제
    @PostMapping("/admin/deletePlantDict.do")
    public String deletePlantDict(@RequestParam("plantidx") int plantidx) {
        dao.deletePlantDict(plantidx);
        return "redirect:/admin/index.do";
    }

    // 👤 회원 비활성화
    @RequestMapping("/admin/disableMember.do")
    public String disableMember(@RequestParam("userid") String userid, RedirectAttributes redirectAttrs) {
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE members SET enabled = 0 WHERE userid = ?")) {

            ps.setString(1, userid);
            int rows = ps.executeUpdate();

            if (rows > 0) redirectAttrs.addFlashAttribute("successMsg", "회원이 비활성화되었습니다.");
            else redirectAttrs.addFlashAttribute("errorMsg", "해당 회원을 찾을 수 없습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "회원 비활성화 중 오류: " + e.getMessage());
        }
        return "redirect:/admin/index.do";
    }

    // 👤 회원 활성화
    @RequestMapping("/admin/enableMember.do")
    public String enableMember(@RequestParam("userid") String userid, RedirectAttributes redirectAttrs) {
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE members SET enabled = 1 WHERE userid = ?")) {

            ps.setString(1, userid);
            int rows = ps.executeUpdate();

            if (rows > 0) redirectAttrs.addFlashAttribute("successMsg", "회원이 활성화되었습니다.");
            else redirectAttrs.addFlashAttribute("errorMsg", "해당 회원을 찾을 수 없습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "회원 활성화 중 오류: " + e.getMessage());
        }
        return "redirect:/admin/index.do";
    }

    // 👤 회원 권한 변경
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

            if (rows > 0) redirectAttrs.addFlashAttribute("successMsg", "회원 권한이 변경되었습니다.");
            else redirectAttrs.addFlashAttribute("errorMsg", "해당 회원을 찾을 수 없습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "권한 변경 중 오류: " + e.getMessage());
        }

        return "redirect:/admin/index.do";
    }
}

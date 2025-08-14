package com.edu.springboot.mydiary;


import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class PlantMetricsService {

 @Autowired
 private IMyDiaryMapper diaryMapper;

 public Map<Long, PlantMetrics> buildMetrics(String userId, List<Long> plantIdxs) {
     Map<Long, PlantMetrics> out = new HashMap<>();
     for (Long pid : plantIdxs) {
         MyDiaryDTO latest = diaryMapper.selectLatestByUserAndPlant(userId, pid);
         if (latest == null) continue;

         LocalDate latestDate = latest.getPostdate().toLocalDate();
         LocalDate since = latestDate.minusDays(35); // 최근 5주치로 계산
         List<MyDiaryDTO> rows = diaryMapper.selectByUserAndPlantSince(
                 userId, pid, Date.valueOf(since));

         // 안전 처리: 날짜 오름차순 정렬 보장
         rows = rows.stream()
                    .sorted(Comparator.comparing(MyDiaryDTO::getPostdate))
                    .collect(Collectors.toList());

         PlantMetrics m = new PlantMetrics();
         m.setPlantidx(pid);
         m.setLatestDate(Date.valueOf(latestDate));
         m.setLatestHeight(safeF(latest.getHeight()));
         m.setLatestFruit(safeI(latest.getFruit()));

         // 기준일 가까운 값 찾기 (가장 가까운 날짜의 기록)
         Float h7 = nearestHeight(rows, latestDate.minusDays(7));
         Float h30 = nearestHeight(rows, latestDate.minusDays(30));
         Integer f7 = nearestFruit(rows, latestDate.minusDays(7));

         if (m.getLatestHeight() != null && h7 != null) {
             m.setDeltaHeight7d(m.getLatestHeight() - h7);
         }
         if (m.getLatestHeight() != null && h30 != null) {
             m.setDeltaHeight30d(m.getLatestHeight() - h30);
         }
         if (m.getLatestFruit() != null && f7 != null) {
             m.setDeltaFruit7d(m.getLatestFruit() - f7);
         }

         // 주간 평균 열매 증가 (최근 4주)
         m.setWeeklyAvgFruitInc(calcWeeklyAvgFruitInc(rows, latestDate));

         out.put(pid, m);
     }
     return out;
 }

 private static Float nearestHeight(List<MyDiaryDTO> rows, LocalDate target) {
     MyDiaryDTO nearest = nearestByDate(rows, target);
     return nearest != null ? safeF(nearest.getHeight()) : null;
 }
 private static Integer nearestFruit(List<MyDiaryDTO> rows, LocalDate target) {
     MyDiaryDTO nearest = nearestByDate(rows, target);
     return nearest != null ? safeI(nearest.getFruit()) : null;
 }
 private static MyDiaryDTO nearestByDate(List<MyDiaryDTO> rows, LocalDate target) {
     return rows.stream().min(Comparator.comparingLong(r -> {
         long d = Math.abs(r.getPostdate().toLocalDate().toEpochDay() - target.toEpochDay());
         return d;
     })).orElse(null);
 }

 private static Double calcWeeklyAvgFruitInc(List<MyDiaryDTO> rows, LocalDate latestDate) {
     // 최근 28일 범위 내에서, 7일 간격 변화의 평균
     LocalDate since = latestDate.minusDays(28);
     List<MyDiaryDTO> window = rows.stream()
             .filter(r -> !r.getPostdate().toLocalDate().isBefore(since))
             .collect(Collectors.toList());
     if (window.size() < 2) return null;

     // 일자별 마지막 값으로 맵 (하루에 여러개면 마지막만)
     Map<LocalDate, Integer> lastFruitPerDay = new TreeMap<>();
     for (MyDiaryDTO r : window) {
         lastFruitPerDay.put(r.getPostdate().toLocalDate(), safeI(r.getFruit()));
     }
     // 7일 간격으로 샘플: since, since+7, since+14, since+21, latest
     List<LocalDate> points = Arrays.asList(
             since, since.plusDays(7), since.plusDays(14), since.plusDays(21), latestDate
     );
     List<Integer> vals = new ArrayList<>();
     for (LocalDate p : points) {
         Integer v = nearestFruit(rows, p);
         if (v == null) return null; // 데이터 부족
         vals.add(v);
     }
     // 구간 증가량 평균 (4구간)
     double sum = 0;
     int cnt = 0;
     for (int i = 1; i < vals.size(); i++) {
         sum += (vals.get(i) - vals.get(i-1));
         cnt++;
     }
     if (cnt == 0) return null;
     return sum / cnt;
 }

 private static Float safeF(Float f) { return f; }
 private static Integer safeI(Integer i) { return i; }
}

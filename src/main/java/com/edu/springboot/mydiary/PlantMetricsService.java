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

         Float h7  = heightAtOrBefore(rows, latestDate.minusDays(7));
         Float h30 = heightAtOrBefore(rows, latestDate.minusDays(30));
         Integer f7 = fruitAtOrBefore(rows, latestDate.minusDays(7));
         
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

 private static Float heightAtOrBefore(List<MyDiaryDTO> rows, LocalDate target) {
    MyDiaryDTO r = latestOnOrBefore(rows, target);
    return r != null ? safeF(r.getHeight()) : null;
}
private static Integer fruitAtOrBefore(List<MyDiaryDTO> rows, LocalDate target) {
    MyDiaryDTO r = latestOnOrBefore(rows, target);
    return r != null ? safeI(r.getFruit()) : null;
}

private static MyDiaryDTO latestOnOrBefore(List<MyDiaryDTO> rows, LocalDate target) {
	// rows는 오름차순 정렬되어 있음
    MyDiaryDTO candidate = null;
    for (MyDiaryDTO r : rows) {
        LocalDate d = r.getPostdate().toLocalDate();
        if (d.isAfter(target)) break;   // target 넘으면 종료
        candidate = r;                  // 조건 만족하면 일단 갱신
    }
    return candidate; // 없으면 null
}

private static Double calcWeeklyAvgFruitInc(List<MyDiaryDTO> rows, LocalDate latestDate) {
    // 최근 28일 기준 4구간 평균 증가량
    LocalDate since = latestDate.minusDays(28);
    // 최소한 기준점(since) 이전 기록이 있어야 의미가 있음
    // (rows는 이미 latestDate-35일 이후만 들어오므로 충분함)

    List<LocalDate> points = Arrays.asList(
        since, since.plusDays(7), since.plusDays(14), since.plusDays(21), latestDate
    );

    List<Integer> vals = new ArrayList<>(points.size());
    for (LocalDate p : points) {
        Integer v = fruitAtOrBefore(rows, p); // 핵심: ≤ p
        if (v == null) return null;           // 기준점 부족하면 null로
        vals.add(v);
    }

    double sum = 0;
    for (int i = 1; i < vals.size(); i++) sum += (vals.get(i) - vals.get(i - 1));
    return sum / 4.0; // 4구간 평균
}


 private static Float safeF(Float f) { return f; }
 private static Integer safeI(Integer i) { return i; }
}

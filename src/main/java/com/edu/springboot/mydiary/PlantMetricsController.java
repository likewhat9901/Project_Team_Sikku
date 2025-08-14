package com.edu.springboot.mydiary;


import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/mydiary")
public class PlantMetricsController {

 @Autowired
 private PlantMetricsService metricsService;

 @GetMapping("/metrics")
 public Map<Long, PlantMetrics> getMetrics(@RequestParam("plantidx") String plantIdxCsv) {
     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
     String userId = auth.getName();

     List<Long> ids = Arrays.stream(plantIdxCsv.split(","))
             .map(String::trim)
             .filter(s -> !s.isEmpty())
             .map(Long::valueOf)
             .distinct()
             .collect(Collectors.toList());

     return metricsService.buildMetrics(userId, ids);
 }
}

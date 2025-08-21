package utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtils {

    /**
     * LocalDateTime을 오늘 작성 여부에 따라 "HH:mm" 또는 "yyyy-MM-dd" 형식으로 포맷팅.
     *
     * @param dateTime 포맷팅할 LocalDateTime 객체
     * @return 포맷팅된 날짜/시간 문자열
     */
	
    public static String formatPostDate(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }

        LocalDate postDate = dateTime.toLocalDate();
        LocalDate today = LocalDate.now();

        if (postDate.isEqual(today)) {
            return dateTime.format(DateTimeFormatter.ofPattern("HH:mm"));
        } else {
            return dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
    }
}

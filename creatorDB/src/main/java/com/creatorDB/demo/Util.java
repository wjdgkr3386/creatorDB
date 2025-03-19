package com.creatorDB.demo;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;

public class Util {

	//크리에티트 맵배열을 받아와 마지막 업데이트가 24x7 시간이 지난 맵은 elapsedId라는 key속성을 추가시키고 value값에 CHANNEL_ID를 저장하는 메서드
	public static void timeElapses(List<Map<String, Object>> creatorList) {
        LocalDateTime now = LocalDateTime.now();
		
		if(creatorList==null) {
			return;
		}else {
			int listSize = creatorList.size();
			for(int i=0; i<listSize; i++) {
				Timestamp timestamp = (Timestamp) creatorList.get(i).get("LAST_UPDATE");
				LocalDateTime last_update = timestamp.toLocalDateTime();
				long hoursBetween = ChronoUnit.HOURS.between(last_update, now);
				
				if(hoursBetween>=7*24) {
					String chennelId = (String) creatorList.get(i).get("CHANNEL_ID");
					creatorList.get(i).put("elapsedId", chennelId);
				}
			}
		}
	}//timeElapses 종료
}

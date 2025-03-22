package com.creatorDB.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

//서버가 실행될때 같이 실행되는 클래스
//환경변수의 값을 가져옴
@Component
public class EnvRunner implements CommandLineRunner {

	// 환경변수가 없으면 "환경변수 없음" 출력
    @Value("${CLIENT_ID:환경변수 없음}")
    private String CLIENT_ID;
    
    @Value("${CLIENT_SECRET:환경변수 없음}")
    private String CLIENT_SECRET;
    
    @Value("${API_KEY:환경변수 없음}")
    private String API_KEY;

    @Override
    public void run(String... args) {
    }
    
    public String getCLIENT_ID() {
    	return CLIENT_ID;
    }
    
    public String getCLIENT_SECRET() {
    	return CLIENT_SECRET;
    }
    
    public String getAPI_KEY() {
    	return API_KEY;
    }
    
    
}
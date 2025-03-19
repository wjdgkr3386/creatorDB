package com.creatorDB.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

//서버가 실행될때 같이 실행되는 클래스
@Component
public class EnvTestRunner implements CommandLineRunner {

	// 환경변수가 없으면 "환경변수 없음" 출력
    @Value("${CLIENT_ID:환경변수 없음}")
    private String CLIENT_ID;
    
    @Value("${CLIENT_SECRET:환경변수 없음}")
    private String CLIENT_SECRET;

    @Override
    public void run(String... args) {
    }
    
    public String getCLIENT_ID() {
    	return CLIENT_ID;
    }
    
    public String getCLIENT_SECRET() {
    	return CLIENT_SECRET;
    }
}
package com.creatorDB.demo;

import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.google.api.client.util.Value;


//로그인 누르면 리다이렉트로 access_token 받는 컨트롤러
@RestController
@RequestMapping("/auth/google")
public class GoogleOAuthController {
	
    private final EnvRunner envRunner;

    // 생성자 주입 (Spring이 관리하는 Bean을 주입)
    public GoogleOAuthController(EnvRunner envRunner) {
        this.envRunner = envRunner;
    }
    
    private static final String REDIRECT_URI = "http://localhost:8081/auth/google/callback";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";

    
    @GetMapping("/callback")
    public void googleCallback(
    		@RequestParam("code") String code,
    		HttpServletResponse response,
    		HttpSession session
    ) throws Exception {
        RestTemplate restTemplate = new RestTemplate();
        // Spring이 관리하는 Bean을 통해 환경변수 가져오기
        String CLIENT_ID = envRunner.getCLIENT_ID();
        String CLIENT_SECRET = envRunner.getCLIENT_SECRET();
         
        // Google OAuth 토큰 요청을 위한 파라미터
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        String requestBody = "code=" + code +
                "&client_id=" + CLIENT_ID +
                "&client_secret=" + CLIENT_SECRET +
                "&redirect_uri=" + REDIRECT_URI +
                "&grant_type=authorization_code";

        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

        // Google OAuth 서버에 POST 요청하여 액세스 토큰 받기
        ResponseEntity<Map> tokenResponse = restTemplate.exchange(TOKEN_URL, HttpMethod.POST, entity, Map.class);

        // 정상적으로 access_token을 받았는지 확인
        if (tokenResponse.getBody() != null && tokenResponse.getBody().get("access_token") != null) {
            String accessToken = tokenResponse.getBody().get("access_token").toString();
        	session.setAttribute("access_token", accessToken);
            response.sendRedirect("http://localhost:8081/main.do");
            return;
        }

        // 로그인 실패 시 에러 페이지로 리디렉트
        response.sendRedirect("http://localhost:8081/error");
    }
}

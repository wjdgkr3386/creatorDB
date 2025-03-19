<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제목</title>
<script src="https://accounts.google.com/gsi/client" defer></script>
<script>
$(function(){init();});
function init(){}



function googleLogin() {
	const CLIENT_ID = "832181180340-d37u0elgunv0pq59cdjq2vkd6l4o0uat.apps.googleusercontent.com";
	const REDIRECT_URI = "http://localhost:8081/auth/google/callback";
    const authUrl = `https://accounts.google.com/o/oauth2/v2/auth?` +
        `client_id=`+ CLIENT_ID +
        `&redirect_uri=`+ encodeURIComponent(REDIRECT_URI) +
        `&response_type=code` +
        `&scope=openid%20email%20profile%20https://www.googleapis.com/auth/youtube.readonly` +
        `&access_type=offline`;

    window.location.href = authUrl;
}


</script>
</head>
<body>
<center>
<input type="button" value="구글로 로그인" onclick="googleLogin()">
</center>
</body>
</html> 
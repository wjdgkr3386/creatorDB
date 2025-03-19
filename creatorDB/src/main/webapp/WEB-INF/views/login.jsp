<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login</title>
<style>
	body {
	    margin: 0;
	    padding: 0;
	    overflow-y: hidden;
	}
	.inputField{
		margin: 0px;
		padding: 0px 14px;
		font-size: 15px;
		width:100%;
		height: 53px;
		border-radius: 10px;
		border: 1px solid #F5E0F5;
	}
	input::placeholder {
	    color: #B0B0B0;
	}
	.div-body{
		background-color: #FBF3FC;
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 0px;
		margin: 0px;
		width: 100%;
		height: 100%;
	}
	.login-box{	
		width: 380px;
		height: 520px;
		background-color: white;
		border-radius: 15px;
		box-shadow: -5px 5px 5px rgba(0, 0, 0, 0.05);
		padding: 30px;
		box-sizing: border-box;
	}
	.loginBtn{
		width:100%;
		height:48px;
		background-color:#5DADEC;
		margin:20 0 15 0;
		border:none;
		border-radius: 10px;
		color: white;
		font-size: 15px;
		cursor: pointer;
	}
</style>
<script>
	$(function(){init();});
	function init(){
		$("[name='auto_login']").prop("checked", ${requestScope.auto_login eq 'y'} );
		if($("[name='auto_login']").is(":checked")){
			$("[name='mid']").val("${mid}");
			$("[name='pwd']").val("${pwd}");
		}
	}
	
	function login(){
		var formObj = $("[name='loginForm']");
		ajax(
		        "/loginProc.do",
		        "post",
		        formObj,
		        function (cnt) {
		        	if(cnt>0){
		        		location.href='/main.do';
		        	}else if(cnt==0){
		        		alert("아이디와 비밀번호를 정확히 입력해주세요.");
		        	}else{
		        		alert("실패! 관리자께 문의하세요.");
		        	}
		        }
			);
	}
	
	
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
<form name="loginForm">
	
<div class="div-body">
	<div class="login-box">
		<a style="font-size:24px;"><strong>로그인</strong></a><br>
		<a style="color:grey; font-size:14px;">크리에이터 정보를 관리하세요.</a>
		
		<div style="margin:27 0 0 0;">
			<div style="text-align:left; margin:0 0 5 0;">아이디</div>
			<input type="text" class="inputField" name="mid" placeholder="abc123">
		</div>
		<div style="margin:20 0 0 0;">
			<div style="text-align:left; margin:0 0 5 0;">비밀번호</div>
			<input type="password" class="inputField" name="pwd" placeholder="••••••••">
		</div>
		<div>
			<div style="display:flex; justify-content:space-between; align-items:center; margin:12 0 0 0;">
				<span style="font-size:14px;"><input type="checkbox" name="auto_login" value="y"> 로그인 유지</span>
				<a style="color:steelblue; font-size:14px; cursor:pointer;">비밀번호 찾기</a>
			</div>
		</div>
		<div>
			<input type="button" class="loginBtn" value="로그인" onclick="login()">
		</div>
		<div style="margin:10 0 10 0;">
			<a style="color:grey;">구글로 간편 로그인</a>
			<hr style="border: 1px solid #F5E0F5; width: 100%;">
		</div>
		<div style="display: flex; margin:10 0 10 0;">
			<img src="/sysimg/googleLogo.png" style="height:20px; width:20px; cursor:pointer;" onclick="googleLogin()">
		</div>
		<div>
			<a style="color:grey; font-size:15px;">계정이 없으신가요?</a>
			<a style="color:steelblue; font-size:15px; cursor:pointer;" onclick="location.href='/signup.do'">회원가입</a>
		</div>
	</div>
</div>
</form>
</center>
</body>
</html>
		
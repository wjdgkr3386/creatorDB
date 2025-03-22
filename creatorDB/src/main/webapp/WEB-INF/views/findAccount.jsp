<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계정 찾기</title>
<style>
	input[type="text"], input[type="tel"], input[type="password"]{
		height: 50px;
		padding: 15px;
		border-radius: 10px;
		border: 1px solid #F5E0F5;
	}
	.findBox{
		border: 1px solid #F5E0F5;
		padding: 20 40;
		width: 600px;
		box-sizing: border-box;
	}
	input::placeholder {
	    color: #B0B0B0;
	}
	.a-block{
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.btn{
		width: 100px;
		height: 50px;
		border-radius: 10px;
		border: none;
		margin: 10px;
		cursor: pointer;
	}
	.loginBtn{
		background-color:yellowgreen;
		width: 180px;
		height: 50px;
		margin: 10 0 0 0;
		cursor: pointer;
		border: none;
		border-radius: 10px;
	}
</style>
<script>
function idFind(){
	var formObj = $("[name='idFindForm']");
	if(!isValid(formObj)) {
		return;
	}
	ajax(
	        "/idFindProc.do",
	        "post",
	        formObj,
	        function (response) {
				var idList = response.idList;
				if(idList){
					var midText=[];
					for(var i=0; i<idList.length; i++){
						midText.push(idList[i].MID);
					}
					midText = midText.join('<br>');
					var HTMLText = `
						<div style="margin:20px; font-size:20px;">`+midText+`<\/div>
					`;
					formObj.find(".findBox").html(HTMLText);
					formObj.find(".btn").remove();
				}else{
					alert("계정이 없습니다.");
				}
	        }
		);
}

function passwordFind(){
	var formObj = $("[name='passwordFindForm']");
	if(!isValid(formObj)) {
		return;
	}
	
	ajax(
	        "/passwordFindProc.do",
	        "post",
	        formObj,
	        function (response) {
				var password = response.password;
				if(password){
					var text = `
					<div style="margin:20px; font-size:20px;">`+password+`<\/div>
					`;
					formObj.find(".findBox").html(text);
					formObj.find(".btn").remove();
				}else{
					alert("아이디 또는 주민등록번호가 틀립니다.");
				}
	        }
		);
}



function isValid(obj) {
	var isValid = true;
	var messages = [];
	
	// 입력 필드 가져오기
	var nameObj = obj.find("[name='name']");
	var midObj = obj.find("[name='mid']");
	var jumin_number1 = obj.find("[name='jumin_number1']").val();
	var jumin_number2 = obj.find("[name='jumin_number2']").val();
	
	
	if (nameObj && nameObj.length) {
		var name = nameObj.val().trim();
		if(name===""){
			messages.push("이름을 입력하세요.");
			isValid = false;
		} else if (!/^[가-힣]+$/.test(name)) { // 한글만 허용
			messages.push("이름은 한글만 입력할 수 있습니다.");
			isValid = false;
		}
	}
	if(midObj && midObj.length){
		var mid = midObj.val().trim();
		if (mid==="") {
			messages.push("아이디를 입력하세요.");
			isValid = false;
		} else if (!/^[a-zA-Z0-9]{6,15}$/.test(mid)) { // 영어+숫자 6~10자리
			messages.push("아이디는 영어와 숫자로 6~15자리여야 합니다.");
			isValid = false;
		}
	}
	if (jumin_number1 === "" || jumin_number2 === "") {
		messages.push("주민등록번호를 입력하세요.");
		isValid = false;
	} else if (!/^\d{6}$/.test(jumin_number1) || !/^\d{7}$/.test(jumin_number2)) { // 주민등록번호 형식
		messages.push("주민등록번호는 앞자리 숫자 6자리, 뒷자리 숫자 7자리여야 합니다.");
		isValid = false;
	}
	// 에러 메시지 출력
	if (!isValid) {
		alert(messages.join("\n"));
	}
	return isValid;
}


</script>
</head>
<body>
<center>
<h1 onclick="location.replace('/main.do')">CreatorDB</h1>
<div style="height:40px;"></div>
<form name="idFindForm">
	<div class="findBox">
		<div style="text-align:center; margin:10px; font-size:20px; font-weight: bold;">아이디 찾기</div>
		<div style="text-align:left; padding:0 15; margin:10 0 5 0;">이름</div>
		<div class="a-block">
			<input type="text" name="name" placeholder="이름" style="width:100%;margin-bottom: 10px;">
		</div>
		<div style="text-align:left; padding:0 15; margin:10 0 5 0;">주민등록번호</div>
        <div class="a-block">
            <span>
                <input type="text" name="jumin_number1" placeholder="주민등록번호 앞자리" maxlength="6" style="width:230px;">
            </span>
            <span style="width: 50px; align-items: center; justify-content: center;"> - </span>
            <span>
                <input type="password" name="jumin_number2" placeholder="주민등록번호 뒷자리" maxlength="7" style="width:230px;">
            </span>
        </div>
	</div>
	<input type="button" class="btn" value="아이디 찾기" onclick="idFind()">
</form>

	<hr style="margin:60px; width:600px; border: 1px solid #F5E0F5;">

<form name="passwordFindForm">
	<div class="findBox">
		<div style="text-align:center; margin:10px; font-size:20px; font-weight: bold;">비밀번호 찾기</div>
		<div style="text-align:left; padding:0 15; margin:10 0 5 0;">아이디</div>
		<div class="a-block">
			<input type="text" name="mid" placeholder="아이디" style="width:100%; margin-bottom: 10px;">
		</div>
		<div style="text-align:left; padding:0 15; margin:10 0 5 0;">주민등록번호</div>
        <div class="a-block">
            <span>
                <input type="text" name="jumin_number1" placeholder="주민등록번호 앞자리" maxlength="6" style="width:230px;">
            </span>
            <span style="width: 50px; align-items: center; justify-content: center;"> - </span>
            <span>
                <input type="password" name="jumin_number2" placeholder="주민등록번호 뒷자리" maxlength="7" style="width:230px;">
            </span>
        </div>
	</div>
	<input type="button" class="btn" value="비밀번호 찾기" onclick="passwordFind()">
</form>

<input type="button" class="loginBtn" value="로그인 페이지로 가기" onclick="location.replace('/login.do')">
</center>
</body>
</html>
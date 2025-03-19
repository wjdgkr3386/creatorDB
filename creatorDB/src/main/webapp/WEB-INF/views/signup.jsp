<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>

.a-container{
	width : 580px;
	height: 800px;
	border: 1px solid black;
	padding: 20px;
}

.a-block{
	margin: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.input-size {
	width : 500px;
	height: 50px;
	padding: 15px;
}

.a-block select {
	width: 80px;
	height: 50px;
	font-size: 13px;
	text-align:center;
	margin: 0 10 0 0;
}
.btn{
	width:100px;
	height: 50px;
	border-radius: 10px;
	background-color: yellowgreen;
	border:none;
	font-size:15px;
	font-weight: bold;
	cursor: pointer;
}
</style>
<script>

	$(function(){init();});
	function init(){
		
		$("[name='name']").val("김정학");
		$("[name='mid']").val("wjdgkr3386");
		$("[name='pwd']").val("kjh3765!");
		$("[name='jumin_number1']").val("970706");
		$("[name='jumin_number2']").val("1411518");
		$("[name='phone_number1']").val("010");
		$("[name='phone_number2']").val("4614");
		$("[name='phone_number3']").val("3386");
		$("[name='email']").val("wjdgkr3386@naver.com");
		$("[name='occupation']").val("개발자");
		$("[name='region']").val("충남");
		$("[name='address']").val("충청남도 천안시 동남구 서부대로 226-12 한라동백2차아파트 103동 106호");

	}
	
	

	function signUp() {
		if(!isValid()) return;
		
		var formObj = $("[name='signUpForm']");
		r_code = rCode(20);
		$("[name='r_code']").val(r_code);		
		ajax(
	        "/signUpProc.do",
	        "post",
	        formObj,
	        function (cnt) {
	        	if(cnt>0){
	        		alert("성공");
	        		location.href='/login.do';
	        	}else if(cnt==0){
	        		alert("실패");
	        	}else if(cnt==-13){
	        		alert("아이디가 존재합니다.");
	        	}
	        }
		);
	}
	
	function isValid() {
		var isValid = true;
		var messages = [];
		
		// 입력 필드 가져오기
		var name = $("[name='name']").val().trim();
		var mid = $("[name='mid']").val().trim();
		var pwd = $("[name='pwd']").val().trim();
		var jumin_number1 = $("[name='jumin_number1']").val().trim();
		var jumin_number2 = $("[name='jumin_number2']").val().trim();
		var phone_number1 = $("[name='phone_number1']").val().trim();
		var phone_number2 = $("[name='phone_number2']").val().trim();
		var phone_number3 = $("[name='phone_number3']").val().trim();
		var email = $("[name='email']").val().trim();
		var occupation = $("[name='occupation']").val().trim();
		var region = $("[name='region']").val().trim();
		var address = $("[name='address']").val().trim();
		
		
		if (name === "") {
			messages.push("이름을 입력하세요.");
			isValid = false;
		} else if (!/^[가-힣]+$/.test(name)) { // 한글만 허용
			messages.push("이름은 한글만 입력할 수 있습니다.");
			isValid = false;
		}
		if (mid === "") {
			messages.push("아이디를 입력하세요.");
			isValid = false;
		} else if (!/^[a-zA-Z0-9]{6,15}$/.test(mid)) { // 영어+숫자 6~10자리
			messages.push("아이디는 영어와 숫자로 6~15자리여야 합니다.");
			isValid = false;
		}
		if (pwd === "") {
			messages.push("비밀번호를 입력하세요.");
			isValid = false;
		} else if (!/^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$/.test(pwd)) { // 영어+숫자+특수문자 8~15자리
			messages.push("비밀번호는 영어, 숫자, 특수문자를 포함한 8~20자리여야 합니다.");
			isValid = false;
		}
		if (jumin_number1 === "" || jumin_number2 === "") {
			messages.push("주민등록번호를 입력하세요.");
			isValid = false;
		} else if (!/^\d{6}$/.test(jumin_number1) || !/^\d{7}$/.test(jumin_number2)) { // 주민등록번호 형식
			messages.push("주민등록번호는 앞자리 숫자 6자리, 뒷자리 숫자 7자리여야 합니다.");
			isValid = false;
		}
		if (phone_number1 === "" || phone_number2 === "" || phone_number3 === "") {
			messages.push("전화번호를 입력하세요.");
			isValid = false;
		} else if (!/^\d{2,3}-\d{3,4}-\d{4}$/.test(phone_number1 + '-' + phone_number2 + '-' + phone_number3)) { // 전화번호 형식
			messages.push("전화번호는 9~11자리의 숫자만 입력 가능합니다.");
			isValid = false;
		}
		if (email === "") {
			messages.push("이메일을 입력하세요.");
			isValid = false;
			//첫 문자는 영어, @ 나오기 전까지는 영어+숫자 4~12자리, @ 하나, 영어+숫자 하나 이상, . 하나 , 소문자 2~4자리 
		} else if (!/^([a-zA-Z][a-zA-Z0-9]{4,16})@([a-z0-9]+\.)[a-z]{2,4}$/.test(email)) { // 이메일 형식
			messages.push("유효한 이메일 주소를 입력하세요.");
			isValid = false;
		}
		if (occupation === "") {
			messages.push("직업을 입력하세요.");
			isValid = false;
		}
		if (region === "") {
			messages.push("지역을 선택하세요.");
			isValid = false;
		}
		if (address === "") {
			messages.push("상세주소를 입력하세요.");
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
	<h1 class="main_logo pointer" onclick="location.href = '/main.do';">CreatorDB</h1>
	
	<form name="signUpForm">
	    <div class="a-container">
	        <div class="a-block">
	            <input type="text" id="name" name="name" class="input-size" placeholder="이름">
	        </div>
	        <div class="a-block">
	            <input type="text" id="mid" name="mid" class="input-size" placeholder="아이디 영어+숫자 6~10자리">
	        </div>
	        <div class="a-block">
	            <input type="password" id="pwd" name="pwd" class="input-size" placeholder="비밀번호 영어+숫자 8~15자리">
	        </div>
	        <div class="a-block">
	            <span>
	                <input type="text" name="jumin_number1" placeholder="주민등록번호 앞자리" maxlength="6" style="width: 230px; height: 50px; padding: 15px;">
	            </span>
	            <span style="width: 50px; align-items: center; justify-content: center;"> - </span>
	            <span>
	                <input type="password" name="jumin_number2" placeholder="주민등록번호 뒷자리" maxlength="7" style="width: 230px; height: 50px; padding: 15px;">
	            </span>
	        </div>
	        <div class="a-block">
	            <span>
	                <input type="tel" name="phone_number1" placeholder="전화번호" maxlength="3" style="width: 150px; height: 50px; padding: 15px;">
	            </span>
	            <span style="width: 50px; align-items: center; justify-content: center;"> - </span>
	            <span>
	                <input type="tel" name="phone_number2" placeholder="전화번호" maxlength="4" style="width: 150px; height: 50px; padding: 15px;">
	            </span>
	            <span style="width: 50px; align-items: center; justify-content: center;"> - </span>
	            <span>
	                <input type="tel" name="phone_number3" placeholder="전화번호" maxlength="4" style="width: 150px; height: 50px; padding: 15px;">
	            </span>
	        </div>
	        <div class="a-block">
	            <input type="text" id="email" name="email" class="input-size" placeholder="이메일">
	        </div>
	        <div class="a-block">
	            <input type="text" id="occupation" name="occupation" class="input-size" placeholder="직업">
	        </div>
	        <div class="a-block">
	            <select id="region" name="region">
	                <option value="">지역</option>
	                <option value="서울">서울</option>
	                <option value="부산">부산</option>
	                <option value="인천">인천</option>
	                <option value="대구">대구</option>
	                <option value="광주">광주</option>
	                <option value="대전">대전</option>
	                <option value="울산">울산</option>
	                <option value="세종">세종</option>
	                <option value="경기">경기</option>
	                <option value="강원">강원</option>
	                <option value="충북">충북</option>
	                <option value="충남">충남</option>
	                <option value="전북">전북</option>
	                <option value="전남">전남</option>
	                <option value="경북">경북</option>
	                <option value="경남">경남</option>
	                <option value="제주">제주</option>
	            </select>
	            <input type="text" id="address" name="address" class="input-size" placeholder="상세주소">
	        </div>
	    </div>
	    <input type="hidden" name="r_code">
	</form>
	<input type="button" class="btn" value="확 인" onclick="signUp()">
	<!-- 폼 제출 방지 -->
	<input type="hidden">
</center>
</body>
</html>
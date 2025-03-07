<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main</title>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f9f9f9;
        text-align: center;
    }
    .div-data {
    	width: 90%;
    	height: 35px;
    	margin: 5px;
    	font-size: 15px;
    }
    .header {
        background: #222;
        color: white;
        padding: 20px;
        font-size: 24px;
        font-weight: bold;
        letter-spacing: 1px;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
    }

    .searchBar {
        width: 800px;
        padding: 12px;
        font-size: 16px;
        border-radius: 25px;
        border: 1px solid #ccc;
        outline: none;
        transition: all 0.3s ease-in-out;
    }
    .searchBar:focus {
        border-color: #666;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .searchBtn {
        padding: 12px 20px;
        font-size: 16px;
        font-weight: bold;
        border: none;
        background: #ff4757;
        color: white;
        border-radius: 25px;
        cursor: pointer;
        transition: 0.3s ease;
        margin-left: 10px;
    }
    button:hover {
        background: #e84118;
    }

    .creatorTable {
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 15px;
        overflow: hidden;
        background: white;
        box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.1);
        min-width: 600px;
        min-height: 520px;
    }

    td {
        padding: 20px;
        font-size: 18px;
    }

    .td-image {
        width: 180px;
        height: 180px;
        text-align: center;
    }

    .creator_image {
        width: 180px;
        height: 180px;
        border-radius: 50%;
        border: 3px solid #ddd;
        transition: 0.3s;
    }
    .creator_image:hover {
        transform: scale(1.05);
    }

    .td-dataList {
        width: 400px;
        height: 200px;
        font-size: 16px;
        font-weight: bold;
        text-align: left;
        color: #333;
    }
	.description{
        width: 100%;
        height: 340px;
        padding: 20px;
        font-size: 16px;
        color: #555;
        background: #f8f8f8;
        border: none;
        resize: none;
	}
</style>
<script>
	
	$(function(){init();});
	function init(){
		//엔터를 눌렀을때 폼 제출 방지
		$("[name='creatorInfoForm'] input[name='keyword']").on('keydown', function(event) {
		    if (event.key === 'Enter') {
		        //폼 제출 방지
		        event.preventDefault();
		        channelSearch();
		    }
		});	
	}

	let API_KEY = "AIzaSyA0Z8vTaiFyZ9hW6IE41ZlPYK5xj-63iso";
	
	//유튜브 채널 검색
	async function channelSearch(){
		let isExist = await searchCreatorInfo();	
		if(isExist!=0) return;
		
		var keyword = $("[name='keyword']").val().trim();
		var URL = `https://www.googleapis.com/youtube/v3/search?&q=`+keyword+`&type=channel&key=`+API_KEY;
		fetch(URL)
		.then(response => {
		    console.log('응답 상태 코드:', response.status);
		    console.log('응답 성공 여부:', response.ok);
		    return response.json();
		  })
		.then(data => {
			const channelId = data.items[0].id.channelId;	
			getChannelInfo(channelId);
			
		})
		.catch(error => console.error("Error:", error)); // 오류 처리
	}
	
	async function getChannelInfo(channelId) {
	    var URL = `https://www.googleapis.com/youtube/v3/channels?&part=brandingSettings,statistics,snippet&maxResults=1&id=` + channelId + `&key=` + API_KEY;
	    
	    try {
	        // await을 사용해 fetch 요청을 기다립니다
	        const response = await fetch(URL);
	        const data = await response.json();

	        console.log(data);

	        var dataList = $(".td-dataList");
	        var divB = $(".div-table");
	        divB.html("");
	        addTable();
	        
	        //닉네임, 프로필이미지, 설명, 구독자수, 동영상수, 총 조회수, 국가
	        const nickname = data.items[0].brandingSettings.channel.title;
	        const creator_image = data.items[0].snippet.thumbnails.high.url;
	        const description = data.items[0].snippet.description;
	        const subscriber_count = data.items[0].statistics.subscriberCount;
	        const video_count = data.items[0].statistics.videoCount;
	        const view_count = data.items[0].statistics.viewCount;
	        const country = data.items[0].brandingSettings.channel.country;

	        $(".nickname").text(nickname);
	        adjustNicknameFontSize();
	        $(".creator_image").attr("src", creator_image);
	        $(".description").text(description);
	        $(".subscriber_count").text("구독자: " + convertToUnit(subscriber_count) + "명");
	        $(".video_count").text("동영상: " + convertToUnit(video_count) + "개");
	        $(".view_count").text("조회수: " + formatNumberWithCommas(view_count) + "회");
	        $(".country").text(getCountryName(country));

	        $("[name='nickname']").val(nickname);
	        $("[name='creator_image']").val(creator_image);
	        $("[name='subscriber_count']").val(subscriber_count);
	        $("[name='video_count']").val(video_count);
	        $("[name='view_count']").val(view_count);
	        $("[name='country']").val(country);
	        $("[name='description']").text(description);
	        $("[name='channel_id']").val(channelId);
	        
	        // 데이터가 제대로 반영된 후 insertCreatorInfo 호출
	        insertCreatorInfo();
	    } catch (error) {
	        console.error("Error:", error);
	    }
	} 


	function convertToUnit(value){
	    if (!value) {
	        return "0"; // value가 undefined, null, 빈 문자열인 경우 0 반환
	    }
	    
		var size = value.length;
		switch(size){
			case 10: value = value.substr(0, 2) + "." + value.substr(2, 1) + "억"; break;
			case 9: value = value.substr(0, 1) + "." + value.substr(1, 1) + "억"; break;
			case 8: value = value.substr(0, 4) + "만"; break;
			case 7: value = value.substr(0, 3) + "만"; break;
			case 6: value = value.substr(0, 2) + "." + value.substr(2, 1) + "만"; break;
			case 5: value = value.substr(0, 1) + "." + value.substr(1, 1) + "만"; break;
			case 4: value = value.substr(0, 1) + "." + value.substr(1, 1) + "천"; break;
			default: value = value;
		}
		return value;
	}
	
	function formatNumberWithCommas(value){
	    if (!value) {
	        return "0"; // value가 undefined, null, 빈 문자열인 경우 0 반환
	    }
	    
		var arr = value.split("");
		var piece = new Array();
		var i=0;
		while(arr.length>0){
			piece.push(arr.pop());
			i++;
			if(arr.length>0 && i===3){
				piece.push(",");
				i=0;
			}
		}
		return piece.reverse().join("");
	}
	
	function getCountryName(countryCode){		
	    if (!countryCode) {
	        return "0"; // value가 undefined, null, 빈 문자열인 경우 0 반환
	    }
	    
		let countryName;
		switch (countryCode) {
		    case "KR": countryName = "대한민국"; break;
		    case "US": countryName = "미국"; break;
		    case "JP": countryName = "일본"; break;
		    case "CN": countryName = "중국"; break;
		    case "FR": countryName = "프랑스"; break;
		    case "DE": countryName = "독일"; break;
		    case "GB": countryName = "영국"; break;
		    case "IT": countryName = "이탈리아"; break;
		    case "ES": countryName = "스페인"; break;
		    case "RU": countryName = "러시아"; break;
		    default: countryName = countryCode;
		}
		return countryName;
	}
	
	function insertCreatorInfo(){

		var formObj = $("[name='creatorInfoForm']");
		ajax(
		        "/insertCreatorInfoProc.do",
		        "post",
		        formObj,
		        function (cnt) {
		        	if(cnt>0){
		        		console.log("성공");
		        	}else if(cnt==0){
		        		console.log("실패");
		        	}else if(cnt==-13){
		        		console.log("이미 있음");
		        	}
		        }
		    );
	}
	
	function searchCreatorInfo() {
		let promise = new Promise(function(resolve, reject){
			$("[name='keyword']").val($("[name='keyword']").val().trim());
			var formObj = $("[name='creatorInfoForm']");
		    ajax(
		        "/searchCreatorInfoProc.do",
		        "post",
		        formObj,
		        function (response) {
		        	var obj = response;
	        		var creatorList = obj.creatorList;
		        	var resultCount = obj.resultCount;
		        	
		  			if(resultCount>0) {
			        	var divB = $(".div-table");
			        	divB.html("");
		        		for(var i=0; i<resultCount; i++){
		        			addTable();
		        		}
						divB.find(".creatorTable").each(function(i, table){
							$(this).find(".nickname").text(creatorList[i].NICKNAME);
							adjustNicknameFontSize();
							$(this).find(".creator_image").attr("src",creatorList[i].CREATOR_IMAGE);
							$(this).find(".description").text(creatorList[i].DESCRIPTION);
							$(this).find(".subscriber_count").text("구독자: "+convertToUnit(creatorList[i].SUBSCRIBER_COUNT)+"명");
							$(this).find(".video_count").text("동영상: "+convertToUnit(creatorList[i].VIDEO_COUNT)+"개");
							$(this).find(".view_count").text("조회수: "+formatNumberWithCommas(creatorList[i].VIEW_COUNT)+"회");
							$(this).find(".country").text(getCountryName(creatorList[i].COUNTRY));
						});
		  			}
		  			resolve(resultCount);
		        }
		    );
		    
		});
		return promise;
	}
	
	function addTable(){
		var tableHtml = `
	    	<div style="height:30px;"><\/div>
		    <table class="creatorTable">
			    <tr>
			        <td class="td-image">
			            <img class="creator_image">
					<\/td>
					<td class="td-dataList">
					    <div class="nickname div-data" style="font-weight:bold; font-size:30px;"><\/div>
						<div class="subscriber_count div-data"><\/div>
						<div class="video_count div-data"><\/div>
						<div class="view_count div-data"><\/div>
						<div class="country div-data"><\/div>
				    <\/td>
				<\/tr>
				<tr>
			    	<td class="td-description" colspan="2">
			        	<textarea class="description" disabled><\/textarea>
			        <\/td>
			    <\/tr>
			<\/table>
		`;
		$(".div-table").prepend(tableHtml);
	}
	
	function adjustNicknameFontSize() {
	    var nicknameElement = document.querySelector(".nickname");
	    if (!nicknameElement) return;

	    var text = nicknameElement.textContent.trim();
	    if (text.length >= 8) {
	        nicknameElement.style.fontSize = "20px";
	    } else {
	        nicknameElement.style.fontSize = "30px";
	    }
	}
</script>
</head>
<body>
<center>
<form name="creatorInfoForm">
    <div class="header">
        <h1>CreatorDB</h1>
        <input type="text" class="searchBar" name="keyword" placeholder="크리에이터 검색...">
        <input type="button" class="searchBtn" value="검색" onclick="channelSearch()">
    </div>

	<div class="div-table"></div>
	
	<input type="hidden" name="nickname">
	<input type="hidden" name="subscriber_count">
	<input type="hidden" name="video_count">
	<input type="hidden" name="view_count">
	<input type="hidden" name="country">
	<input type="hidden" name="creator_image">
	<textarea hidden name="description"></textarea>
	<input type="hidden" name="channel_id">
</form>
</center>
</body>
</html>

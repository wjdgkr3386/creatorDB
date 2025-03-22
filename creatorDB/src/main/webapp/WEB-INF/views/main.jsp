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
        min-height: 320px;
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
        height: 140px;
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

	//채널 검색
	async function channelSearch() {
	    try {
	        let isExist = await searchCreatorInfo();    
	        if (isExist != 0) return;

	        var keyword = $("[name='keyword']").val().trim();
			var URL = `/api/youtube/search?keyword=`+keyword;
			
			const response = await fetch(URL);
	        if (!response.ok) {
	            throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
	        }
	        const data = await response.json();
	        if (!data.items || data.items.length === 0) {
	            throw new Error("검색된 채널이 없습니다.");
	        }
	        const channelId = data.items[0].id.channelId;

	        isExist = await getChannel(channelId);
	        if (isExist != 0) {
	        	return;
	        }

	        // 채널 정보 가져와서 화면에 출력
	        getChannelInfo(channelId);
	    } catch (error) {
	        console.error("오류 발생:", error.message); // 오류 메시지 출력
	        alert("채널 검색 중 오류가 발생했습니다: " + error.message); // 사용자에게 알림
	    }
	}

	function searchCreatorInfo() {
		let promise = new Promise(function(resolve, reject){
			$("[name='keyword']").val($("[name='keyword']").val().trim());
			var formObj = $("[name='creatorInfoForm']");
		    ajax(
		        "/searchCreatorInfoProc.do",
		        "post",
		        formObj,
		        async function (response) {
		        	var obj = response;
	        		var creatorList = obj.creatorList;
		        	var resultCount = obj.resultCount;

		  			if(resultCount>0) {
		  				
		  				for(var i=0; i<resultCount; i++){
		  					var elapsedId = creatorList[i].elapsedId;
		  					if(elapsedId){
		  						var fetchResult = await fetchChannel(elapsedId);
		  						if(fetchResult){
		  							var data = await fetchResult.json();
			  						await updateChannel(data);
		  						}
		  					}
		  				}
		  				
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
	
	function getChannel(channelId){
        $("[name='channel_id']").val(channelId);
		var formObj = $("[name='creatorInfoForm']");
		let promise = new Promise(function(resolve, reject){
			var formObj = $("[name='creatorInfoForm']");
		    ajax(
		        "/getChannelProc.do",
		        "post",
		        formObj,
		        function (response) {
		        	var size = response.size;
		  			if(size>0) {
			        	var divB = $(".div-table");
			        	divB.html("");
		        		addTable();
		        		
						var table = divB.find(".creatorTable");
						table.find(".nickname").text(response.NICKNAME);
						adjustNicknameFontSize();
						table.find(".creator_image").attr("src",response.CREATOR_IMAGE);
						table.find(".description").text(response.DESCRIPTION);
						table.find(".subscriber_count").text("구독자: "+convertToUnit(response.SUBSCRIBER_COUNT)+"명");
						table.find(".video_count").text("동영상: "+convertToUnit(response.VIDEO_COUNT)+"개");
						table.find(".view_count").text("조회수: "+formatNumberWithCommas(response.VIEW_COUNT)+"회");
						table.find(".country").text(getCountryName(response.COUNTRY));
		  			}
		  			resolve(size);
		        }
		    );
		});
		return promise;
	}
	
	async function getChannelInfo(channelId) {
	    
	    try {
	    	var response = await fetchChannel(channelId);
	    	data = await response.json();
	    	
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
	        
	        // 데이터가 제대로 반영된 후 insertCreatorInfo 호출
	        insertCreatorInfo();
	    } catch (error) {
	        console.error("Error:", error);
	    }
	}
	
	function insertCreatorInfo(){
		var formObj = $("[name='creatorInfoForm']");
		ajax(
		        "/insertCreatorInfoProc.do",
		        "post",
		        formObj,
		        function (cnt) {
		        }
		    );
	}
	
	function convertToUnit(value){
	    if (!value) {
	        return "0";
	    }
	    
		var size = value.length;
		switch(size){
			case 10: value = value.substr(0, 2) + "." + value.substr(2, 1) + "억"; break;
			case 9: value = value.substr(0, 1) + "." + value.substr(1, 1) + "억"; break;
			case 8: value = value.substr(0, 4) + "만"; break;
			case 7: value = value.substr(0, 3) + "만"; break;
			case 6: value = value.substr(0, 2) + "만"; break;
			case 5: value = value.substr(0, 1) + "." + value.substr(1, 1) + "만"; break;
			case 4: value = value.substr(0, 1) + "." + value.substr(1, 1) + "천"; break;
			default: value = value;
		}
		return value;
	}
	
	function formatNumberWithCommas(value){
	    if (!value) {
	        return "0";
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
	        return "0";
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
 
	async function fetchChannel(channelId){
	    var URL = `/api/youtube/channel?channelId=`+channelId;
	    try {
	        const response = await fetch(URL);
	        return response;
	    } catch (error) {
	        console.error("Error:", error);
	        return null;
	    }
	}
	
	function updateChannel(data){
		if(!data){
			return;
		}
		
        //닉네임, 프로필이미지, 설명, 구독자수, 동영상수, 총 조회수, 국가
        const nickname = data.items[0].brandingSettings.channel.title;
        const creator_image = data.items[0].snippet.thumbnails.high.url;
        const description = data.items[0].snippet.description;
        const subscriber_count = data.items[0].statistics.subscriberCount;
        const video_count = data.items[0].statistics.videoCount;
        const view_count = data.items[0].statistics.viewCount;
        const country = data.items[0].brandingSettings.channel.country;
        const channel_id = data.items[0].id;
        
        $("[name='nickname']").val(nickname);
        $("[name='creator_image']").val(creator_image);
        $("[name='subscriber_count']").val(subscriber_count);
        $("[name='video_count']").val(video_count);
        $("[name='view_count']").val(view_count);
        $("[name='country']").val(country);
        $("[name='description']").text(description);
        $("[name='channel_id']").val(channel_id);
        
		var formObj = $("[name='creatorInfoForm']");
		ajax(
		        "/updateChannelProc.do",
		        "post",
		        formObj,
		        function (cnt) {
		        }
		    );
	}
</script>
</head>
<body>
<center>
<form name="creatorInfoForm">
    <div class="header">
        <h1>CreatorDB</h1>
        <c:if test="${empty requestScope.mid and empty requestScope.access_token}">
        	<div style="float: right;">
	        	<span style="text-align:right; font-size:20px; padding:0 15 0 0; cursor:pointer;" onclick="location.href='/login.do'">
	        		로그인
	        	</span>
        	</div>
        </c:if>
        <c:if test="${not empty requestScope.mid or not empty requestScope.access_token}">
        	<div style="float: right;">
	        	<span style="text-align:right; font-size:20px; padding:0 15 0 0; cursor:pointer;" onclick="location.href='/logout.do'">
	        		로그아웃
	        	</span>
        	</div>
        </c:if>
        <input type="text" class="searchBar" name="keyword" placeholder="크리에이터 검색...">
        <input type="button" class="searchBtn" value="검색" onclick="channelSearch()">
    </div>
	<div style="height:50px;"></div>
	
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

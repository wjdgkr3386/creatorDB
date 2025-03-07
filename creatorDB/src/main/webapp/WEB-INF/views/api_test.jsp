<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>API 데이터 조회</title>
</head>
<script>
//youtube data api v3 API 키
let API_KEY = "AIzaSyA0Z8vTaiFyZ9hW6IE41ZlPYK5xj-63iso";
//유튜브 채널 검색
function channelSearch(){
	var keyword = $(".keyword").val();
	var URL = `https://www.googleapis.com/youtube/v3/search?part=snippet&q=`+keyword+`&maxResults=1&type=channel&key=`+API_KEY;
	fetch(URL)
	.then(response => {
	    console.log('응답 상태 코드:', response.status);
	    console.log('응답 성공 여부:', response.ok);
	    return response.json();
	  })
	.then(data => {
		console.log(data);
		const channelId = data.items[0].id.channelId;
		$("#data-list").text("채널ID: "+channelId);
		API_banner(channelId);
		const profileImageUrl = data.items[0].snippet.thumbnails.default.url;
		$(".a").attr("src", profileImageUrl);
	})
	.catch(error => console.error("Error:", error)); // 오류 처리
}
function API_banner(channelId){
	 var URL = `https://www.googleapis.com/youtube/v3/channels?part=brandingSettings,statistics&id=`+channelId+`&key=`+API_KEY;
	 fetch(URL)
	.then(response => response.json())
	.then(data => {
		const bannerUrl = data.items[0].brandingSettings.image.bannerExternalUrl;
		$(".banner_img").attr("src", bannerUrl);
		const subscriberCount = data.items[0].statistics.subscriberCount;
		$("#data-list").append("구독자: "+subscriberCount+"명");
	})
	.catch(error => console.error("Error:", error)); // 오류 처리
}
</script>
<body>
<input type="text" class="keyword">
<input type="button" value="검색" onclick="channelSearch()">
	<div id="data-list"></div>
	<input type="button" value="조회하기" onclick="channelSearch()">
	<img class="banner_img" style="height: 100px;">
	<img class="a" style="height: 100px;">
</body>
</html>
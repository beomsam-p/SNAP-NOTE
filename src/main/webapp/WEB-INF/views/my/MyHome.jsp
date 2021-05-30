<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	//뒤로가기
	$("#btnBack").on("click",function(){
		history.back();
	});
});
</script>

<div class="my-home-list">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">마이 홈</span>
		</div>
	</div>
	<div class="my-home-bg" 
		 style="background-image: url('/static/assets/img/temp/dog.PNG'); ">
	</div>
	<%--프로필 영역--%>
	<div class="profile-wrap">
		<div class="profile-area">
			<div class="profile-img" style="background-image: url('/static/assets/img/temp/dog.PNG');">
			</div>
		</div>
		<div class="profile-nick">닉네임</div>
		<%--개인정보 수정 영역--%>
		<div class="my-home-logout">
			<span>프로필 수정</span><span> 로그아웃</span> 
		</div>
		<%--통계영역--%>
		<div class="my-home-statistics">
			<div>저장 단어 <br> 12,300</div>
			<div>외운 단어 <br> 2,300</div>
			<div>못 외운 단어 <br> 10,000</div>
			<div>저장 문장	 <br> 5,000</div>
		</div>
		
		
		
	</div>
</div>

<%--
1. 디자인 정리
2. 백그라운드 이미지도 변경버튼 달아주기
3. 백그라운드 이미지 클릭스  사진 팝업(카톡참고)
4. 프로필 사진 클릭시 사진팝업(카톡참고)
5. rest api 방식 데이터 얻기
6. 로그아웃 기능, 프로필 수정페이지 이동 기능
--%>
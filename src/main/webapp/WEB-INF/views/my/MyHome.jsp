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
	<div class="my-home-box">
		<%--프로필 영역--%>
		<div class="my-home-profile">
			<div class="profile-area">
				<img class="profile-img" alt="" src="/static/assets/img/temp/dog.PNG">
				<div class="profile-modify">수정버튼</div>
				<div>닉네임</div>
			</div>
		</div>
		
		<%--통계영역--%>
		<div class="my-home-statistics">
			<div>저장 단어 <br> 12,300</div>
			<div>외운 단어 <br> 2,300</div>
			<div>못 외운 단어 <br> 10,000</div>
			<div>저장 문장	 <br> 5,000</div>
		</div>
		
		
		<%--개인정보 수정 영역--%>
		<div class="my-home-privacy">
			<div>개인정보 수정</div>
		</div>
		
		<%--로그아웃 영역--%>
		<div class="my-home-logout">
			<div>로그아웃</div>
		</div>
	</div>
</div>
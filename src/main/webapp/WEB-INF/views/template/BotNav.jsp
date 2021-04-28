<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	
	//마이페이지 이동
	$("#btnMenuMyPage").on("click",function(){
		location.herf="/mypage/mypage"
	});
	
	//문장등록 페이지 이동
	$("#btnMenuRegSentence").on("click",function(){
		location.href="/study/study"
	});
	
	$("#btnMenuList").on("click",function(){
		location.href="/study/category"
	});
	
});
</script>
<div class="row bot-nav">
	<div class="col-xs-4 height100" id="btnMenuList" >
 		<div class="menuBtn">
			<span class="glyphicon glyphicon-folder-open gi-1_5x "></span>
		</div>
		<div class="nav-txt">FORDER</div>
	</div>
	<div class="col-xs-4 height100">
	 	<div class="menuBtn" id="btnMenuMyPage">
			<span class="glyphicon glyphicon-user gi-1_5x "></span>
		</div>
		<div class="nav-txt">MY</div>
	</div>
	<div class="col-xs-4 height100 bot-menu-border">
	 	<div class="menuBtn" id="btnMenuRegSentence" >
			<span class="glyphicon glyphicon-pencil gi-1_5x "></span>
		</div>
		<div class="nav-txt">SNAP</div>
	</div>
</div>

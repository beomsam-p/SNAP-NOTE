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


<div id="wordList" class="sentenceList">
	<div id="header" class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">단어 목록</span>
		</div>
	</div>
	<div class="sentence-wrap">
		
	</div>
	<div id="divBotBtnWrap" class="insert-head-wrap" >
		<div id="btnModify" class="pop-btn-float">삭제</div>
		<div id="btnAddFolder" class="pop-btn-float-end">암기 테스트</div>
	</div>
</div>
<%--
1. 단어 출력
라디오박스 원단어 번역  틀린횟수 정답여부 
2. 단어 등록 수정 삭제 -> 문장에서도 가능해야함
3. 단어게임 
	-> 선택한단어로 단어게임 시작 / 전체 단어로 시작 / 노히트 단어로만 시작
	-> 랜덤으로 단어 출력(중복되지 않음)
	-> 단어 밑에 랜덤으로 3개와 1개의 정답 뜻이 써있음
	-> 정답을 맞출 경우엔 히트!
	-> 틀렸을 경우 틀림횟수 증가
	-> 틀림횟수가 많이 증가할수록 빨간색이 됨
	-> 게임이 끝나면 통계를 보여줌(결과 통계 기록 테이블 만들지 고민필요 / 마이페이지에서 로그성으로 볼려면 만들어야함.)
--%>
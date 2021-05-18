<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
$(function(){
	//뒤로가기
	$("#btnBack").on("click",function(){
		history.back();
	});
	
	var objWords= new Object();
	
	
	$("[name='word']").on("change",function(){
		var wordNo = $(this).attr("id");
		var orgWord = $(this).data("orgWord");
		var convWord = $(this).data("convWord");
		var wrongCount = $(this).data("wrongCount");
		var hitYn = $(this).data("hitYn");
		
		if($(this).is(":checked")){
			var objWord = new Object();
			objWord.wordNo = wordNo;
			objWord.orgWord = orgWord;
			objWord.convWord = convWord;
			objWord.wrongCount = wrongCount;
			objWord.hitYn = hitYn;
			objWords[wordNo]  = objWord;
		}else{
			delete objWords[wordNo];
		}
		
		if($("[name='word']:checked").length != 0){
			$("#divBotBtnWrap").show();
			$(".word-wrap").css("padding-bottom","90px")
			
		}else{
			$("#divBotBtnWrap").hide();
			$(".word-wrap").css("padding-bottom","55px")
		}
		
		if($("[name='word']:checked").length == $("[name='word']").length){
			$("#allChk").prop("checked",true);
		}else{
			$("#allChk").prop("checked",false);
		}
	});
	
	
	$("#allChk").on("change",function(){
		if($(this).is(":checked")){
			$("#divBotBtnWrap").show();
			$("[name='word']").prop("checked",true);
			$(".word-wrap").css("padding-bottom","90px")
			$("[name='word']").each(function(index, item){
				var wordNo = $(item).attr("id");
				var orgWord = $(item).data("orgWord");
				var convWord = $(item).data("convWord");
				var wrongCount = $(item).data("wrongCount");
				var hitYn = $(item).data("hitYn");
				var objWord = new Object();
				objWord.wordNo = wordNo;
				objWord.orgWord = orgWord;
				objWord.convWord = convWord;
				objWord.wrongCount = wrongCount;
				objWord.hitYn = hitYn;
				objWords[wordNo]  = objWord;
			});
		}else{
			$("#divBotBtnWrap").hide();
			$("[name='word']").prop("checked",false);
			$(".word-wrap").css("padding-bottom","55px")
			objWords=new Object;
			
		}
	});
	
	
	$("[name='chkConvHide']").on("change",function(){
		if($(this).is(":checked")){
			$(".conv-word").removeClass("display-none");
		}else{
			$(".conv-word").addClass("display-none");
		}
	});
	
	var currScrollTop = 0;
	$(document).on("scroll",function(e){
		var scrollTop = $(window).scrollTop();
		if(scrollTop > 49){
			$("#tableHeader").css("position","fixed");
			$("#tableHeader").css("top","0");
		}else{
			$("#tableHeader").css("position","relative");
		}
		
		if(currScrollTop > scrollTop){
			$("#toolBox").css("top",scrollTop+window.innerHeight/2-50);
			$("#toolBox").fadeOut();
		}else{
			$("#toolBox").css("top",scrollTop+window.innerHeight/2-50);
			$("#toolBox").fadeIn();
		}
		currScrollTop = scrollTop;
	});
	
	$("#moveToTop").on("click",function(){
		$('html, body').stop().animate({scrollTop:'0'},1000);
	});
	
	$("#moveToDown").on("click",function(){
		var target = $('html, body');
		target.animate({scrollTop : target.prop("scrollHeight")},1000);
	});
	
	$("#wordReg").on("click",function(){
		alert("등록!")
	});
	
});
</script>

<div id="toolBox" class="tool-box-wrap">
	<span id="moveToTop"class="glyphicon glyphicon-chevron-up tool-box-item"></span>
	<br>
	<span id="wordReg" class="glyphicon glyphicon-plus"></span>
	<br>
	<span id="moveToDown" class="glyphicon glyphicon-chevron-down tool-box-item"></span>
</div>
<div id="wordList" class="sentenceList">
	<div id="header" class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">단어 목록</span>
		</div>
	</div>
	<div class="word-wrap">
		<div class="word-container" id="tableHeader">
			<div class="item item-head">
				<span class="inner-item"><input type="checkbox" id="allChk"></span>
			</div>
			<div class="item item-head"><span class="inner-item">단어</span></div>
			<div class="item item-head"><span class="inner-item">뜻&nbsp;&nbsp;&nbsp;<input type="checkbox" id="chkConvHide" name="chkConvHide" checked="checked"></span></div>
			<div class="item item-head"><span class="inner-item">오답 횟수</span></div>
			<div class="item item-head"><span class="inner-item">정답 여부</span></div>
		</div>
		<div class="word-container">
			<c:forEach items="${wordList}" var="word">
				<div class="item">
					<span class="inner-item">
						<input	type="checkbox" 
							id="${word.WORD_NO}" 
							name="word" 
							value="${word.WORD_NO}"
							data-org-word="${word.ORG_WORD}"
							data-conv-word="${word.CONV_WORD}"
							data-wrong-count="${word.WRONG_COUNT}"
							data-hit-yn="${word.HIT_YN}">
					</span>
				</div>
				<div class="item"><span class="inner-item">${word.ORG_WORD} </span></div>
				<div class="item"><span class="inner-item conv-word">${word.CONV_WORD}</span></div>
				<div class="item"><span class="inner-item">${word.WRONG_COUNT}</span></div>
				<div class="item"><span class="inner-item">${word.HIT_YN}</span></div>
			</c:forEach>
		</div>
	</div>
	<div id="divBotBtnWrap" class="insert-head-wrap" >
		<div id="btnDelete" class="pop-btn-float">삭제</div>
		<div id="btnTest" class="pop-btn-float-end">암기 테스트</div>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %> 
<script>
$(function(){
	//뒤로가기
	$("#btnBack").on("click",function(){
		history.back();
	});
	$("#divWordRegWrap").show();
	
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
		console.log(objWords);
		if($("[name='word']:checked").length != 0){
			$("#divBotBtnWrap").show();
			
		}else{
			$("#divBotBtnWrap").hide();
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
		console.log(objWords);
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
		if(scrollTop > $("#tableHeader").height()){
			$("#tableHeader").css("position","fixed");
			$("#tableHeader").css("top","0");
			$(".word-wrap").css("padding-top", $("#tableHeader").height());
		}else{
			$("#tableHeader").css("position","relative");
			$(".word-wrap").css("padding-top",0);
		}
		
		if(currScrollTop > scrollTop){
			$("#toolBox").css("top",scrollTop+window.innerHeight/2-50);
			$("#toolBox").fadeOut();
		}else{
			$("#toolBox").css("top",scrollTop+window.innerHeight/2-50);
			$("#toolBox").fadeIn();
		}
		
		if($("#inputWordPop").is(":visible")){
			$("#inputWordPop").css("top",scrollTop+window.innerHeight/2-200);
			$("#inputWordPop").show();
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
	
	$("#wordReg, #wordReg2").on("click",function(){
		$("#inputWord").val("");
		$("#inputMean").val("");
		var scrollTop = $(window).scrollTop();
		common.loding(true);
		$("#inputWordPop").css("top",scrollTop+window.innerHeight/2-200);
		$("#inputWordPop").show();
	});
	
	$("#btnWordCancel").off().click(function(){
		common.loding(false);
		$("#inputWordPop").hide();
	});
	
	$("#btnWordOk").on("click",function(){
		var orgWord = $("#inputWord").val().trim();
		var convWord = $("#inputMean").val().trim();
		
		if(orgWord == ''){
			common.toast('단어를 입력해주세요.');
			return;
		}
		
		if(convWord == ''){
			common.toast('뜻을 입력해주세요.');
			return;
		}
		
		$.ajax({
			url : "/study/word/save",     
			data : {
					"orgWord": orgWord
					, "convWord" : convWord
					},    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				console.log(data);
				common.loding(false);
				
				if(data != null && data.result == "00"){
					$("#wordReg2").hide();
					$("#inputWordPop").hide();
					common.toast('단어를 저장했어요!');
					common.loding(false);
					
					var word = data.word;
					
					html =  '<div class="item">'
						 +	'	<span class="inner-item">'
						 +	'		<input	type="checkbox"' 
						 +	'			id="'+word.WORD_NO+'"'
						 +	'			name="word"' 
						 +	'			value="'+word.WORD_NO+'"'
						 +	'			data-org-word="'+word.ORG_WORD+'"'
						 +	'			data-conv-word="'+word.CONV_WORD+'"'
						 +	'			data-wrong-count="'+word.WRONG_COUNT+'"'
						 +	'			data-hit-yn="'+word.HIT_YN+'">'
						 +	'	</span>'
						 +	'</div>'
						 +	'<div class="item"><span class="inner-item">'+word.ORG_WORD+'</span></div>'
						 +	'<div class="item"><span class="inner-item conv-word">'+word.CONV_WORD+'</span></div>'
						 +	'<div class="item"><span class="inner-item">'+word.WRONG_COUNT+'</span></div>'
						 +	'<div class="item"><span class="inner-item">'+word.HIT_YN+'</span></div>';
					
					$("#wordContainer").append(html);
					console.log("#"+word.WORD_NO);
					$("#"+word.WORD_NO).on("change",function(){
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
						console.log(objWords);
						
						if($("[name='word']:checked").length != 0){
							$("#divBotBtnWrap").show();
						}else{
							$("#divBotBtnWrap").hide();
						}
						
						if($("[name='word']:checked").length == $("[name='word']").length){
							$("#allChk").prop("checked",true);
						}else{
							$("#allChk").prop("checked",false);
						}
					});
					
				}else{
					$("#inputWordPop").hide();
					common.toast('저장에 실패했어요...');
					common.loding(false);
				}
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.toast('저장에 실패했어요...'+error);
			}
		});
	});
	
	$("#wordContainer").on("click", function(){
		$("#toolBox").fadeOut();
	});
	
	$("#btnDelete").on("click", function(){
		if(confirm("정말 삭제할까요?")){
			$("[name='word']:checked").each(function(index, item){
				$(item).parent().parent().hide().next().hide().next().hide().next().hide().next().hide();
			});
		}
	});
	
	$("#btnTest").on("click", function(){
		$("#hdnWords").val(JSON.stringify(objWords))	
		
		console.log($("#hdnWords").val());
		
		$("#formWordGame").submit();
		
		
	});
});
</script>
<form id="formWordGame" action="/study/word/wordGame" method="post">
	<input type="hidden" id="hdnWords" name="words" value=""/>
</form>

<div id="toolBox" class="tool-box-wrap">
	<span id="moveToTop"class="glyphicon glyphicon-chevron-up tool-box-item"></span>
	<br>
	<br>
	<span id="moveToDown" class="glyphicon glyphicon-chevron-down tool-box-item"></span>
</div>

<div id="inputWordPop" class="input-title" >
	<div class="form-group">
		<label for="inputWord">단어</label> 
		<input id="inputWord"   class="form-control" placeholder="단어를 입력하세요." maxlength="50">
		<br>
		<label for="inputMean">뜻</label> 
		<input id="inputMean"   class="form-control" placeholder="설명을 입력하세요." maxlength="50">
	</div>
	<div id="btnWordOk" class = "pop-btn-save">확인</div>
	<div id="btnWordCancel" class="pop-btn-save">최소</div>
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
			<div class="item item-head"><span class="inner-item">오답</span></div>
			<div class="item item-head"><span class="inner-item">정답</span></div>
		</div>
		<div class="word-container" id="wordContainer">
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
	<c:if test="${fn:length(wordList) eq 0 }" var="result">
		<div id="wordReg2" class="btn-empty">단어가 없어요. 지금 등록해보세요.<br> CLICK!</div>
	</c:if>
	<div id="divWordRegWrap" class="insert-head-wrap" >
		<div id="wordReg" class="pop-btn-reg">등록</div>
	</div>
	<div id="divBotBtnWrap" class="insert-head-wrap" >
		<div id="btnDelete" class="pop-btn-float">삭제</div>
		<div id="btnTest" class="pop-btn-float-end">암기 테스트</div>
	</div>
</div>
<%--
단어  삭제
	-> 다 삭제되면 단어없어요 등록해주세요 뿌려주기
	-> 삭제 ajax 작업
	
단어게임 
	-> 선택한단어로 단어게임 시작 / 전체 단어로 시작 / 노히트 단어로만 시작
	-> 틀림횟수가 많이 증가할수록 빨간색이 됨
	-> 게임이 끝나면 통계를 보여줌(결과 통계 기록 테이블 만들지 고민필요 / 마이페이지에서 로그성으로 볼려면 만들어야함.)
--%>
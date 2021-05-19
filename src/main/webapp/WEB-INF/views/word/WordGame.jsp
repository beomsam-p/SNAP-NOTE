<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
function getRandomObj(obj){
	var arrWordKeys = Object.keys(obj);
	var keysSize = arrWordKeys.length; 
	var ranNum = Math.floor(Math.random() * keysSize);
	var ranKey = arrWordKeys[ranNum];
	var ranval = obj[ranKey];
	return ranval;
}



$(function(){
	var words = JSON.parse('${words}');
	
	var ranWord = getRandomObj(words);
	
	var ranWordNo = ranWord.wordNo;
	
	$("#question").text(ranWord.orgWord);
	
	function hideAnswer(answerWord){
		
		$(".innerCard").text("");
		
		var ranCardNum = Math.floor(Math.random() * 4);
		
		var randCard = $("#card"+(parseInt(ranCardNum)+1));
		
		randCard.text(answerWord);
		
	}
	
	function makeFakeWord(answerWord){
		
		var returnSet = new Set();
		if(Object.keys(words).length > 3){
			while(Object.keys(words).length != 1 && returnSet.size != 3){
				
				var objFakeWord = getRandomObj(words);
				
				var fakeWord = objFakeWord.convWord;
				
				if(fakeWord == answerWord){
					continue;
				}else{
					returnSet.add(fakeWord);
				}
				
				
			}
		}else{
			var wordVals = Object.values(words);
			
			$(wordVals).each(function(index, val){
				
				var fakeWord = val.convWord;
				
				if(fakeWord != answerWord){
					
					returnSet.add(fakeWord);
					
				}
				
			});
			
		}
		console.log("++++++++++++++++++++++++++++++++++++++++++");
		
		return returnSet;
		
	}
	
	function settingFakeWord(fakeWordSet){

		var arrFakeWord = Array.from(fakeWordSet);
		
		
		$(".innerCard:empty").each(function(index, item){
			
			var item = $(item);
					
			if(item.text() == ""){
				
				item.text(arrFakeWord[index]);
				
			}
			
		});

		$(".innerCard:empty").text("😅");
	}
	
	
	function wrongCountUp(wordNo){
		$.ajax({
			url : "/study/word/wrongCountUp",     
			data : {"wordNo": wordNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				common.toast("틀렸어요~");
			},
			error : function(jqXHR,status,error){
				common.toast('기록저장에 실패했어요...'+error);
			}
		});
	}
	
	function hitY(wordNo){
		$.ajax({
			url : "/study/word/updateHitY",     
			data : {"wordNo": wordNo},    
			method : "POST",        
			dataType : "json",
			error : function(jqXHR,status,error){
				common.toast('기록저장에 실패했어요...'+error);
			}
		});
	}
	
	
	hideAnswer(ranWord.convWord);
	
	var fakeWordSet = makeFakeWord(ranWord.convWord);
	
	settingFakeWord(fakeWordSet);
	
	
	$(".card").on("click", function(){
		
		var answer = $(this).find(".innerCard").text();
		
		if(answer == ranWord.convWord){
			
			common.toast("정답이에요!");
			
			hitY(ranWordNo);
			
			delete words[ranWordNo];
			
		}else{
			
			wrongCountUp(ranWordNo);
			
		}
		
		if(Object.keys(words).length != 0){
			
			ranWord = getRandomObj(words);
			
			ranWordNo = ranWord.wordNo;
			
			$("#question").text(ranWord.orgWord);
			
			$("#answer").val("");
			
			hideAnswer(ranWord.convWord);
			
			var fakeWordSet = makeFakeWord(ranWord.convWord);
			
			settingFakeWord(fakeWordSet);
			
		}else{
			
			$(".innerCard").text("😅");
			
			$("#question").html("Voctory!!");
			
			$(".card").off();
			
			common.toast("모든 단어를 맞췄어요!");
			
			$("#divBotBtnWrap").show();
			
		}
	});
	
	$("#btnGoToWordNote").on("click",function(){
		location.href = "/study/word/list"
	});



	
	
	//delete words[ranWordNo];
	//console.log(words);
	
});
</script>
	<div id="header" class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">문장 등록</span>
		</div>
	</div>
	<div class="word-game-wrap">
		<div class="question" id="question"></div> 	
		<div class="cardWrap" id="answerCardsAppendPoint" >
			<div class="card">
				<span class="innerCard" id="card1"></span>
			</div>
			<div class="card">
				<span class="innerCard" id="card2"></span>
			</div>
			<div class="card">
				<span class="innerCard" id="card3"></span>
			</div>
			<div class="card">
				<span class="innerCard" id="card4"></span>
			</div>
		</div>
	</div>
	<div id="divBotBtnWrap" class="insert-head-wrap">
		<div id="btnGoToWordNote" class="pop-btn-reg">단어장으로 돌아가기</div>
	</div>

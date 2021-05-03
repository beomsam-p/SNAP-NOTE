<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	//뒤로가기
	$("#btnBack").on("click",function(){
		location.href="/";
	});
	
	//todo: 웹버전일 때 버튼 지우기
	if(false){
		$("#btnCameraToText").hide();	
	}
	
	$("#btnFileToText").on("click",function(){
		$("#file").click();
	});
	
	$("#file").on("change",function(e){
		common.loding(true);
		
		//-------------------------------이미지 이름 얻기-----------------------------//
		var filePath = e.target.value;
		var filePathSplit = filePath.split('\\');
		var filePathLength = filePathSplit.length;
		var fileName = filePathSplit[filePathLength-1];
		//-------------------------------이미지 이름 얻기-----------------------------//
		
		//파일리더 생성
		var reader = new FileReader();
		
		reader.readAsDataURL(e.target.files[0]);
		
		//파일이 로드될경우
		reader.onload = function(event){
		    
			//이미지 객체 생성
			var img = new Image();
			
			//이미지객체에 로드된 이미지를 세팅
			img.src = event.target.result;
			
			
			//이미지  로드
		    img.onload = function(){
		    	//------------------------------- 파일 크기 변경-----------------------------//
		    	//캔버스를 가져온다
		    	var canvas = document.createElement("canvas")
		    	
		    	//캔버스를 2d로 지정한다.
		    	var ctx = canvas.getContext('2d');
		    	
		    	//로드해온 이미지를 캔버스에 채운다.
		    	canvas.width = img.width;
		    	canvas.height = img.height;
		    	ctx.drawImage(img,0,0);
		    	
		    	//최대 너비 /높이 설정
				var MAX_WIDTH = 2000;
				var MAX_HEIGHT = 3000;
				
				//입력한 이미지의 높이 / 너비 얻기
				var width = img.width;
				var height = img.height;
				
				//이미지너비가 이미지 놆이 보다 큰경우
				if(width > height)
				{
					//최대 너비보다 이미지 너비가 넓으면
				    if(width > MAX_WIDTH)
				    {
				    	//최대 너비와 너비의 비율로 높이를 줄인다.
				        height *= MAX_WIDTH / width;
				    	
				    	//너비는 최대 너비로 설정
				        width = MAX_WIDTH;
				    }
				}
				//이미지 높이가 이미지 너비보다 큰경우
				else
				{
					//최대 높이보다 이미지 높이가 크면
				    if (height > MAX_HEIGHT)
				    {
				    	//최대 너비와 이미지 너비의 비율로 너비를 줄인다.
				        width *= MAX_HEIGHT / height;
				    	
				    	//높이는 최대 높이로 한다.
				        height = MAX_HEIGHT;
				    }
				}
				
				//설정한 너비와 높이로 캔버스를 설정한다.
				canvas.width = width;
				canvas.height = height;
				
				
				// canvas에 변경된 크기의 이미지를 다시 그려줍니다.
				ctx = canvas.getContext("2d");
				ctx.drawImage(img, 0, 0, width, height);
				//------------------------------- //파일 크기 변경-----------------------------//
				
				
				//-------------------------------------데이터세팅------------------------------//
				//캔버스를 전송가능 데이터로 변경
				const imgBase64 = canvas.toDataURL('image/jpeg', 'image/octet-stream');
				const decodImg = atob(imgBase64.split(',')[1]);

				//데이터를 array에 담음
				var array = [];
				for (let i = 0; i < decodImg .length; i++) 
				{
					array.push(decodImg .charCodeAt(i));
				}
				
				//blob만들어서 form에 추가			
				const file = new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
		        var data = new FormData();
		        data.append('file', file, fileName);
		     	//-------------------------------------//데이터세팅------------------------------//
		        
		     	
		        
		        //--------------------------------------ajax------------------------------//
		        //ajax로 업로드 컨트롤러에 요청
				$.ajax({
		            type: "POST",
		            enctype: 'multipart/form-data',
		            url: "/convImgToTxt",
		            data: data,
		            processData: false,
		            contentType: false,
		            cache: false,
		            success: function (data) {
		            	
		            	common.loding(false);
						
						var sentenceArr = data.result.split('\n');
						
						$("#btnFileToText, #btnCameraToText").hide()
						
						var html=""
						
						$(sentenceArr).each(function(sentenceIdx, sentence){
							
							html += "<div name='sentence' id='sentence"+sentenceIdx+"'>"
							
							var wordArr = sentence.split(" ");
							
							$(wordArr).each(function(wordIdx, word){
								 html += "<span name='word' id='s"+sentenceIdx+"word"+wordIdx+"'>" +word+" </span>";
							})
							
							html+="</div>"
						});
						
						$("#appendPoint").append(html);
						
						$("#appendPoint").fadeIn();
						
						$("[name='word']").on("click",function(){
							console.log($(this));
						});
						
						
						$("[name='word']").on('contextmenu', function(event) {
							console.log($(this));
							var x = event.pageX;
							var y = event.pageY; 
							var $this = $(this);
							
							if($this.hasClass("word-box-on")){
								$("#menu1").text("현광펜 제거");
							}else{
								$("#menu1").text("현광펜");
							}
							
							$("#contextMenu").show();
							$("#contextMenu").css("top",y-50);
							$("#contextMenu").css("left",x);
										
							$("#menu1").click(function(){
								if($this.hasClass("word-box-on")){
									$this.removeClass("word-box-on");
								}else{
									$this.addClass("word-box-on");
								}
								
								$("#contextMenu").hide();
								
							});
							
							$("#menu2").click(function(){
								$this.addClass("word-box-on");
							});
							$("#menu3").click(function(){
								$this.addClass("word-box-on");
							});
							
							return false;
						});
						
						$("[name='sentence']").click(function(){
							$("#contextMenu").hide();
						});
						
						$(document).on('contextmenu', function() {
							return false;
						});
		            },
		            error: function (e) {
		            	common.loding(false);
		            }
		        }); 
		        
				//--------------------------------------//ajax------------------------------//
				
		    }//이미지로드 end
		    
		    
		}//파일 로드 end
	
	});
	
	$("[name='word']").click(function(){
		$("[name='word']").removeClass("word-box-temp");
		$(this).addClass("word-box-temp");
	}); 
	
	$("[name='word']").on("touchend",function(){
		console.log("touchend")
	});
	
 	$("[name='word']").on('contextmenu', function(event) {
		var x = event.pageX;
		var y = event.pageY; 
		var $this = $(this);
		
		if($this.hasClass("word-box-on")){
			
			$("#menu1").text("현광펜 제거");
			
			$("#menu1").click(function(){
				$this.removeClass("word-box-on");
				$("#contextMenu").hide();
			});
			
		}else{
			
			$("#menu1").text("현광펜");
			
			$("#menu1").click(function(){
				$this.addClass("word-box-on");
				$("#contextMenu").hide();
			});
		}
		
		$("#contextMenu").show();
		$("#contextMenu").css("top",y-50);
		$("#contextMenu").css("left",x);
					
		
		
		$("#menu2").click(function(){
			$("#contextMenu").hide();
		});
		
		$("#menu3").click(function(){
			$("#contextMenu").hide();
		});
		
		return false;
	});
	
	$("[name='sentence']").click(function(){
		$("#contextMenu").hide();
	});
	
	$(document).on('contextmenu', function() {
		return false;
	});
	 
	 
	 
	
});
</script>

<div id="contextMenu" class="context-menu-wrap">
	<span id="menu1" class="context-menu">현광펜</span> 
	<span id="menu2" class="context-menu">뜻 달기</span>
	<span id="menu3" class="context-menu">메뉴</span> 
</div>


<input type="file" id="file" name="file" style="display: none;">
<div name="sentence" id="sentenceList" class="sentenceList">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">문장 등록</span>
		</div>
		
	</div>
	<div class="sentence-wrap">
		<div class="sentence-btn-wrap">
			
			 <div id="btnFileToText" class="sentence-btn-float"  style="display: none;">사진으로 문장 등록</div>
			<div id="btnCameraToText"  class="sentence-btn-float" style="display: none;">카메라로 문장 등록</div>
			
			<div class="sentence-append-point" id="appendPoint" >
				 <div name="sentence" id="sentence0">
					<span name="word" id="word0">[Editorial] </span><span name="word" id="word1">Negative </span><span name="word" id="word2">reversal </span>
				</div>
				<div name="sentence" id="sentence1">
					<span name="word" id="word0">By </span><span name="word" id="word1">Korea </span><span name="word" id="word2">Herald </span>
					</div>
				<div name="sentence" id="sentence2">
						<span name="word" id="word0">Korea </span><span name="word" id="word1">set </span><span name="word" id="word2">to </span>
						<span name="word" id="word3">record </span><span name="word" id="word4">first </span><span name="word" id="word5">monthly </span>
						<span name="word" id="word6">current </span><span name="word" id="word7">account </span><span name="word" id="word8">deficit </span>
						<span name="word" id="word9">in </span><span name="word" id="word10">7 </span><span name="word" id="word11">years </span>
				</div>
				<div name="sentence" id="sentence3">
					<span name="word" id="word0">Published </span><span name="word" id="word1">: </span><span name="word" id="word2">Jun </span>
					<span name="word" id="word3">3, </span><span name="word" id="word4">2019 </span><span name="word" id="word5">- </span><span name="word" id="word6">17:03 </span>
				</div>
				<div name="sentence" id="sentence4">
					<span name="word" id="word0">Updated </span><span name="word" id="word1">: </span><span name="word" id="word2">Jun </span><span name="word" id="word3">3, </span>
					<span name="word" id="word4">2019 </span><span name="word" id="word5">-17:03 </span>
				</div>
				<div name="sentence" id="sentence5">
					<span name="word" id="word0">A </span><span name="word" id="word1">Afy </span>
				</div>
				<div name="sentence" id="sentence6">
					<span name="word" id="word0">South </span><span name="word" id="word1">Korea </span><span name="word" id="word2">seems </span><span name="word" id="word3">set </span>
					<span name="word" id="word4">to </span><span name="word" id="word5">record </span><span name="word" id="word6">a </span><span name="word" id="word7">current </span>
					<span name="word" id="word8">account </span><span name="word" id="word9">deficit </span><span name="word" id="word10">in </span><span name="word" id="word11">April </span>
					<span name="word" id="word12">for </span><span name="word" id="word13">the </span><span name="word" id="word14">first </span><span name="word" id="word15">time </span>
					<span name="word" id="word16">since </span>
				</div>
				<div name="sentence" id="sentence7">
					<span name="word" id="word0">May </span><span name="word" id="word1">2012 </span><span name="word" id="word2">in </span><span name="word" id="word3">yet </span>
					<span name="word" id="word4">another </span><span name="word" id="word5">warning </span><span name="word" id="word6">sign </span><span name="word" id="word7">about </span>
					<span name="word" id="word8">the </span><span name="word" id="word9">sluggish </span><span name="word" id="word10">performance </span><span name="word" id="word11">of </span>
					<span name="word" id="word12">Asia's </span><span name="word" id="word13">fourth- </span>
				</div>
				<div name="sentence" id="sentence8">
					<span name="word" id="word0">largest </span><span name="word" id="word1">economy. </span>
				</div>
				<div name="sentence" id="sentence9">
					<span name="word" id="word0">With </span><span name="word" id="word1">the </span><span name="word" id="word2">Bank </span><span name="word" id="word3">of </span>
					<span name="word" id="word4">Korea </span><span name="word" id="word5">scheduled </span><span name="word" id="word6">to </span><span name="word" id="word7">announce </span>
					<span name="word" id="word8">official </span><span name="word" id="word9">data </span><span name="word" id="word10">this </span><span name="word" id="word11">week, </span>
					<span name="word" id="word12">government </span>
				</div>
				<div name="sentence" id="sentence10">
					<span name="word" id="word0">officials </span><span name="word" id="word1">have </span><span name="word" id="word2">indicated </span><span name="word" id="word3">that </span>
					<span name="word" id="word4">the </span><span name="word" id="word5">country's </span><span name="word" id="word6">current </span><span name="word" id="word7">account </span>
					<span name="word" id="word8">balance </span><span name="word" id="word9">will </span><span name="word" id="word10">tip </span><span name="word" id="word11">into </span>
					<span name="word" id="word12">negative </span>
				</div>
				<div name="sentence" id="sentence11">
					<span name="word" id="word0">territory </span><span name="word" id="word1">after </span><span name="word" id="word2">having </span><span name="word" id="word3">been </span>
					<span name="word" id="word4">in </span><span name="word" id="word5">the </span><span name="word" id="word6">black </span><span name="word" id="word7">for </span>
					<span name="word" id="word8">83 </span><span name="word" id="word9">straight </span><span name="word" id="word10">months </span><span name="word" id="word11">through </span>
					<span name="word" id="word12">March. </span>
				</div>
				<div name="sentence" id="sentence12">
					<span name="word" id="word0">A </span><span name="word" id="word1">statement </span><span name="word" id="word2">released </span><span name="word" id="word3">Friday </span>
					<span name="word" id="word4">by </span><span name="word" id="word5">the </span><span name="word" id="word6">Ministry </span><span name="word" id="word7">of </span>
					<span name="word" id="word8">Economy </span><span name="word" id="word9">and </span><span name="word" id="word10">Finance </span><span name="word" id="word11">said </span>
					<span name="word" id="word12">there </span><span name="word" id="word13">was </span><span name="word" id="word14">a </span>
				</div>
				<div name="sentence" id="sentence13">
					<span name="word" id="word0">possibility </span><span name="word" id="word1">that </span><span name="word" id="word2">the </span><span name="word" id="word3">country </span>
					<span name="word" id="word4">would </span><span name="word" id="word5">suffer </span><span name="word" id="word6">a </span><span name="word" id="word7">"slight </span>
					<span name="word" id="word8">current </span><span name="word" id="word9">account </span><span name="word" id="word10">deficit </span><span name="word" id="word11">temporarily" </span>
					<span name="word" id="word12">in </span>
				</div>
				<div name="sentence" id="sentence14">
					<span name="word" id="word0">April </span><span name="word" id="word1">due </span><span name="word" id="word2">to </span><span name="word" id="word3">the </span>
					<span name="word" id="word4">payment </span><span name="word" id="word5">of </span><span name="word" id="word6">dividends </span><span name="word" id="word7">to </span>
					<span name="word" id="word8">offshore </span><span name="word" id="word9">investors. </span>
				</div>
				<div name="sentence" id="sentence16">
					<span name="word" id="word0">April </span><span name="word" id="word1">due </span><span name="word" id="word2">to </span><span name="word" id="word3">the </span>
					<span name="word" id="word4">payment </span><span name="word" id="word5">of </span><span name="word" id="word6">dividends </span><span name="word" id="word7">to </span>
					<span name="word" id="word8">offshore </span><span name="word" id="word9">investors. </span>
				</div>
				<div name="sentence" id="sentence17">
					<span name="word" id="word0">April </span><span name="word" id="word1">due </span><span name="word" id="word2">to </span><span name="word" id="word3">the </span>
					<span name="word" id="word4">payment </span><span name="word" id="word5">of </span><span name="word" id="word6">dividends </span><span name="word" id="word7">to </span>
					<span name="word" id="word8">offshore </span><span name="word" id="word9">investors. </span>
				</div>
			</div>
		</div>
		
		<div class="sentence-box">
			<input type="text" >
		</div>
	</div>
</div>
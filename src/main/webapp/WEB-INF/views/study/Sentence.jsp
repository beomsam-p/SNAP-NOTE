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
	
	$("#btnCameraToText").on("click",function(){
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
		            	$("#btnFileToText, #btnCameraToText").hide();
		            	$("#appendPoint").append(data.result);
						
		            	$("#appendPoint").fadeIn();
		            	
						$("[name='word']").off().click(function(){
							$("[name='word']").removeClass("word-box-temp");
							$(this).addClass("word-box-temp");
						}); 
						
						$("[name='word']").off().on("touchend",function(){
							console.log("touchend")
						});
						
						$(document).off().on('contextmenu', function(event) {
					 		var $this = $(this);

							var selection = window.getSelection();
							var range  = selection.getRangeAt(0);

							var $selectedNode = $(selection.extentNode.parentNode);
							var selectedNode = selection.extentNode.parentNode;
							
					 		if(editMode){
					 			return;
					 		}
					 		
					 		var x = event.pageX;
							var y = event.pageY;
							
							if($selectedNode.hasClass("word-box-on")){
								if(x+200 > window.innerWidth  ){
									x = x - ((x+220) - window.innerWidth);
								}
								
								$("#menu1").text("현광펜 제거");
								
								if($selectedNode.children(".words").length == 0){
									$("#menu2").show();
						 		}else{
						 			$("#menu2").hide();
						 		}
								
								$("#menu3").show();						
								
								$("#menu1").off().click(function(){
									var id = $selectedNode.attr("id");
									$("#word"+id).remove();
								
									var nodeText = $selectedNode.text();
									$selectedNode.remove();
									range.insertNode(document.createTextNode(nodeText));
									
									$("#contextMenu").hide();
								});
							}else{
								if(x+100 > window.innerWidth  ){
									x = x - ((x+100) - window.innerWidth);
								}
							
								
								$("#menu1").text("현광펜");
								$("#menu2").hide();
								$("#menu3").hide();
								$("#menu1").off().click(function(){
									var extractText = range.extractContents().textContent;
									var newNode = document.createElement('span');
									newNode.innerHTML = extractText;
									newNode.className = "word-box-on";
									newNode.id = highlightIdx;
									range.insertNode(newNode);
									highlightIdx++;
									$("#contextMenu").hide();
								});
							} 

							$("#contextMenu").css("top",y-50);
							$("#contextMenu").css("left",x);
							$("#contextMenu").show();
							
							
							$("#menu2").off().click(function(){
								common.loding(true);
								$("#inputWord").show();
								$("#contextMenu").hide();
							});
							
							$("#btnWordOk").off().click(function(){
								var wordVal = $("#word").val();
								if(wordVal.trim()==""){
									alert("단어를 입력해주세요.");
									return;
								}
								
								var top = $selectedNode.offset().top;
								var left = $selectedNode.offset().left;
								
								console.log("selectedNode left::"+left);
							
								var wordNode = document.createElement('span');
								
								wordNode.innerHTML = wordVal;
								wordNode.style.position = 'absolute';
								wordNode.style.fontSize = '10px';
								wordNode.style.width = $selectedNode.css("width");
								wordNode.className = 'words';
								wordNode.id = "word"+$selectedNode.attr("id");
								
								range.setStart(selectedNode,0);
								range.insertNode(wordNode);
								
								//header.append(wordNode);
								common.loding(false);
								
								$("#inputWord").hide();
								
								$("#word").val("");
							});
							
							$("#btnWordCancel").off().click(function(){
								common.loding(false);
								$("#inputWord").hide();
							});
							
							
							
							$("#menu3").off().click(function(){
								//todo
								//단어장에 저장
							});
							
							return false;
						});
						
						
						$("[name='sentence']").click(function(){
							$("#contextMenu").hide();
						});
						
						$(document).on('contextmenu', function() {
							return false;
						});
						
						 
						$("#btnFixText").on("click",function(){
							if(!confirm("내용을 저장하면 다시 수정 하실 수 없습니다.\r\n저장 하시겠습니까?")){
								return;
							}
							$("#contextMenu").hide();
							var appendPoint = $("#appendPoint");
							$(this).remove();
							appendPoint.removeAttr("contentEditable");
							appendPoint.removeClass("text-on");
							editMode = false;
						});
						
						
						var scroll_x = 0;
						var appendPoint = $("#appendPoint");
						
						$("#appendPoint").on('mousewheel', function(e){
							toggleHaderAndBotNav(e.originalEvent.wheelDelta, 0);
					    });
						
						
						$("#appendPoint").on("touchstart",function(e){
							scroll_x= appendPoint.scrollTop();
						});
						
						$("#appendPoint").on("touchend",function(e){
							var crrent_x =appendPoint.scrollTop();
							toggleHaderAndBotNav(scroll_x, crrent_x);
						});
						
						$("#toggleWord").on("click",function(){
							var toggleWord = $(this);
							if(toggleWord.hasClass("glyphicon-unchecked")){
								toggleWord.removeClass("glyphicon-unchecked");
								toggleWord.addClass("glyphicon-check");
								//todo
								//단어보임
							}else{
								toggleWord.addClass("glyphicon-unchecked");
								toggleWord.removeClass("glyphicon-check");
								//todo
								//단어안보임
							}
						});

						
						$("#moveToTop").on("click",function(){
							var appendPoint = $("#appendPoint");
							appendPoint.animate({scrollTop:'0'},1000);
						});
						
						$("#moveToDown").on("click",function(){
							var appendPoint = $("#appendPoint");
							appendPoint.animate({scrollTop:appendPoint.prop("scrollHeight")},1000);
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
	 
	var editMode = true; 
	var highlightIdx = 0;
	var lastHighlightIdx = -1;
	
	var wordBoxOn = $(".word-box-on");
	
	wordBoxOn.each(function(index, item){
		var temp;
		if(wordBoxOn[index+1]){
			if(wordBoxOn[index].getAttribute("id") > wordBoxOn[index+1].getAttribute("id")){
				temp = wordBoxOn[index];
				wordBoxOn[index] = wordBoxOn[index+1];
				wordBoxOn[index+1] = temp;
			}	
		}
	});
	
	try{
		lastHighlightIdx = wordBoxOn[wordBoxOn.length-1].getAttribute("id");
	}catch(err){
		lastHighlightIdx = -1;
	}
	
	
	if(lastHighlightIdx >-1){
		highlightIdx = parseInt(lastHighlightIdx)+1;
	}
	
 	$(document).off().on('contextmenu', function(event) {
 		var $this = $(this);

		var selection = window.getSelection();
		var range  = selection.getRangeAt(0);

		var $selectedNode = $(selection.extentNode.parentNode);
		var selectedNode = selection.extentNode.parentNode;
		
 		if(editMode){
 			return;
 		}
 		
 		var x = event.pageX;
		var y = event.pageY;
		
		if($selectedNode.hasClass("word-box-on")){
			if(x+200 > window.innerWidth  ){
				x = x - ((x+220) - window.innerWidth);
			}
			
			$("#menu1").text("현광펜 제거");
			
			if($selectedNode.children(".glyphicon-tag").length == 0){
				$("#menu2").show();
	 		}else{
	 			$("#menu2").hide();
	 		}
			
			$("#menu3").show();						
			
			$("#menu1").off().click(function(){
				var id = $selectedNode.attr("id");
				$("#word"+id).remove();
			
				var nodeText = $selectedNode.text();
				$selectedNode.remove();
				range.insertNode(document.createTextNode(nodeText));
				
				$("#contextMenu").hide();
			});
			
		}else{
			
			if(x+100 > window.innerWidth  ){
				x = x - ((x+100) - window.innerWidth);
			}
			
			$("#menu1").text("현광펜");
			$("#menu2").hide();
			$("#menu3").hide();
			
			$("#menu1").off().click(function(){
				var extractText = range.extractContents().textContent;
				var newNode = document.createElement('span');
				newNode.innerHTML = extractText;
				newNode.className = "word-box-on";
				newNode.id = highlightIdx;
				range.insertNode(newNode);
				highlightIdx++;
				$("#contextMenu").hide();
			});
		} 

		$("#contextMenu").css("top",y-50);
		$("#contextMenu").css("left",x);
		$("#contextMenu").show();
		
		
		$("#menu2").off().click(function(){
			common.loding(true);
			$("#inputWord").show();
			$("#contextMenu").hide();
		});
		
		$("#btnWordOk").off().click(function(){
			var wordVal = $("#word").val();
			if(wordVal.trim()==""){
				alert("단어를 입력해주세요.");
				return;
			}
			
			var top = $selectedNode.offset().top;
			var left = $selectedNode.offset().left;
			
			var wordNode = document.createElement('span');
			
			//wordNode.innerHTML = wordVal;
			//wordNode.innerHTML = "&nbsp;";
			//wordNode.style.position = 'absolute';
			//wordNode.style.fontSize = '10px';
			wordNode.style.fontSize = '0.5em';
			//wordNode.style.width = "100px";
			wordNode.className = 'glyphicon glyphicon-tag';
			wordNode.id = "word"+$selectedNode.attr("id");

			console.log(range);
			
			//range.setStart(selectedNode,1);
			//range.insertNode(wordNode);
			$("#"+$selectedNode.attr("id")).after(wordNode);
			
			//header.append(wordNode);
			common.loding(false);
			
			$("#inputWord").hide();
			
			$("#word").val("");
			
			$("#"+$selectedNode.attr("id")).on("click",function(){
				common.loding(true);
				$("#viewWord").show();
				$("#orgWord").val($selectedNode.text());
				$("#meanWord").val(wordVal);
			});
		});
		
		$("#btnWordCancel").off().click(function(){
			common.loding(false);
			$("#inputWord").hide();
		});
		
		$("#btnViewWordOk").on("click",function(){
			common.loding(false);
			$("#viewWord").hide();
		});
		
		$("#menu3").off().click(function(){
			//todo
			//단어장에 저장
		});
		
		return false;
	});
	
	$("[name='sentence']").click(function(){
		$("#contextMenu").hide();
	});
	
	$(document).on('contextmenu', function() {
		return false;
	});
	
	 
	$("#btnFixText").on("click",function(){
		if(!confirm("내용을 저장하면 다시 수정 하실 수 없습니다.\r\n저장 하시겠습니까?")){
			return;
		}
		$("#contextMenu").hide();
		var appendPoint = $("#appendPoint");
		$(this).remove();
		appendPoint.removeAttr("contentEditable");
		appendPoint.removeClass("text-on");
		editMode = false;
	});
	 
	var scroll_x = 0;
	var appendPoint = $("#appendPoint");
	
	$("#appendPoint").on('mousewheel', function(e){
		toggleHaderAndBotNav(e.originalEvent.wheelDelta, 0);
    });
	
	
	$("#appendPoint").on("touchstart",function(e){
		scroll_x= appendPoint.scrollTop();
	});
	
	$("#appendPoint").on("touchend",function(e){
		var crrent_x =appendPoint.scrollTop();
		toggleHaderAndBotNav(scroll_x, crrent_x);
	});
	
	$("#toggleWord").on("click",function(){
		var toggleWord = $(this);
		if(toggleWord.hasClass("glyphicon-unchecked")){
			toggleWord.removeClass("glyphicon-unchecked");
			toggleWord.addClass("glyphicon-check");
			//todo
			//단어보임
		}else{
			toggleWord.addClass("glyphicon-unchecked");
			toggleWord.removeClass("glyphicon-check");
			//todo
			//단어안보임
		}
	});

	
	$("#moveToTop").on("click",function(){
		var appendPoint = $("#appendPoint");
		appendPoint.animate({scrollTop:'0'},1000);
	});
	
	$("#moveToDown").on("click",function(){
		var appendPoint = $("#appendPoint");
		appendPoint.animate({scrollTop:appendPoint.prop("scrollHeight")},1000);
	});
	
	
	
	
	$("#btnSaveSentence").on("click",function(){
		if(!confirm("작업내용을 저장하시겠습니까?")){
			return;
		}
		
		$.ajax({
			url : "/member/loginProc",     
			data : {"id" : id.val(), "pwd" : pwd.val(),"saveId":saveId },    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				console.log(data);
				common.loding(false);
				
				if(data != null && data.result == "00"){
					location.href="/my/myHome"
				}
				else{
					common.showModal('SNAP NOTE 로그인',data.errorMsg);
				}
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.showModal('SNAP NOTE 로그인','에러발생 :<br>'+error);
			}
		});
		
		
	});
	
	
	
	
/* 	$("#appendPoint").off().click(function(){
		$("#toolBox").fadeOut();
	}); 
	
	$("#appendPoint").off().on("touchend",function(){
		$("#toolBox").fadeOut();
	}); 
	$(window).resize(function (){
		wordsRePosition();
	});
	
	wordsRePosition();
	
	function wordsRePosition(){
		$(".words").each(function(wordIdx, word){
			var wordId ="#"+ $(word).attr("id").split("word")[1];
			var top = $(wordId).offset().top;
			var left = $(wordId).offset().left;
			$(word).offset({"top":top-30 , "left":left});
		});
	} */
	
	function toggleHaderAndBotNav(oldScroll, crrentScroll){
		var header = $("#header");
		var botNav = $("#botNav");
		var btnFixText = $("#btnFixText");
		var toolBox = $("#toolBox")
		
		if(oldScroll < crrentScroll){
			header.fadeOut();
			botNav.fadeOut();
			btnFixText.fadeOut();
			toolBox.fadeIn();
		}else if(oldScroll > crrentScroll){
			header.fadeIn();
			botNav.fadeIn();
			btnFixText.fadeIn();
			toolBox.fadeOut();
		}else{
			header.fadeOut();
			botNav.fadeOut();
			btnFixText.fadeOut();
		}
	}
	
	
	
});
</script>

<div id="contextMenu" class="context-menu-wrap">
	<span id="menu1" class="context-menu">현광펜</span> 
	<span id="menu2"  class="context-menu">뜻 달기</span>
	<span id="menu3" class="context-menu">단어저장</span> 
</div>

<div id="toolBox" class="tool-box-wrap">
	<span id="moveToTop"class="glyphicon glyphicon-chevron-up tool-box-item"></span>
	<br>
	<span id="toggleWord" class="glyphicon glyphicon-check tool-box-item"></span>
	<br>
	<span id="moveToDown" class="glyphicon glyphicon-chevron-down tool-box-item"></span>
</div>

<div id="inputWord" class="input-word" >
	<div class="form-group">
		<input id="word" type="text" class="form-control"  placeholder="단어의 뜻을 입력하세요." >
		<div id="btnWordOk" class = "pop-btn-save">확인</div>
		<div id="btnWordCancel" class="pop-btn-save">최소</div>
	</div>
</div>

<div id="viewWord" class="input-word" >
	<div class="form-group">
		<input id="orgWord" type="text" class="form-control"  readonly="readonly">
		<input id="meanWord" type="text" class="form-control"  readonly="readonly">
		<div id="btnViewWordOk" class = "pop-btn-full">확인</div>
	</div>
</div>

<div id="btnFixText" class="sentence-btn-full">텍스트 고정</div>
<div id="btnSaveSentence" class="sentence-btn-full" style="display: none;">내용 저장</div>

<input type="file" id="file" name="file" style="display: none;" capture="camera" accept="image/*">


<div name="sentence" id="sentenceList" class="sentenceList">
	<div id="header" class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">문장 등록</span>
		</div>
	</div>
	
	<div class="sentence-wrap">
		<!-- 
		<div class="sentence-append-point" id="appendPoint" >
			<span name="word" id="0">[Editorial]&nbsp;</span><span name="word" id="1">Negative&nbsp;</span><span name="word" id="2">reversal&nbsp;</span><span><br></span><span name="word" id="3">By&nbsp;</span><span name="word" id="4">Korea&nbsp;</span><span name="word" id="5">Herald&nbsp;</span><span><br></span><span name="word" id="6">Korea&nbsp;</span><span name="word" id="7">set&nbsp;</span><span name="word" id="8">to&nbsp;</span><span name="word" id="9">record&nbsp;</span><span name="word" id="10">first&nbsp;</span><span name="word" id="11">monthly&nbsp;</span><span name="word" id="12">current&nbsp;</span><span name="word" id="13">account&nbsp;</span><span name="word" id="14">deficit&nbsp;</span><span name="word" id="15">in&nbsp;</span><span name="word" id="16">7&nbsp;</span><span name="word" id="17">years&nbsp;</span><span><br></span><span name="word" id="18">Published&nbsp;</span><span name="word" id="19">:&nbsp;</span><span name="word" id="20">Jun&nbsp;</span><span name="word" id="21">3,&nbsp;</span><span name="word" id="22">2019&nbsp;</span><span name="word" id="23">-&nbsp;</span><span name="word" id="24">17:03&nbsp;</span><span><br></span><span name="word" id="25">Updated&nbsp;</span><span name="word" id="26">:&nbsp;</span><span name="word" id="27">Jun&nbsp;</span><span name="word" id="28">3,&nbsp;</span><span name="word" id="29">2019&nbsp;</span><span name="word" id="30">-17:03&nbsp;</span><span><br></span><span name="word" id="31">A&nbsp;</span><span name="word" id="32">Afy&nbsp;</span><span><br></span><span name="word" id="33">South&nbsp;</span><span name="word" id="34">Korea&nbsp;</span><span name="word" id="35">seems&nbsp;</span><span name="word" id="36">set&nbsp;</span><span name="word" id="37">to&nbsp;</span><span name="word" id="38">record&nbsp;</span><span name="word" id="39">a&nbsp;</span><span name="word" id="40">current&nbsp;</span><span name="word" id="41">account&nbsp;</span><span name="word" id="42">deficit&nbsp;</span><span name="word" id="43">in&nbsp;</span><span name="word" id="44">April&nbsp;</span><span name="word" id="45">for&nbsp;</span><span name="word" id="46">the&nbsp;</span><span name="word" id="47">first&nbsp;</span><span name="word" id="48">time&nbsp;</span><span name="word" id="49">since&nbsp;</span><span><br></span><span name="word" id="50">May&nbsp;</span><span name="word" id="51">2012&nbsp;</span><span name="word" id="52">in&nbsp;</span><span name="word" id="53">yet&nbsp;</span><span name="word" id="54">another&nbsp;</span><span name="word" id="55">warning&nbsp;</span><span name="word" id="56">sign&nbsp;</span><span name="word" id="57">about&nbsp;</span><span name="word" id="58">the&nbsp;</span><span name="word" id="59">sluggish&nbsp;</span><span name="word" id="60">performance&nbsp;</span><span name="word" id="61">of&nbsp;</span><span name="word" id="62">Asia's&nbsp;</span><span name="word" id="63">fourth-&nbsp;</span><span><br></span><span name="word" id="64">largest&nbsp;</span><span name="word" id="65">economy.&nbsp;</span><span><br></span><span name="word" id="66">With&nbsp;</span><span name="word" id="67">the&nbsp;</span><span name="word" id="68">Bank&nbsp;</span><span name="word" id="69">of&nbsp;</span><span name="word" id="70">Korea&nbsp;</span><span name="word" id="71">scheduled&nbsp;</span><span name="word" id="72">to&nbsp;</span><span name="word" id="73">announce&nbsp;</span><span name="word" id="74">official&nbsp;</span><span name="word" id="75">data&nbsp;</span><span name="word" id="76">this&nbsp;</span><span name="word" id="77">week,&nbsp;</span><span name="word" id="78">government&nbsp;</span><span><br></span><span name="word" id="79">officials&nbsp;</span><span name="word" id="80">have&nbsp;</span><span name="word" id="81">indicated&nbsp;</span><span name="word" id="82">that&nbsp;</span><span name="word" id="83">the&nbsp;</span><span name="word" id="84">country's&nbsp;</span><span name="word" id="85">current&nbsp;</span><span name="word" id="86">account&nbsp;</span><span name="word" id="87">balance&nbsp;</span><span name="word" id="88">will&nbsp;</span><span name="word" id="89">tip&nbsp;</span><span name="word" id="90">into&nbsp;</span><span name="word" id="91">negative&nbsp;</span><span><br></span><span name="word" id="92">territory&nbsp;</span><span name="word" id="93">after&nbsp;</span><span name="word" id="94">having&nbsp;</span><span name="word" id="95">been&nbsp;</span><span name="word" id="96">in&nbsp;</span><span name="word" id="97">the&nbsp;</span><span name="word" id="98">black&nbsp;</span><span name="word" id="99">for&nbsp;</span><span name="word" id="100">83&nbsp;</span><span name="word" id="101">straight&nbsp;</span><span name="word" id="102">months&nbsp;</span><span name="word" id="103">through&nbsp;</span><span name="word" id="104">March.&nbsp;</span><span><br></span><span name="word" id="105">A&nbsp;</span><span name="word" id="106">statement&nbsp;</span><span name="word" id="107">released&nbsp;</span><span name="word" id="108">Friday&nbsp;</span><span name="word" id="109">by&nbsp;</span><span name="word" id="110">the&nbsp;</span><span name="word" id="111">Ministry&nbsp;</span><span name="word" id="112">of&nbsp;</span><span name="word" id="113">Economy&nbsp;</span><span name="word" id="114">and&nbsp;</span><span name="word" id="115">Finance&nbsp;</span><span name="word" id="116">said&nbsp;</span><span name="word" id="117">there&nbsp;</span><span name="word" id="118">was&nbsp;</span><span name="word" id="119">a&nbsp;</span><span><br></span><span name="word" id="120">possibility&nbsp;</span><span name="word" id="121">that&nbsp;</span><span name="word" id="122">the&nbsp;</span><span name="word" id="123">country&nbsp;</span><span name="word" id="124">would&nbsp;</span><span name="word" id="125">suffer&nbsp;</span><span name="word" id="126">a&nbsp;</span><span name="word" id="127">"slight&nbsp;</span><span name="word" id="128">current&nbsp;</span><span name="word" id="129">account&nbsp;</span><span name="word" id="130">deficit&nbsp;</span><span name="word" id="131">temporarily"&nbsp;</span><span name="word" id="132">in&nbsp;</span><span><br></span><span name="word" id="133">April&nbsp;</span><span name="word" id="134">due&nbsp;</span><span name="word" id="135">to&nbsp;</span><span name="word" id="136">the&nbsp;</span><span name="word" id="137">payment&nbsp;</span><span name="word" id="138">of&nbsp;</span><span name="word" id="139">dividends&nbsp;</span><span name="word" id="140">to&nbsp;</span><span name="word" id="141">offshore&nbsp;</span><span name="word" id="142">investors.&nbsp;</span><span><br></span><span name="word" id="143">&nbsp;</span><span><br></span>
		</div> 
		-->
		<div class="sentence-append-point text-on" id="appendPoint"  contentEditable="true" style="display: none;">
			<!-- 	
			[Editorial] <span class="word-box-on" id="0">Negative</span><span class="glyphicon glyphicon-tag" id="word0" style="font-size: 0.5em;"></span> reversal
			By Korea Herald
			Korea set to <span class="word-box-on" id="2">record </span><span class="glyphicon glyphicon-tag" id="word2" style="font-size: 0.5em;"></span>first monthly current account deficit in 7 years
			Published : Jun 3, 2019 - 17:03
			Updated : <span class="word-box-on" id="1">Jun </span><span class="glyphicon glyphicon-tag" id="word1" style="font-size: 0.5em;"></span>3, 2019 -17:03
			A Afy
			South Korea seems set to record a current <span class="word-box-on" id="5">account </span><span class="glyphicon glyphicon-tag" id="word5" style="font-size: 0.5em;"></span>deficit in <span class="word-box-on" id="4">April </span><span class="glyphicon glyphicon-tag" id="word4" style="font-size: 0.5em;"></span>for the first time since
			May 2012 in yet another warning sign about the sluggish <span class="word-box-on" id="3">performance </span><span class="glyphicon glyphicon-tag" id="word3" style="font-size: 0.5em;"></span>of Asia's fourth-
			largest economy.
			With the Bank of Korea scheduled to announce official data this week, government
			officials have indicated that the country's current account balance will tip into negative
			territory after having been in the black for 83 straight months through March.
			A statement released Friday by the Ministry of Economy and Finance said there was a
			possibility that the country would suffer a "slight current account deficit temporarily" in
			April due to the payment of dividends to offshore investors. 
			
			
			[Editorial] Negative reversal
			By Korea Herald
			Korea set to record first monthly current account deficit in 7 years
			Published : Jun 3, 2019 - 17:03
			Updated : Jun 3, 2019 -17:03
			A Afy
			South Korea seems set to record a current account deficit in for the first time since
			May 2012 in yet another warning sign about the sluggish performance of Asia's fourth-
			largest economy.
			With the Bank of Korea scheduled to announce official data this week, government
			officials have indicated that the country's current account balance will tip into negative
			territory after having been in the black for 83 straight months through March.
			A statement released Friday by the Ministry of Economy and Finance said there was a
			possibility that the country would suffer a "slight current account deficit temporarily" in
			April due to the payment of dividends to offshore investors.
			-->
		</div>
		
		<div class="sentence-btn-wrap"  >
			<div id="btnFileToText" class="sentence-btn-float">사진으로 문장 등록</div>
			<div id="btnCameraToText"  class="sentence-btn-float" >카메라로 문장 등록</div>
			
		</div>
		
		
		<div class="sentence-box">
			<input type="text" >
		</div>
	</div>
</div>
<%--주요 문제점
	
	폴더번호 문장파일번호 url 로 접근하는 것 정의 필요 
	문장파일 저장 기능 필요
	불러왔을 때 달아 놓은 뜻 클릭이벤트 바운드 필요
	뜻은 단어 테이블에서 가져와야함
	문장 저장시 단어 테이블에 단어 저장 필요.
	
	
	1. 문장이미지에서 문장 변환 후 한번 텍스트 수정 가능함
	2. 단어 뜻 위치는 방법을 찾아야함.
--%>
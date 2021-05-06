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
		            	$("#btnFileToText, #btnCameraToText").hide();
		            	$("#appendPoint").append(data.result.replace("\n","<br>"));
						
		            	$("#appendPoint").fadeIn();
						
						$("[name='word']").off().click(function(){
							$("[name='word']").removeClass("word-box-temp");
							$(this).addClass("word-box-temp");
						}); 
						
						$("[name='word']").off().on("touchend",function(){
							console.log("touchend")
						});
						
					 	$("[name='word']").off().on('contextmenu', function(event) {
							var x = event.pageX;
							var y = event.pageY; 
							
							if($selectedNode.hasClass("word-box-on")){
								$("#menu1").text("현광펜 제거");
								$("#menu1").off().click(function(){
									var nodeText = $selectedNode.text();
									$selectedNode.remove();
									range.insertNode(document.createTextNode(nodeText));
									//$selectedNode.removeClass("word-box-on");
									
									$("#contextMenu").hide();
								});
							}else{
								$("#menu1").text("현광펜");
								$("#menu1").off().click(function(){
									var extractText = range.extractContents().textContent;
									var newNode = document.createElement('span');
									newNode.innerHTML = extractText;
									newNode.className = "word-box-on";
									range.insertNode(newNode);
									
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
						 
		            },
		            error: function (e) {
		            	common.loding(false);
		            }
		        }); 
		        
				//--------------------------------------//ajax------------------------------//
				
		    }//이미지로드 end
		    
		    
		}//파일 로드 end
	
	});
	/* 
	 $("[name='word']").off().click(function(){
		$("[name='word']").removeClass("");
		$(this).addClass("word-box-temp");
	}); 
	
	$("[name='word']").off().on("touchend",function(){
		console.log("touchend")
	}); */
	
 	$(document).off().on('contextmenu', function(event) {
 	
		var x = event.pageX;
		var y = event.pageY;
		if(x+200 > screen.width ){
			x = x - ((x+200) - screen.width);
		}
		
		var $this = $(this);
		
	

		var selObj = window.getSelection();
		var range  = selObj.getRangeAt(0);
		
		var $selectedNode=$(selObj.extentNode.parentNode);
 		
		if($selectedNode.hasClass("word-box-on")){
			$("#menu1").text("현광펜 제거");
			$("#menu1").off().click(function(){
				var nodeText = $selectedNode.text();
				$selectedNode.remove();
				range.insertNode(document.createTextNode(nodeText));
				//$selectedNode.removeClass("word-box-on");
				
				$("#contextMenu").hide();
			});
		}else{
			$("#menu1").text("현광펜");
			$("#menu1").off().click(function(){
				var extractText = range.extractContents().textContent;
				var newNode = document.createElement('span');
				newNode.innerHTML = extractText;
				newNode.className = "word-box-on";
				range.insertNode(newNode);
				
				$("#contextMenu").hide();
			});
		} 
		
		$("#contextMenu").show();
		$("#contextMenu").css("top",y-50);
		$("#contextMenu").css("left",x);
					
		
		
		$("#menu2").off().click(function(){
			
		});
		
		
		
		$("#menu3").off().click(function(){
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
		
		if($("#appendPoint").attr("contentEditable")){
			alert("내용이 저장되었습니다.");
			$("#appendPoint").removeAttr("contentEditable");
			$("#appendPoint").removeClass("text-on");
			
		}else{
			alert("내용이 수정합니다");
			$("#appendPoint").attr("contentEditable",true);
			$("#appendPoint").addClass("text-on");
			$("#appendPoint").focus();
		}
		
	});
	
});
</script>

<div id="contextMenu" class="context-menu-wrap">
	<span id="menu1" class="context-menu">현광펜</span> 
	<span id="menu2" class="context-menu">뜻 달기</span>
	<span id="menu3" class="context-menu">삭제</span> 
</div>

<div id="btnFixText" class="sentence-btn-full">문장 입력</div>

<input type="file" id="file" name="file" style="display: none;" >
<div name="sentence" id="sentenceList" class="sentenceList">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">문장 등록</span>
		</div>
		
	</div>
	<div class="sentence-wrap">
		<!-- <div class="sentence-append-point" id="appendPoint" >
			<span name="word" id="0">[Editorial]&nbsp;</span><span name="word" id="1">Negative&nbsp;</span><span name="word" id="2">reversal&nbsp;</span><span><br></span><span name="word" id="3">By&nbsp;</span><span name="word" id="4">Korea&nbsp;</span><span name="word" id="5">Herald&nbsp;</span><span><br></span><span name="word" id="6">Korea&nbsp;</span><span name="word" id="7">set&nbsp;</span><span name="word" id="8">to&nbsp;</span><span name="word" id="9">record&nbsp;</span><span name="word" id="10">first&nbsp;</span><span name="word" id="11">monthly&nbsp;</span><span name="word" id="12">current&nbsp;</span><span name="word" id="13">account&nbsp;</span><span name="word" id="14">deficit&nbsp;</span><span name="word" id="15">in&nbsp;</span><span name="word" id="16">7&nbsp;</span><span name="word" id="17">years&nbsp;</span><span><br></span><span name="word" id="18">Published&nbsp;</span><span name="word" id="19">:&nbsp;</span><span name="word" id="20">Jun&nbsp;</span><span name="word" id="21">3,&nbsp;</span><span name="word" id="22">2019&nbsp;</span><span name="word" id="23">-&nbsp;</span><span name="word" id="24">17:03&nbsp;</span><span><br></span><span name="word" id="25">Updated&nbsp;</span><span name="word" id="26">:&nbsp;</span><span name="word" id="27">Jun&nbsp;</span><span name="word" id="28">3,&nbsp;</span><span name="word" id="29">2019&nbsp;</span><span name="word" id="30">-17:03&nbsp;</span><span><br></span><span name="word" id="31">A&nbsp;</span><span name="word" id="32">Afy&nbsp;</span><span><br></span><span name="word" id="33">South&nbsp;</span><span name="word" id="34">Korea&nbsp;</span><span name="word" id="35">seems&nbsp;</span><span name="word" id="36">set&nbsp;</span><span name="word" id="37">to&nbsp;</span><span name="word" id="38">record&nbsp;</span><span name="word" id="39">a&nbsp;</span><span name="word" id="40">current&nbsp;</span><span name="word" id="41">account&nbsp;</span><span name="word" id="42">deficit&nbsp;</span><span name="word" id="43">in&nbsp;</span><span name="word" id="44">April&nbsp;</span><span name="word" id="45">for&nbsp;</span><span name="word" id="46">the&nbsp;</span><span name="word" id="47">first&nbsp;</span><span name="word" id="48">time&nbsp;</span><span name="word" id="49">since&nbsp;</span><span><br></span><span name="word" id="50">May&nbsp;</span><span name="word" id="51">2012&nbsp;</span><span name="word" id="52">in&nbsp;</span><span name="word" id="53">yet&nbsp;</span><span name="word" id="54">another&nbsp;</span><span name="word" id="55">warning&nbsp;</span><span name="word" id="56">sign&nbsp;</span><span name="word" id="57">about&nbsp;</span><span name="word" id="58">the&nbsp;</span><span name="word" id="59">sluggish&nbsp;</span><span name="word" id="60">performance&nbsp;</span><span name="word" id="61">of&nbsp;</span><span name="word" id="62">Asia's&nbsp;</span><span name="word" id="63">fourth-&nbsp;</span><span><br></span><span name="word" id="64">largest&nbsp;</span><span name="word" id="65">economy.&nbsp;</span><span><br></span><span name="word" id="66">With&nbsp;</span><span name="word" id="67">the&nbsp;</span><span name="word" id="68">Bank&nbsp;</span><span name="word" id="69">of&nbsp;</span><span name="word" id="70">Korea&nbsp;</span><span name="word" id="71">scheduled&nbsp;</span><span name="word" id="72">to&nbsp;</span><span name="word" id="73">announce&nbsp;</span><span name="word" id="74">official&nbsp;</span><span name="word" id="75">data&nbsp;</span><span name="word" id="76">this&nbsp;</span><span name="word" id="77">week,&nbsp;</span><span name="word" id="78">government&nbsp;</span><span><br></span><span name="word" id="79">officials&nbsp;</span><span name="word" id="80">have&nbsp;</span><span name="word" id="81">indicated&nbsp;</span><span name="word" id="82">that&nbsp;</span><span name="word" id="83">the&nbsp;</span><span name="word" id="84">country's&nbsp;</span><span name="word" id="85">current&nbsp;</span><span name="word" id="86">account&nbsp;</span><span name="word" id="87">balance&nbsp;</span><span name="word" id="88">will&nbsp;</span><span name="word" id="89">tip&nbsp;</span><span name="word" id="90">into&nbsp;</span><span name="word" id="91">negative&nbsp;</span><span><br></span><span name="word" id="92">territory&nbsp;</span><span name="word" id="93">after&nbsp;</span><span name="word" id="94">having&nbsp;</span><span name="word" id="95">been&nbsp;</span><span name="word" id="96">in&nbsp;</span><span name="word" id="97">the&nbsp;</span><span name="word" id="98">black&nbsp;</span><span name="word" id="99">for&nbsp;</span><span name="word" id="100">83&nbsp;</span><span name="word" id="101">straight&nbsp;</span><span name="word" id="102">months&nbsp;</span><span name="word" id="103">through&nbsp;</span><span name="word" id="104">March.&nbsp;</span><span><br></span><span name="word" id="105">A&nbsp;</span><span name="word" id="106">statement&nbsp;</span><span name="word" id="107">released&nbsp;</span><span name="word" id="108">Friday&nbsp;</span><span name="word" id="109">by&nbsp;</span><span name="word" id="110">the&nbsp;</span><span name="word" id="111">Ministry&nbsp;</span><span name="word" id="112">of&nbsp;</span><span name="word" id="113">Economy&nbsp;</span><span name="word" id="114">and&nbsp;</span><span name="word" id="115">Finance&nbsp;</span><span name="word" id="116">said&nbsp;</span><span name="word" id="117">there&nbsp;</span><span name="word" id="118">was&nbsp;</span><span name="word" id="119">a&nbsp;</span><span><br></span><span name="word" id="120">possibility&nbsp;</span><span name="word" id="121">that&nbsp;</span><span name="word" id="122">the&nbsp;</span><span name="word" id="123">country&nbsp;</span><span name="word" id="124">would&nbsp;</span><span name="word" id="125">suffer&nbsp;</span><span name="word" id="126">a&nbsp;</span><span name="word" id="127">"slight&nbsp;</span><span name="word" id="128">current&nbsp;</span><span name="word" id="129">account&nbsp;</span><span name="word" id="130">deficit&nbsp;</span><span name="word" id="131">temporarily"&nbsp;</span><span name="word" id="132">in&nbsp;</span><span><br></span><span name="word" id="133">April&nbsp;</span><span name="word" id="134">due&nbsp;</span><span name="word" id="135">to&nbsp;</span><span name="word" id="136">the&nbsp;</span><span name="word" id="137">payment&nbsp;</span><span name="word" id="138">of&nbsp;</span><span name="word" id="139">dividends&nbsp;</span><span name="word" id="140">to&nbsp;</span><span name="word" id="141">offshore&nbsp;</span><span name="word" id="142">investors.&nbsp;</span><span><br></span><span name="word" id="143">&nbsp;</span><span><br></span>
		</div> -->
		<div class="sentence-append-point text-on" id="appendPoint" contentEditable="true" style="display: none;">
				<!-- [Editorial] <br>Negative reversal By Korea Herald Korea set to record first monthly current account deficit in 7 years Published : Jun 3, 2019 - 17:03 Updated : Jun 3, 2019 -17:03 A Afy South Korea seems set to record a current account deficit in April for the first time since May 2012 in yet another warning sign about the sluggish performance of Asia's fourth- largest economy. With the Bank of Korea scheduled to announce official data this week, government officials have indicated that the country's current account balance will tip into negative territory after having been in the black for 83 straight months through March. A statement released Friday by the Ministry of Economy and Finance said there was a possibility that the country would suffer a "slight current account deficit temporarily" in April due to the payment of dividends to offshore investors. -->
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
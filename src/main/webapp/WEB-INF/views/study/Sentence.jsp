<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	
	
	//뒤로가기
	$("#btnBack").on("click",function(){
		history.back();
	});
	
	//todo: 웹버전일 때 버튼 지우기
	if(false){
		$("#btnCameraToText").hide();	
	}
	
	$("#btnFileToText").on("click",function(){
		$("#file").click();
	});
	
	$("#btnCameraToText").on("click",function(){
		$("#file").attr("capture","camera");
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
		            	$("#btnFixText").show();
		            	$("#btnFileToText").hide();
		            	$("#appendPoint").append(data.result);
						
		            	$("#appendPoint").fadeIn();
		            	
		            },
		            error: function (e) {
		            	common.loding(false);
		            }
		        }); 
		        
				//--------------------------------------//ajax------------------------------//
				
		    }//이미지로드 end
		    
		    
		}//파일 로드 end
	
	});
	
	
	//등록 수정 분기
	var editMode = true; 
	var sentenceNo = '${sentenceNo}';
	var sentence = $("#hdnSentence").val();
	var menuNo = "${menuNo}";
	var type = "${type}";
	
	console.log("sentenceNo::"+sentenceNo);
	
	if(sentenceNo != "0"){
		$("#appendPoint").show();
		$("#appendPoint").removeAttr("contentEditable");
		$("#appendPoint").removeClass("text-on");
		$("#appendPoint").html(sentence);
		$("#btnFixText").remove();
		$("#btnSaveSentence").show();
		editMode = false;
		
		//불러온 문서 이벤트 바인딩
		
		var wordHighlight = $(".word-box-on");
		var tags = $(".glyphicon-tag");
		tags.each(function(index, item){
			$(item).prev().on("click",function(){
				var word = $("#word"+$(this).attr("id")).find(".hidden").text();
				common.loding(true);
				$("#viewWord").show();
				$("#orgWord").text($(this).text());
				$("#meanWord").val(word);
			});
		});
	}
	
	

	var wordBoxOn = $(".word-box-on");
	var wordIdxArr = new Array();
	wordBoxOn.each(function(index, item){
		 wordIdxArr.push($(item).attr("id"));
	}); 
	wordIdxArr.sort((curr,next) => curr-next);
	
	
	var highlightIdx = 0;
	var lastHighlightIdx = -1;
	try{
		lastHighlightIdx = wordIdxArr[wordIdxArr.length-1];
	}catch(err){
		lastHighlightIdx = -1;
	}
	if(lastHighlightIdx >-1){
		highlightIdx = parseInt(lastHighlightIdx)+1;
	}
	
	
	//var words = new Object(); 
	
	
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
				var id  = $selectedNode.attr("id");
				
				//delete words[id];
				
				//console.log(words);
				
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
			$("#targetWord").text($selectedNode.text());
			$("#contextMenu").hide();
		});
		
		$("#btnWordOk").off().click(function(){
			var wordVal = $("#word").val();
			if(wordVal.trim()==""){
				common.toast("단어를 입력해주세요.");
				return;
			}
			
			var top = $selectedNode.offset().top;
			var left = $selectedNode.offset().left;
			
			var wordNode = document.createElement('span');
			var id  = $selectedNode.attr("id");
			//wordNode.innerHTML = wordVal;
			//wordNode.innerHTML = "&nbsp;";
			//wordNode.style.position = 'absolute';
			//wordNode.style.fontSize = '10px';
			wordNode.style.fontSize = '0.5em';
			//wordNode.style.width = "100px";
			wordNode.className = 'glyphicon glyphicon-tag';
			wordNode.id = "word"+id;

			console.log(range);
			
			//range.setStart(selectedNode,1);
			//range.insertNode(wordNode);
			
			
			$("#"+id).after(wordNode);
			
			var hiddenWord = document.createElement('span');
			hiddenWord.className = 'hidden';
			hiddenWord.innerHTML =  wordVal;
			$("#word"+id).append(hiddenWord);
			
			//header.append(wordNode);
			common.loding(false);
			
			$("#inputWord").hide();
			
			$("#word").val("");
			
			
			/* 	
			var wordObj = new Object();
			wordObj.wordOrg = $selectedNode.text();
			wordObj.wordMean = wordVal;
			console.log(wordObj);
			
			words[id] = wordObj;
			console.log(words); 
			*/
			
			
			$("#"+id).on("click",function(){
				common.loding(true);
				$("#viewWord").show();
				$("#orgWord").text($selectedNode.text());
				$("#meanWord").val(wordVal);
			});
		});
		
		
		$("#menu3").off().click(function(){
			//todo
			//단어장에 저장
		});
		
		return false;
	});
	
 	$("#btnWordCancel").off().click(function(){
		common.loding(false);
		$("#inputWord").hide();
	});
	
	$("#btnViewWordOk").on("click",function(){
		common.loding(false);
		$("#viewWord").hide();
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
		
	
		var appendPoint = $("#appendPoint");
		if(appendPoint.text().trim() == ""){
			common.toast("저장할 내용을 입력해주세요.");
			appendPoint.focus();
			return;
		}
		
		$("#contextMenu").hide();
		$(this).remove();
		$("#btnSaveSentence").show();
		appendPoint.removeAttr("contentEditable");
		appendPoint.removeClass("text-on");
		editMode = false;
	});
	 
	var scroll_x = 0;
	var appendPoint = $("#appendPoint");
	
	$("#appendPoint").on('mousewheel', function(e){
		if(!editMode){
			toggleHaderAndBotNav(e.originalEvent.wheelDelta, 0);
		}
		
    });
	
	
	$("#appendPoint").on("touchstart",function(e){
		scroll_x= appendPoint.scrollTop();
	});
	
	$("#appendPoint").on("touchend",function(e){
		var crrent_x =appendPoint.scrollTop();
		if(!editMode){
			toggleHaderAndBotNav(scroll_x, crrent_x);
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
	
	
	

	
	$("#btnTitleOk").on("click",function(){
		console.log("저장될 폴더번호::",menuNo);
		
		var title = $("#title");
		
		var descript = $("#descript");
		
		if(title.val().trim() == ""){
			common.toast("제목을 입력해주세요.");
			title.focus();
			return;
		}
		
		if(descript.val().trim() == ""){
			common.toast("설명을 입력해주세요.");
			descript.focus();
			return;
		}
		
		
		if(!confirm("작업내용을 저장하시겠습니까?")){
			return;
		}
		
		var appendPoint = $("#appendPoint");
		
		var sentence = appendPoint.html();
	
	
		$.ajax({
			url : "/study/sentence/save",     
			data : {
					"sentence": sentence
					, "menuNo" : menuNo
					, "title" : title.val()
					, "descript" : descript.val()
					, "sentenceNo" : sentenceNo
					},    
			method : "POST",        
			dataType : "json",
			beforeSend : function() {
				common.loding(true);
		    },
			success : function(data){
				common.loding(false);
				
				if(data != null && data.result == "00"){
					common.toast('문장을 저장했어요!');
					$("#inputTitle").hide();
					$("#selectPositionPop").hide();
					
				}else{
					common.toast('저장에 실패했어요...');
				}
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.toast('저장에 실패했어요...'+error);
			}
		});
	});
	
	$("#btnSelf").on("click",function(){
		$("#btnFileToText, #btnCameraToText, #btnSelf" ).hide();
    	$("#appendPoint").fadeIn();
    	$("#btnFixText").fadeIn();
    	$("#appendPoint").focus();
	});
	
	
	
	function toggleHaderAndBotNav(oldScroll, crrentScroll){
		if(!common.hasScrollBar($("#appendPoint"))){
			return ;
		}
		var header = $("#header");
		var botNav = $("#botNav");
		var btnFixText = $("#btnFixText");
		var btnSaveSentence = $("#btnSaveSentence")
		var toolBox = $("#toolBox")
		
		if(oldScroll < crrentScroll){
			header.fadeOut();
			botNav.fadeOut();
			btnFixText.fadeOut();
			if(!btnFixText.length){
				btnSaveSentence.fadeOut();	
			}
			
			toolBox.fadeIn();
		}else if(oldScroll > crrentScroll){
			header.fadeIn();
			botNav.fadeIn();
			btnFixText.fadeIn();
			if(!btnFixText.length){
				btnSaveSentence.fadeIn();
			}
			
			toolBox.fadeOut();
		}else{
			header.fadeOut();
			botNav.fadeOut();
			btnFixText.fadeOut();
			if(!btnFixText.length){
				btnSaveSentence.fadeOut();	
			}
		}
	}
	
	$("#textSizeUp").on("click",function(){
		$("#appendPoint").css("fontSize","+=5");
	});
	
	$("#textSizeDonw").on("click",function(){
		$("#appendPoint").css("fontSize","-=5");
	});
	
	
	
	
	function explorerFolder(tabType, f_menuNo){
		$.ajax({
			url : "/study/folder/selectPosition",     
			data : {"tabType" : tabType, "menuNo" : f_menuNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				
				menuNo = f_menuNo;
				
				getMenuPath(tabType, f_menuNo);
				
				$("[name='divAppendPointForFolder']").html("");
				if(data.result=="00"){
					var list = data.list;
					
					if(list.length == 0){
						emptyFolder = true;
					}else{
						emptyFolder = false;
					}
					
					$(list).each(function(index, item){
						var html = "";
						html	+= '<div class="move-cate-Row">'
								+  '	<span class="glyphicon glyphicon-folder-open move-cate-icon"></span>'
								+  ' 	<div  class="move-cate-tit"  id="'+item.MENU_NO+'" name="forder" data-children="'+item.CHILDREN+'">'
								+ 			item.TITLE
								+  '		<div class="move-cate-desc">'
								+  				item.DESCRIPT
								+  '		</div>'
								+  '    </div>'
								
								+  '</div>';
							

						$("[name='divAppendPointForFolder']").append(html);
						
						
						$("#"+item.MENU_NO).off().on("click",function(){
							
							var folderId = $(this).attr("id");
							
							var pathId = "path"+item.MENU_NO;
							
							var pathCount = $("[name='divPath'] span").length;
							
							$("[name='divPath'] span").on("click",function(){
								var pathMenuNo= $(this).data("no");
								
								var pathIndex = $(this).data("count");
								
								var pathArr = $("[name='divPath'] span");
								
								if(pathArr.length > pathIndex+1){
									$(pathArr[pathIndex+1]).remove();	
								}
								//폴더 출력 및 클릭이벤트 바인딩 재귀
								explorerFolder(tabType, pathMenuNo);
								
							});
						 	//폴더 출력 및 클릭이벤트 바인딩 재귀
							explorerFolder(tabType, folderId);
							
							
						});//클릭
					
						
						
					});//each
					
					//파일도 얻어오기
					searchSentence(tabType, f_menuNo);
					
					
					
					
				}else{
					common.loding(false);
					common.toast('요청에 실패하였습니다.');
				}
				
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.toast('요청에 실패하였습니다.'+error);
			}
		});	
		
	}
	
	
	function getMenuPath(tabType, f_menuNo){
		$.ajax({
			url : "/study/folder/getMenuPath",     
			data : {"tabType" : tabType, "menuNo" : f_menuNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				$("[name='divPath']").html('<span class="move-cate-path" id="path0" data-no="0">스냅노트</span>');
				
				$("#path0").on("click",function(){
					explorerFolder("Sentence", "0");
				});
				
				if(data.result=="00"){
					var menuPath = data.path.MENU_PATH;
					
					var path = data.path.PATH;
					
					var arrMenuPath = menuPath.split(">");
					var arrPath = path.split(">");
					$(arrMenuPath).each(function(index, item){
						var addPath ='<div class="path-split"><span class="glyphicon glyphicon-chevron-right"></span></div><span class="move-cate-path" id="path'+arrPath[index]+'" data-no="'+arrPath[index]+'" >'+item+'</span>';
						
						$("[name='divPath']").append(addPath);
						
						$("#path"+arrPath[index]).on("click",function(){
							explorerFolder("Sentence", arrPath[index]);
						});
					});
				}
			}
		});
	}
	
	function searchSentence(tabType, f_menuNo){
		console.log("tabType:::"+tabType);
		console.log("menuNo:::"+f_menuNo);
		
		$.ajax({
			url : "/study/sentence/searchSentence",     
			data : {"tabType" : tabType, "menuNo" : f_menuNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				$("[name='divAppendPointForSentence']").html("");
				$("#hdnMenuNo").val(f_menuNo);
				console.log("hdn menuNO::"+$("#hdnMenuNo").val())
				if(data.result=="00"){
					var list = data.list;
					
					if(list.length == 0){
						emptyFile = true;
					}else{
						emptyFile = false;
					}
					
					
					$(list).each(function(index, item){
						var html = "";
						html	+= '<div class="move-cate-Row">'
								+  '	<span class="glyphicon glyphicon-file move-cate-icon"></span>'
								+  ' 	<div  class="move-cate-tit"  id="sentence'+item.SENTENCE_NO+'" name="sentence">'
								+ 			item.TITLE
								+  '		<div class="move-cate-desc">'
								+  				item.DESCRIPT
								+  '		</div>'
								+  '    </div>'
								+  '</div>';
							

						$("[name='divAppendPointForSentence']").append(html);
						/* 
						$("#sentence"+item.SENTENCE_NO).off().on("click",function(){
							location.href="/study/sentence/"+item.MENU_NO+"?sentenceNo="+item.SENTENCE_NO;
						});//클릭
						 */
					});//each
					
					console.log("emptyFile::"+emptyFile);
					console.log("emptyFolder::"+emptyFolder);
					
					if(emptyFile && emptyFolder){
						$("[name='divAppendPointForSentence']").append('<div class="empty-folder">비어 있음</div>');
					}
					
				}else{
					common.loding(false);
					common.toast('요청에 실패하였습니다.');
				}
				
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.toast('요청에 실패하였습니다.'+error);
			}
		});
	}
	
	$("#btnSaveSentence").on("click", function(){
		if(type == 'bot'){
			explorerFolder("Sentence", "0");
			$("#selectPositionPop").fadeIn();
		}else{
			common.loding(true);
			$("#inputTitle").show();
		}
	});
	
	
	$("#btnTitleCancel").on("click", function(){
		common.loding(false);
		$("#inputTitle").hide();
	});
	
	

	$("#btnSelectPositionPopClose").on("click", function(){
		common.loding(false);
		$("#selectPositionPop").hide();
	});
	
	

	$("#btnPositionSelect").on("click", function(){
		common.loding(true);
		$("#inputTitle").show();
		
	});
	
	$("#appendPoint").bind('paste',function(e){
		var pastedData = e.originalEvent.clipboardData.getData('text');
		$("#appendPoint").text($("#appendPoint").text()+pastedData);
		return false;
	});
	
});
</script>

<div  class="move-cate-for-create" id="selectPositionPop" style="display: none;" >
	<input type="hidden" id="hdnMenuNo"  name ="menuNo"  style="display: none;" />
	<div id="btnPositionSelect" class="sentence-btn-full">현재폴더에 문서생성</div>
	<div>
		<div class="move-cate-head-wrap">
			<div class="back-head modify-pop-tit-txt">
				<span onclick="$('#selectPositionPop').hide();" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
			</div>
			<span class="top-back-txt modify-pop-tit-txt">폴더 및 파일 선택</span>
		</div>
		<!-- 선택한 폴더 타이틀로 보여주기  -->
		<div class="move-cate-body">
			<!-- 폴더  -->
			<div class="pop-folder-area">
				<div class="pop-folder">
					<div class="path-explorer" name="divPath">
						
					</div>
					<div class="container-fluid" name="divAppendPointForFolder">
						<!-- append list-->
						
						<!-- append list -->
					</div>
					
					<div class="container-fluid" name="divAppendPointForSentence">
						<!-- append list-->
						
						<!-- append list -->
					</div>
				</div>		
			</div>
			<!-- 폴더  -->
			
		</div>
	</div>
</div>






<input id="hdnSentence" value="${sentence}" style="display: none;">

<div id="contextMenu" class="context-menu-wrap">
	<span id="menu1" class="context-menu">현광펜</span> 
	<span id="menu2"  class="context-menu">뜻 달기</span>
	<span id="menu3" class="context-menu">단어저장</span> 
</div>

<div id="toolBox" class="tool-box-wrap">
	<span id="moveToTop"class="glyphicon glyphicon-chevron-up tool-box-item"></span>
	<br>
	<span id="textSizeUp" class="glyphicon glyphicon-plus"></span>
	<br>
	<span id="textSizeDonw" class="glyphicon glyphicon-minus"></span>
	<br>
	<span id="moveToDown" class="glyphicon glyphicon-chevron-down tool-box-item"></span>
</div>

<div id="inputWord" class="input-word" >
	<div id="targetWord" class="target-word"></div>
	<textarea id="word" class="wordArea"  placeholder="단어의 뜻을 입력하세요." ></textarea>
	<div id="btnWordOk" class = "pop-btn-save">확인</div>
	<div id="btnWordCancel" class="pop-btn-save">최소</div>
</div>

<div id="inputTitle" class="input-title" >
	<div class="form-group">
		<label for="title">제목</label> 
		<input id="title"   class="form-control" placeholder="제목을 입력하세요." value="${title}">
		<br>
		<label for="descript">설명</label> 
		<input id="descript"   class="form-control" placeholder="설명을 입력하세요." value="${descript}">
	</div>
	<div id="btnTitleOk" class = "pop-btn-save">확인</div>
	<div id="btnTitleCancel" class="pop-btn-save">최소</div>
</div>

<div id="viewWord" class="input-word" >
	<div id="orgWord" class="target-word"></div>
	<textarea id="meanWord" class="wordArea"  readonly="readonly"></textarea>
	<div id="btnViewWordOk" class = "pop-btn-full">확인</div>
</div>

<div id="btnFixText" class="sentence-btn-full" style="display: none;">문장 고정</div>
<div id="btnSaveSentence" class="sentence-btn-full" style="display: none;">저장</div>

<input type="file" id="file" name="file" style="display: none;"  accept="image/*">


<div name="sentence" id="sentenceList" class="sentenceList">
	<div id="header" class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">문장 등록</span>
		</div>
	</div>
	<div class="sentence-wrap">
		<div class="sentence-append-point text-on" id="appendPoint"  contentEditable="true"  style="display: none;">
		<%-- appendPoint--%>
		</div>
		<div class="sentence-btn-wrap">
			<div id="btnFileToText" class="sentence-btn-float">사진으로</div>
			<div id="btnSelf"  class="sentence-btn-float">직접 입력</div>
		</div>
	</div>
</div>


<%--주요 문제점	
	폴더 수정과 폴더 탐색 을 합칠 수 있을까?
	-> 탐색도 하면서 문서도 생성하면서 폴더도 수정삭제 할 수 있게
	-> 일이 커짐 컨텍스트메뉴로 이동 수정 제어하려면 폴더 / 파일 구분하면서 이동규칙도 맞춰줘야함
	
	임시저장기능

	폴더 슬라이더에서 해당 폴더에 문장 들어있을 경우 갯수 뱃지 달아주기

	
--%>
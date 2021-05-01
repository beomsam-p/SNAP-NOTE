<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	$(document).on("contextmenu",function(e){
        return false;
    });
	
	var chkInclude = false;
	
	var menuInfo = new Object();
	
	var moveToThisFolder = '';
	
	var addToThisFolder = '';
	
	var crrentDepth = '';
	
	var venReq = false;
	
	//메뉴닫기
	$("#btnBack").on("click",function(){
		location.href = "/study/category?tabType=Sentence";
	});
	
	$("[name='tabMenu']").on("click",function(){
		location.href="/study/categoryModify?tabType="+$(this).text();
	});
	
	$("[name='chkMenu']").on("change",function(e){
		$("#divBotBtnWrap").show();
		menuInfo.no = $(this).parent().parent().attr("id");
		menuInfo.parent = $(this).parent().parent().data("parent");
		menuInfo.title = $(this).parent().parent().data("title");
		menuInfo.descript = $(this).parent().parent().data("desc");
		menuInfo.depth = $(this).parent().parent().data("depth");
		menuInfo.lvl = $(this).parent().parent().data("lvl");
		menuInfo.path = $(this).parent().parent().data("path");
		moveToThisFolder = menuInfo.parent;
		crrentDepth = menuInfo.lvl;
		addToThisFolder = $(this).val();
	});
	
	$("#btnModify").on("click",function(){
		if(menuInfo.no == 0){
			common.showModal('SNAP NOTE',"ROOT 폴더는 수정할 수 없습니다.");	
			return
		}
		$("#modifyPath").html("");
		common.loding(true);
		$("#modifyPop").fadeIn();
		$("#modifyTitle").val(menuInfo.title);
		$("#modifyDescript").val(menuInfo.descript);
		
		var arrPath = menuInfo.path.split(">");
		
		$(arrPath).each(function(index, item){
			
			var addPath = '<span class="pop-path">'+item+'</span>';
			
			if(arrPath.length-1 != index){
				addPath += '<div class="path-split"><span class="glyphicon glyphicon-chevron-right top-minus"></span></div>';
			}
			
			$("#modifyPath").append(addPath);
			
		});
		
		
	});
	
	$("#btnModifyPopClose, #btnAddFolderPopClose").on("click",function(){
		common.loding(false);
		$(".modify-pop").hide();
	});
	
	$("#btnSelectPositionPopClose").on("click",function(){
		$("#selectPositionPop").hide();
	});
	
	$("#btnAddFolder").on("click",function(){
		console.log(crrentDepth);
		if(crrentDepth>4){
			common.showModal('SNAP NOTE',"더 이상 깊게 폴더를 만들 수 없습니다. <br> 너무 깊어요...!");
			return;
		}
		
		common.loding(true);
		$("#addfolderPop").fadeIn();
		
		if(menuInfo.no == 0){
			
			console.log(menuInfo.no)
			
			$("[name='selectedTit']").text('스냅노트');
			var addPath = '<span class="pop-path" id="path0" data-no="0">스냅노트</span>';
			$("[name='divPath']").html(addPath);
			
		}else{
			getMenuPath("Sentence", addToThisFolder);
			var selectedTit = menuInfo.title;
			$("[name='selectedTit']").text(selectedTit);
		}
		
	});
	
	
	
	
	
	function explorerFolder(tabType, menuNo){
		$.ajax({
			url : "/study/selectPosition",     
			data : {"tabType" : tabType, "menuNo" : menuNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				
				getMenuPath(tabType, menuNo);
				
				$("[name='divAppendPoint']").html("");
				if(data.result=="00"){
					var list = data.list;
					
					if(data.list.length==0){
						$("[name='divAppendPoint']").append("<div class='empty-folder'>폴더없음</div>");
						return;
					}
					
					
					$(list).each(function(index, item){
						var html = "";
						html	+= '<div class="row folderRow">'
								+  '  	<div class="pop-folder-tit" id="'+item.MENU_NO+'" name="forder" data-children="'+item.CHILDREN+'">'
								+  '		<input style="position: relative; top:10px;" type="radio" id="chkMenu'+item.MENU_NO+'" name="chkMenu" value="'+item.MENU_NO+'" data-folderNm="'+item.TITLE+'" data-no="'+item.MENU_NO+'"  data-parent="'+item.PARENT_NO+'"/>'
								+  '		<span style="margin-left:5px;">'+item.TITLE+'</span>'
								+  '		<div class="pop-folder-desc">'
								+  				item.DESCRIPT
								+  '		</div>'								
								+  '	</div>'
								+  '</div>';
								
						$("[name='divAppendPoint']").append(html);
						
						
						if(menuInfo.no == item.MENU_NO){
							$("#chkMenu"+item.MENU_NO).attr("disabled","disabled");
							$("#"+item.MENU_NO).off().on("click",function(){
								common.showModal('SNAP NOTE',"원본폴더 보다 하위폴더로 이동할 수 없습니다.");	
							});
							return;
						}else{
							$("#"+item.MENU_NO).off().on("click",function(){
								console.log(menuInfo.no);
								console.log(item.MENU_NO);
								
								var folderId = $(this).attr("id");
								
								var pathId = "path"+item.MENU_NO;
								
								var pathCount = $("[name='divPath'] span").length;
								
								$("[name='divPath'] span").on("click",function(){
									var pathMenuNo= $(this).data("no");
									
									var pathIndex = $(this).data("count");
									
									var pathArr = $("[name='divPath'] span");
									
									if(pathArr.length > pathIndex+1){
										console.log(pathArr[pathIndex+1]);
										$(pathArr[pathIndex+1]).remove();	
									}
									//폴더 출력 및 클릭이벤트 바인딩 재귀
									explorerFolder(tabType, pathMenuNo);
									
								});
							 	//폴더 출력 및 클릭이벤트 바인딩 재귀
								explorerFolder(tabType, folderId);
								
								
							});//클릭
						}
						
						
						
					});//each
					
				}else{
					common.loding(false);
					common.showModal('SNAP NOTE','요청에 실패하였습니다.');
				}
				
			},
			error : function(jqXHR,status,error){
				common.loding(false);
				common.showModal('SNAP NOTE 로그인','에러발생 :<br>'+error);
			}
		});	
		
	}
	
	
	function getMenuPath(tabType, menuNo){
		
		$.ajax({
			url : "/study/getMenuPath",     
			data : {"tabType" : tabType, "menuNo" : menuNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				$("[name='divPath']").html('<span class="pop-path" id="path0" data-no="0">스냅노트</span>');
				$("#path0").on("click",function(){
					explorerFolder("Sentence", "0");
				});
				
				if(data.result=="00"){
					if(data.path==null){
						return;
					}
					var menuPath = data.path.MENU_PATH;
					var path = data.path.PATH;
					
					var arrMenuPath = menuPath.split(">");
					var arrPath = path.split(">");
					
					$(arrMenuPath).each(function(index, item){
						var addPath ='<div class="path-split"><span class="glyphicon glyphicon-chevron-right"></span></div><span class="pop-path" id="path'+arrPath[index]+'" data-no="'+arrPath[index]+'" >'+item+'</span>';
						
						$("[name='divPath']").append(addPath);
						
						$("#path"+arrPath[index]).on("click",function(){
							explorerFolder("Sentence", arrPath[index]);
						});
					});
					
					
					
				}
			}
		});
	}
	
	
	$("#modifyPopPositionMove").on("click",function(){
		
		var no = menuInfo.parent;
		
		var tabType = "Sentence";
	
		var selectedTit = menuInfo.title;
		explorerFolder(tabType, no);
		$("#selectPositionPop").fadeIn();
		$("[name='selectedTit']").text(selectedTit);
		
	});
	
	$("#btnPositionSelect").on("click",function(){
		var radioArr = $("[name='divAppendPoint']").find("input");
		
		var radioChk = false;
		
		var origin
		
		var selectFolderName = '';
		
		$(radioArr).each(function(index, item){
			if($(item).is(':checked')){
				radioChk = true;
				selectFolderName = $(item).data("foldernm"); 
				moveToThisFolder = $(item).data("no");
				return;
			}
		});
		
		if(!radioChk){
			common.showModal('SNAP NOTE',"폴더를 선택하세요.");
			return;
		}
		
		
		$("#selectPositionPop").hide();
		var addPathDiv = $("[name='divPath']").html();
		var creentPathDiv = '<span class="glyphicon glyphicon-chevron-right"></span><span class="pop-path">'+selectFolderName +'</span>';
		$("#modifyPath").html($("[name='divPath']").html());
		$("#modifyPath").append(creentPathDiv);
		
	});
	
	
	$("#modifyPopSaveFolder").on("click",function(){
		var title = $("#modifyTitle").val();
		var descript = $("#modifyDescript").val();
		var crrentNo = menuInfo.no ;
		var moveNo = moveToThisFolder;
		
		if(title == ''){
			common.showModal('SNAP NOTE',"폴더명을 입력하세요.");
			return;
		}
		
		if(descript == ''){
			common.showModal('SNAP NOTE',"설명을 입력하세요.");
			return;
		}
		
		console.log("=====saveFolderInfo====");
		console.log("title:::"+title);
		console.log("descript:::"+descript);
		console.log("crrentNo:::"+crrentNo);
		console.log("moveNo:::"+moveNo);
		console.log("=======================");
		
		if(!venReq){
			venReq=true;
			$.ajax({
				url : "/study/saveModify",     
				data : {
							"tabType" : "Sentence"
							, "title" : title
							, "descript": descript
							, "crrentNo": crrentNo
							, "moveNo" : moveNo
						},    
				method : "POST",        
				dataType : "json",
				success : function(data){
					venReq = false;
					if(data.result == '1'){
						alert('성공적으로 저장 되었습니다.');
					}
					else{
						alert('폴더 저장에 실패하였습니다. 관리자에게 문의 부탁드립니다.');
					}
					location.reload();
				},
				error : function(jqXHR,status,error){
					alert('에러발생');
					location.reload();
				}
				
			});
		}else{
			common.showModal('SNAP NOTE',"처리 중 입니다.");
		}
	});
	
	
	
	$("#btnSaveFolder").on("click",function(){
		common.loding(true);
		var title = $("#addTitle").val().trim();
		var descript = $("#addDescript").val().trim();
		
		if(title == ''){
			common.showModal('SNAP NOTE',"폴더명을 입력하세요.");
			return;
		}
		
		if(descript == ''){
			common.showModal('SNAP NOTE',"설명을 입력하세요.");
			return;
		}
		
		if(!venReq){
			venReq=true;
			$.ajax({
				url : "/study/addFolder",     
				data : {
							"tabType" : "Sentence"
							, "parentNo" : menuInfo.no
							, "title": title
							, "descript" : descript
						},    
				method : "POST",        
				dataType : "json",
				success : function(data){
					console.log(data);
					venReq = false;
					if(data.result == '1'){
						alert('폴더가 성공적으로 생성되었습니다.');
					}
					else{
						alert('폴더생성에 실패하였습니다. 관리자에게 문의 부탁드립니다.');
					}
					location.reload();
				},
				error : function(jqXHR,status,error){
					alert('에러발생');
					location.reload();
				}
				
			});
		}else{
			common.showModal('SNAP NOTE',"처리 중 입니다.");
		}
	});
	
	$("#modifyPopDeleteFolder").on("click",function(){
		if(!confirm("정말 삭제하시겠습니까?")){
			return;
		}
		
		if(!venReq){
			venReq=true;
			$.ajax({
				url : "/study/removeFolder",     
				data : {
							"tabType" : "Sentence"
							, "menuNo" : menuInfo.no
						},    
				method : "POST",        
				dataType : "json",
				success : function(data){
					console.log(data);
					venReq = false;
					if(data.result == '1'){
						alert('폴더를 삭제하였습니다.');
					}
					else{
						alert('폴더삭제에 실패하였습니다. 관리자에게 문의 부탁드립니다.');
					}
					location.reload();
				},
				error : function(jqXHR,status,error){
					alert('에러발생');
					location.reload();
				}
				
			});
		}
	});
});

</script>
<div id="divBotBtnWrap" class="insert-head-wrap">
	<div id="btnModify"  class="pop-btn-float">선택 폴더 수정</div>
	<div id="btnAddFolder"  class="pop-btn-float">선택 지점에 폴더 추가</div>
</div>
<div class="select-position-pop" id="selectPositionPop" >
	<div class="pop-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnSelectPositionPopClose" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
		</div>
		<span class="top-back-txt modify-pop-tit-txt">폴더 이동 위치 선택</span>
	</div>
	<!-- 선택한 폴더 타이틀로 보여주기  -->
	<div class="pop-folder-selected-tit" name="selectedTit"></div>
	<div class="modify-pop-body">
	
		<!-- 폴더  -->
		<div class="pop-folder-area">
			<div class="pop-folder">
				<div class="path-explorer" name="divPath">
					
				</div>
				<div class="container-fluid" name="divAppendPoint">
					<!-- append list-->
					
					<!-- append list -->
				</div>
			</div>		
		</div>
		<!-- 폴더  -->
		<div class="form-group">
			<div id="btnPositionSelect" class="pop-btn-full">선택</div>
		</div>
	</div>
</div>



<div class="modify-pop" id="addfolderPop">
	<div class="pop-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnAddFolderPopClose" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
		</div>
		<span class="top-back-txt modify-pop-tit-txt">폴더 추가</span>
	</div>
	<!-- 선택한 폴더 타이틀로 보여주기  -->
	<div class="pop-folder-selected-tit" name="selectedTit"></div>
	<div class="modify-pop-body">
	
		<div class="form-group">
			<label for="title">폴더명</label>
			<input type="text" class="form-control" id="addTitle" name="title" placeholder="폴더명을 입력하세요." maxlength="10">
		</div>
		<div class="form-group">
			<label for="descript">설명</label>
			<input type="text" class="form-control" id="addDescript" name="descript" placeholder="설명을 입력하세요." maxlength="20">
		</div>
		<div class="form-group">
			<label for="descript">위치</label>
				<!-- 폴더  -->
				<div class="pop-folder-area">
					<div class="pop-folder">
						<div class="path-explorer" name="divPath">
							
						</div>
						<!-- <div class="container-fluid" name="divAppendPoint">
							append list
							
							append list
						</div> -->
					</div>		
				</div>
				<!-- 폴더  -->
			<div id="btnSaveFolder"  class="pop-btn-full">저장</div>
		</div>
	</div>
</div>


<div class="modify-pop" id="modifyPop">
	<div class="pop-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnModifyPopClose" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
		</div>
		<span class="top-back-txt modify-pop-tit-txt">폴더 수정</span>
	</div>
	<div class="modify-pop-body">
	
		<div class="form-group">
			<label for="title">폴더명</label>
			<input type="text" class="form-control" id="modifyTitle" name="title" placeholder="폴더명을 입력하세요." maxlength="10">
		</div>
		<div class="form-group">
			<label for="descript">설명</label>
			<input type="text" class="form-control" id="modifyDescript" name="descript" placeholder="설명을 입력하세요." maxlength="20">
		</div>
		<div class="form-group">
			<label for="descript">위치</label>
			<div> 
				<span class="pop-path" id="path0" data-no="0">스냅노트</span>
				<div class="path-split">
					<span class="glyphicon glyphicon-chevron-right top-minus"></span>
				</div>
				<span id="modifyPath" class="pup-path"><!-- 토익단어 > 챕터1 단어 > 챕터 1-1 단어 --></span>
			</div>
			<div id="modifyPopPositionMove" class=pop-btn-full>위치번경</div>
			<div id="modifyPopSaveFolder" class="pop-btn-save">저장</div>
			<div id="modifyPopDeleteFolder"class="pop-btn-delete">폴더 삭제</div>
		</div>
	</div>
</div>







<div id="menuList" class="menuList-modify">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
		</div>
		<span class="top-back-txt">카테고리 수정</span>
	</div>
	<div class="menu-box">
		<%-- <div class="profile-box">
			<div class="profile-img">
			</div>
		</div>
		<div class="nick-box">
			<div class="nick-txt">${nick}</div>
		</div> --%>
		
		
		
		<ul class="nav nav-tabs  cate-tab">
			<li name="tabMenu" role="presentation" <c:if test="${tabType eq 'Sentence'}">class="active"</c:if>><a href="javascript:void(0);">Sentence</a></li>
			<li name="tabMenu" role="presentation" <c:if test="${tabType eq 'Word'}">class="active"</c:if>><a href="javascript:void(0);">Word</a></li>
		</ul>
		
		
		<div id="divCateBox" class="cate-box" >
			<!-- 루트  -->
			<div class=cate-menu-root
				data-forder="Y"
				data-parent=""
				data-path="ROOT > "
				data-lvl=""
				data-depth="0"
				name="menu"
				id="0"
				data-title="ROOT"
				data-desc="ROOT">
				<div class="cate-tit">
					<input type="radio" id="chkMenu0" name="chkMenu" value="0"/> 
					<label for="chkMenu0"><span></span></label>
					스냅노트
				</div>
						
				<div class="cate-desc">ROOT</div>
			</div>
			<!-- //루트 -->
		
			<c:forEach items="${list}" var="menu" varStatus="status">
				<c:if test="${tabType eq 'Sentence'}">
					<c:set var="id" value="${menu.MENU_NO }"/>
				</c:if>
				<c:if test="${tabType eq 'Word'}">
					<c:set var="id" value="${menu.WORD_NO }"/>
				</c:if>
				<div class="cate-menu <c:if test="${menu.LVL ne 0}"> cate-lvl0 </c:if>"
					
					style="	margin-left: ${2*menu.LVL+15}px;"
					
					data-forder="${menu.FORDER_YN}"
					data-parent="${menu.PARENT_NO}"
					data-path="${menu.MENU_PATH}"
					data-lvl="${menu.LVL}"
					data-depth="${menu.DEPTH}"
					name="menu"
					id="${id}"
					data-title="${menu.TITLE}"
					data-desc="${menu.DESCRIPT}"
				 >
				 
					<div class="cate-tit">
						<input type="radio" id="`" name="chkMenu" value="${id}" data-lvl="${menu.LVL}"/> 
						<label for="chkMenu${id}"><span></span></label>
						${menu.TITLE} 
					</div>
					
					<div class="cate-desc">${menu.DESCRIPT}</div>
					
					<div  id="innerCateBox<c:if test="${tabType eq 'Sentence'}">${menu.MENU_NO }</c:if><c:if test="${tabType eq 'Word'}">${menu.WORD_NO }</c:if>">
					
					<c:if test="${list[status.index+1].LVL > menu.LVL}">
					
					</c:if>
					
					<c:if test="${list[status.index+1].LVL == menu.LVL}">
							</div>
						</div>
					</c:if>
				
					<c:if test="${list[status.index+1].LVL < menu.LVL}"	>
						<c:forEach begin="0" end="${menu.LVL - list[status.index+1].LVL}" step="1">
								</div>
							</div>
						</c:forEach>
					</c:if>
					
			</c:forEach>
		</div>
		
	</div>
</div>


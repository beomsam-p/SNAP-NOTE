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
		menuInfo.path ="ROOT > " +$(this).parent().parent().data("path");
	});
	
	$("#btnModify").on("click",function(){
		$("#modifyPath").html("");
		/* var checkRadio = false;
		$("[name='chkMenu']").each(function(index, item){
			if($(item).is(":checked")){
				checkRadio=true;
				return false //break;
			}
		});
		
		if(!checkRadio){
			alert("폴더를 선택해 주세요")
			return false; //return
		} */
		
		common.loding(true);
		$("#modifyPop").fadeIn();
		$("#modifyTitle").val(menuInfo.title);
		$("#modifyDescript").val(menuInfo.descript);
		
		var arrPath = menuInfo.path.split(">");
		
		$(arrPath).each(function(index, item){
			
			var addPath = '<span class="pop-path">'+item+'</span>';
			
			if(arrPath.length-1 != index){
				addPath += '<div class="path-split"><span class="glyphicon glyphicon-chevron-right"></span></div>';
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
		common.loding(true);
		$("#addfolderPop").fadeIn();
	});
	
	
	
	
	
	function explorerFolder(tabType, menuNo){
		$.ajax({
			url : "/study/selectPosition",     
			data : {"tabType" : tabType, "menuNo" : menuNo},    
			method : "POST",        
			dataType : "json",
			success : function(data){
				
				getMenuPath(tabType, menuNo);
				
				$("#divAppendPoint").html("");
				if(data.result=="00"){
					var list = data.list;
					
					if(data.list.length==0){
						$("#divAppendPoint").append("<div class='empty-folder'>폴더없음</div>");
						return;
					}
					
					
					$(list).each(function(index, item){
						var html = "";
						html	+= '<div class="row folderRow">'
								+  '	<div class="col-xs-2 radioCell checks">'
								+  '		<input type="radio" id="chkMenu'+item.MENU_NO+'" name="chkMenu" value="'+item.MENU_NO+'"/>'
								+  '	</div>'
								+  '	<div class="col-xs-10 textCell" id="'+item.MENU_NO+'" name="forder" data-children="'+item.CHILDREN+'">'
								+  '  		<div  class="pop-folder-tit">'
								+ 				item.TITLE
								+  '		</div>'
								+  '		<div class="pop-folder-desc">'
								+  				item.DESCRIPT
								+  '		</div>'
								+  '	</div>'
								+  '</div>';
								
						$("#divAppendPoint").append(html);
						
						console.log("======비활성화 확인=====");
						console.log(menuInfo.no);
						console.log(item.MENU_NO);
						
						
						if(menuInfo.no == item.MENU_NO){
							console.log($("#chkMenu"+item.MENU_NO));
							$("#chkMenu"+item.MENU_NO).attr("disabled","disabled");
						}
						console.log("====================");
						$("[name='forder']").off().on("click",function(){
							
							var folderId = $(this).attr("id");
							
							var pathId = "path"+item.MENU_NO;
							
							var pathCount = $("#divPath span").length;
							
							$("#divPath span").on("click",function(){
								var pathMenuNo= $(this).data("no");
								
								var pathIndex = $(this).data("count");
								
								var pathArr = $("#divPath span");
								
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
				
				$("#divPath").html('<span class="pop-path" id="path0" data-no="0" data-count="0">ROOT</span>');
				
				$("#path0").on("click",function(){
					explorerFolder("Sentence", "0");
				});
				
				if(data.result=="00"){
					var menuPath = data.path.MENU_PATH;
					var path = data.path.PATH;
					
					var arrMenuPath = menuPath.split(">");
					var arrPath = path.split(">");
					
					$(arrMenuPath).each(function(index, item){
						
						var addPath = '<div class="path-split"><span class="glyphicon glyphicon-chevron-right"></span></div><span class="pop-path" id="path'+arrPath[index]+'" data-no="'+arrPath[index]+'">'+item+'</span>';
						
						$("#divPath").append(addPath);
						
						$("#path"+arrPath[index]).on("click",function(){
							explorerFolder("Sentence", arrPath[index]);
						});
					});
					
					
					
				}
			}
		});
	}
	
	
	$("#modifyPopPositionMove").on("click",function(){
		var tabType = "Sentence";
		var no = menuInfo.no;
		explorerFolder(tabType, no);
		$("#selectPositionPop").fadeIn();
		
	});
	
	$("#btnPositionSelect").on("click",function(){
		var radioArr = $("#divAppendPoint").find("input");
		
		var radioChk = false;
		$(radioArr).each(function(index, item){
			console.log(item);
			if($(item).is(':checked')){
				radioChk = true;
				return;
			}
		});
		if(!radioChk){
			alert("폴더를 선택하세요.")
			return;
		}
		
		$("#selectPositionPop").hide();
		$("#modifyPath").html($("#divPath").html());
		
	});
	
});

</script>
<div class="select-position-pop" id="selectPositionPop" >
	<div class="pop-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnSelectPositionPopClose" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
		</div>
		<span class="top-back-txt modify-pop-tit-txt">폴더 이동 위치 선택</span>
	</div>
	<div class="modify-pop-body">
		<!-- 폴더  -->
		<div class="pop-folder-area">
			<div class="pop-folder">
				<div class="path-explorer" id="divPath">
					
				</div>
				<div class="container-fluid" id="divAppendPoint">
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
	<div class="modify-pop-body">
	
		<div class="form-group">
			<label for="title">폴더명</label>
			<input type="text" class="form-control" id="addTitle" name="title" placeholder="이메일을 입력하세요.">
		</div>
		<div class="form-group">
			<label for="descript">설명</label>
			<input type="text" class="form-control" id="addDescript" name="descript" placeholder="설명을 입력하세요.">
		</div>
		<div class="form-group">
			<label for="descript">위치</label>
			<div> 
				<span id="addPath"><!-- 토익단어 > 챕터1 단어 > 챕터 1-1 단어 --> 위치선택 버튼을 클릭해주세요</span>
			</div>
			<div class="pop-btn-full">저장</div>
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
			<input type="text" class="form-control" id="modifyTitle" name="title" placeholder="폴더명을 입력하세요.">
		</div>
		<div class="form-group">
			<label for="descript">설명</label>
			<input type="text" class="form-control" id="modifyDescript" name="descript" placeholder="설명을 입력하세요.">
		</div>
		<div class="form-group">
			<label for="descript">위치</label>
			<div> 
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
		
		
		<!-- 루트 -->
		<ul class="nav nav-tabs  cate-tab">
			<li name="tabMenu" role="presentation" <c:if test="${tabType eq 'Sentence'}">class="active"</c:if>><a href="javascript:void(0);">Sentence</a></li>
			<li name="tabMenu" role="presentation" <c:if test="${tabType eq 'Word'}">class="active"</c:if>><a href="javascript:void(0);">Word</a></li>
		</ul>
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
		
		<div id="divCateBox" class="cate-box" >
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
						<input type="radio" id="chkMenu${id}" name="chkMenu" value="${id}"/> 
						<label for="chkMenu${id}"><span></span></label>
						${menu.TITLE} 
						<c:if test="${menu.FORDER_YN eq 'N'}">
							<i><span class="glyphicon glyphicon-folder-open ml10"></span></i>
						</c:if>
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
</div>
<div id="divBotBtnWrap" class="insert-head-wrap">
	<div id="btnModify"  class="pop-btn-float">선택 폴더 수정</div>
	<div id="btnAddFolder"  class="pop-btn-float">선택 지점에 폴더 추가</div>
</div>


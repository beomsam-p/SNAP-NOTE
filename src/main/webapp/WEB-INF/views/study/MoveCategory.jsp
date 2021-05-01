<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
$(function(){
	$("#btnBack").on("click",function(){
		history.back();
	});
	
	$(document).on('mousedown', function(event) {
		
		// Code here
		if ((event.button == 2) || (event.which == 3)) {
		   
		}
	});
	
	$(document).on("contextmenu",function(event){
		console.log(event.pageX);
		console.log(event.pageY);
	   // $("#divContextMenu").fadeIn().css({top: event.pageY + "px", left: event.pageX + "px"});
    	return false;
	}).on("click", function(event) {
	   // $("#divContextMenu").hide();
	}); 
	
	
	var tabType = "${tabType}";
	var menuNo = "${menuNo}";
	
	explorerFolder(tabType, menuNo);
	
	getMenuPath(tabType, menuNo);
	
	
	
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
						html	+= '<div class="move-cate-Row">'
								+  '	<span class="glyphicon glyphicon-folder-open move-cate-icon"></span>'
								+  ' 	<div  class="move-cate-tit"  id="'+item.MENU_NO+'" name="forder" data-children="'+item.CHILDREN+'">'
								+ 			item.TITLE
								+  '		<div class="move-cate-desc">'
								+  				item.DESCRIPT
								+  '		</div>'
								+  '    </div>'
								
								+  '</div>';
							

						$("[name='divAppendPoint']").append(html);
						
						
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
	
});
</script>
<div id="divContextMenu" class='move-cate-context-menu'>
	<div class="move-cate-context-menu-head-wrap">
		<span class="move-cate-context">우클릭 메뉴</span>
	</div>
</div>
<div class="move-cate">
	<div class="move-cate-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
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
				<div class="container-fluid" name="divAppendPoint">
					<!-- append list-->
					
					<!-- append list -->
				</div>
			</div>		
		</div>
		<!-- 폴더  -->
		
	</div>
	<div class="form-group">
		<div id="btnPositionSelect" class="pop-btn-full">선택</div>
	</div>
</div>


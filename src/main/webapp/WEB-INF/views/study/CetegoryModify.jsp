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
		menuInfo.no = $(this).parent().parent().attr("id");
		menuInfo.title = $(this).parent().parent().data("title");
		menuInfo.descript = $(this).parent().parent().data("desc");
		menuInfo.depth = $(this).parent().parent().data("depth");
		menuInfo.path = $(this).parent().parent().data("path");
		console.log(menuInfo);
	});
	
	$("#btnModify").on("click",function(){
		var checkRadio = false;
		$("[name='chkMenu']").each(function(index, item){
			if($(item).is(":checked")){
				checkRadio=true;
				return false //break;
			}
		});
		
		if(!checkRadio){
			alert("폴더를 선택해 주세요")
			return false; //return
		}
		
		common.loding(true);
		$("#modifyPop").fadeIn();
		$("#title").val(menuInfo.title);
		$("#descript").val(menuInfo.descript);
		$("#path").html(menuInfo.path);
		
		
	});
	
	$("#btnModifyPopClose, #btnAddFolderPopClose").on("click",function(){
		common.loding(false);
		$(".modify-pop").hide();
	});
	
	$("#btnAddFolder").on("click",function(){
		common.loding(true);
		$("#addfolderPop").fadeIn();
	});
});

</script>

<div class="modify-pop" id="modifyPop">
	<div class="pop-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnModifyPopClose" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
		</div>
		<span class="top-back-txt modify-pop-tit-txt">메뉴 정보 수정</span>
	</div>
	<div class="modify-pop-body">
	
		<div class="form-group">
			<label for="title">폴더명</label>
			<input type="text" class="form-control" id="title" name="title" placeholder="이메일을 입력하세요">
		</div>
		<div class="form-group">
			<label for="descript">설명</label>
			<input type="text" class="form-control" id="descript" name="descript" placeholder="암호">
		</div>
		<div class="form-group">
			<label for="descript">위치</label>
			<div> 
				<span id="path" class="pup-path"><!-- 토익단어 > 챕터1 단어 > 챕터 1-1 단어 --></span>
			</div>
			<div class="pop-btn-float">하위 폴더 추가</div>
			<div class="pop-btn-float">위치 변경</div>
			<div class="pop-btn-save">저장</div>
		</div>
	</div>
</div>



<div class="modify-pop" id="addfolderPop">
	<div class="pop-head-wrap">
		<div class="back-head modify-pop-tit-txt">
			<span id="btnAddFolderPopClose" class="glyphicon glyphicon-menu-left btn-back modify-pop-tit-txt"></span>
		</div>
		<span class="top-back-txt modify-pop-tit-txt">메뉴 정보 수정</span>
	</div>
	<div class="modify-pop-body">
	
		<div class="form-group">
			<label for="title">폴더명</label>
			<input type="text" class="form-control" id="title" name="title" placeholder="이메일을 입력하세요">
		</div>
		<div class="form-group">
			<label for="descript">설명</label>
			<input type="text" class="form-control" id="descript" name="descript" placeholder="암호">
		</div>
		<div class="form-group">
			<label for="descript">위치</label>
			<span id="path" class="pup-path">위치선택 버튼을 클릭해주세요.</span>
			<div class="pop-btn-save">위치선택</div>
			<div class="pop-btn-save">저장</div>
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
			<c:forEach items="${list}" var="menu" varStatus="status">
				<c:if test="${tabType eq 'Sentence'}">
					<c:set var="id" value="${menu.MENU_NO }"/>
				</c:if>
				<c:if test="${tabType eq 'Word'}">
					<c:set var="id" value="${menu.WORD_NO }"/>
				</c:if>
				<div class="cate-menu <c:if test="${menu.LVL ne 0}"> cate-lvl0 </c:if>"
					
					style="	margin-left: ${2*menu.LVL+10}px;"
					
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
				 
					<div class="cate-tit"
						style="">
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
<div class="insert-head-wrap">
	<div id="btnModify"  class="pop-btn-float">선택 폴더 수정</div>
	<div id="btnAddFolder"  class="pop-btn-float">새 폴더 추가</div>
</div>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
$(function(){
	$(document).on("contextmenu",function(e){
        return false;
    });


	
	
	var chkInclude = false;
	//메뉴닫기
	$("#btnBack").on("click",function(){
		location.href="/";
	});
	
	$("[name='tabMenu']").on("click",function(){
		location.href="/study/category?tabType="+$(this).text();
	});
	
	
	$("[name='menu']").off().on("mousedown",function(e){
		e.stopPropagation();
		var $this = $(this);
		var innerCateId = "#innerCateBox"+$this.attr('id');
		if(	$(innerCateId).css("display") == "none"){
			$this.children().children("span").attr("class","glyphicon glyphicon-minus cate-icon");
			$(innerCateId).slideDown();
		}else{
			$this.children().children("span").attr("class","glyphicon glyphicon-plus cate-icon");
			$(innerCateId).slideUp();
		} 
	});
	
	
	$("#btnCateModify").on("click",function(){
		location.href = "/study/categoryModify?tabType=Sentence";
	});
	
	
});

</script>



<div id="menuList" class="menuList">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">카테고리</span>
			<span id="btnCateModify" class="glyphicon glyphicon-cog btn-setting"></span>
		</div>
		
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
			
				<div class="cate-menu <c:if test="${menu.LVL ne 0}"> cate-lvl0 </c:if>"
					
					style="	margin-left: ${5*menu.LVL+10}px;"
					
					data-forder="${menu.FORDER_YN}"
					data-parent="${menu.PARENT_NO}"
					data-path="${menu.PATH}"
					data-lvl="${menu.LVL}"
					name="menu"
					<c:if test="${tabType eq 'Sentence'}">
						id="${menu.MENU_NO }"
					</c:if>
					<c:if test="${tabType eq 'Word'}">
						id="${menu.WORD_NO }"
					</c:if>
				 >
				 
					<div class="cate-tit <c:if test="${menu.FORDER_YN eq 'N'}">cate-tit-noforder</c:if>"
						style="">
						<c:if test="${menu.FORDER_YN eq 'N'}">
							<i><span class="glyphicon glyphicon-folder-open ml10"></span></i>
						</c:if>
						${menu.TITLE} 
						<c:if test="${menu.CHILDREN eq 'CHILDREN_EXIST'}" var="children">
							<span class="glyphicon glyphicon-plus cate-icon"></span>
						</c:if>
					</div>
					
					<div class="cate-desc">${menu.DESCRIPT}</div>
					
					<div class="cate-inner-box" id="innerCateBox<c:if test="${tabType eq 'Sentence'}">${menu.MENU_NO }</c:if><c:if test="${tabType eq 'Word'}">${menu.WORD_NO }</c:if>">
					
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

	

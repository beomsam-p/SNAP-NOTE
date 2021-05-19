<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 


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
		location.href="/study/folder/category?tabType="+$(this).text();
	});
	
	
 	$("[name='btnPlus']").off().on("click",function(e){
		e.stopPropagation();
		var $this = $(this).parent().parent();
		var innerCateId = "#innerCateBox"+$this.attr('id');

		if(	$(innerCateId).css("display") == "none"){
			$this.children().children("span").attr("class","glyphicon glyphicon-minus cate-icon");
			$(innerCateId).slideDown();
		}else{
			$this.children().children("span").attr("class","glyphicon glyphicon-plus cate-icon");
			$(innerCateId).slideUp();
		} 
	}); 

	$(".cate-tit").off().on("click",function(e){
		e.stopPropagation();
		//해당폴더 상세로 이동할 예정
		var menuNo = $(this).parent().attr('id');
		var tabType = "Sentence";
		location.href = "/study/folder/moveFolder?menuNo="+menuNo+"&tabType="+tabType;
	});
	
	
	$("#btnCateModify").on("click",function(){
		location.href = "/study/folder/categoryModify?tabType=Sentence";
	});
	
	
});

</script>



<div id="menuList" class="menuList">
	<div class="back-head-wrap">
		<div class="back-head">
			<span id="btnBack" class="glyphicon glyphicon-menu-left btn-back"></span>
			<span class="top-back-txt">폴더</span>
			<span id="btnCateModify" class="glyphicon glyphicon-cog btn-setting"></span>
		</div>
		
	</div>
	<div class="menu-box">
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
					<c:if test="${fn:length(list) eq 0 }" var="result">
						<span  name="btnPlus" class="glyphicon glyphicon-unchecked move-cate-icon-empty"></span>
					</c:if>
					<c:if test="${!result}">
						<span  name="btnPlus" class="glyphicon glyphicon-minus cate-icon"></span>
					</c:if>
					스냅노트 
				</div>
						
				<div class="cate-desc">ROOT</div>
				
				<div class="cate-inner-box"  id="innerCateBox0">
				
					<!-- 동적 카테고리 출력부 -->
					<c:forEach items="${list}" var="menu" varStatus="status">
			
						<div class="cate-menu <c:if test="${menu.LVL ne 0}"> cate-lvl0 </c:if>"
							
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
						 	
							
							<div class="cate-tit">
								<c:if test="${menu.CHILDREN eq 'CHILDREN_EXIST'}" var="children">
									<span  name="btnPlus" class="glyphicon glyphicon-plus cate-icon"></span>
								</c:if>
							 	<c:if test="${!children}" >
									<span  name="btnPlus" class="glyphicon glyphicon-unchecked move-cate-icon-empty"></span>
								</c:if>
								${menu.TITLE} 
								<span class="badge mt-minus-10per">${menu.SENTENCE_COUNT}</span>
							</div>
							
							<div class="cate-desc">${menu.DESCRIPT}</div>
							
							<div class="cate-inner-box"  id="innerCateBox<c:if test="${tabType eq 'Sentence'}">${menu.MENU_NO }</c:if><c:if test="${tabType eq 'Word'}">${menu.WORD_NO }</c:if>">
							
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
					<!-- //동적 카테고리 출력부 -->
					
					
					
				</div>
			</div>
			<!-- //루트 -->
			
			
		</div>
		
	</div>
</div>

	

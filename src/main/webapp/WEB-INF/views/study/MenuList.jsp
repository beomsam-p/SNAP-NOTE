<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
$(function(){
	$("[name='menu']").on("click",function(){
		
		var $this = $(this);
		
		$("[name='menu']").each(function (index, item) {
			if(item.dataset["parent"] == $this.attr("id")){
			
				if(item.style.display == "none"){
				
					item.style.display = "block";
			
				}else{

					item.style.display = "none";				
					$("[name='menu']").each(function (index, inItem) {
						
						if(inItem.dataset["parent"] == item.getAttribute('id')){
							inItem.style.display = "none";
						};
					
					});
				}
			
			}			
		});	
		
		
	});
});
</script>
<c:forEach items="${list}" var="menu">
	<div style="	
			margin-top : 15px;
			margin-left: ${20*menu.LVL}%;		
			padding : 5px 15px 5px 15px ;
			border-radius: 10px;
			font-weight: bold;	
			color: white;		
			<c:if test="${menu.LVL ne 0}">
				display:none;
			</c:if>
			<c:if test="${menu.FORDER_YN == 'Y'}">
				background: #D09E88;
				
			</c:if>
			<c:if test="${menu.FORDER_YN == 'N'}">
				background: #534847;
			</c:if>
			"
		data-forder="${menu.FORDER_YN}"
		data-parent="${menu.PARENT_NO}"
		name="menu"
		id="${menu.MENU_NO }"
		 >
		<div class="cate-tit">${menu.TITLE}</div>
		<div class="cate-desc">${menu.DESCRIPT}</div>
	</div>
</c:forEach>

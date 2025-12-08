<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="includes/header.jsp"%>

	<h1>Logout Page</h1>
	<div>로그아웃하시겠습니까?</div>
	<form method="post" action="/customLogout">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<br>
		<button type="submit">네</button><br><br>
	</form>
	
	<a href="/board/list">게시판으로 복귀</a>


 <%@include file="includes/footer.jsp"%>
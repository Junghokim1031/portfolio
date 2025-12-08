<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
	<h1>ALL ARE WELCOME HERE</h1>
	<a href="/board/list">게시판으로 복귀</a><br><br>
	
	<form method="post" action="/customLogout">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<button type="submit">Logout</button>
	</form>
<%@include file="../includes/footer.jsp"%>
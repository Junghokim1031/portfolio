<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp"%>
	<h1>ADMIN</h1>
	<p>principal    : <sec:authentication property="principal"/></p>
	<p>MemberVO     : <sec:authentication property="principal.member"/></p>
	<p>사용자이름      : <sec:authentication property="principal.member.userName"/></p>
	<p>사용자아이디     : <sec:authentication property="principal.username"/></p>
	<p>사용자 권한 리스트: <sec:authentication property="principal.member.authList"/></p> 
	
	
	
	<a href="/board/list">게시판으로 복귀</a><br><br>
	<form method="post" action="/customLogout">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<button type="submit">Logout</button>
	</form>
<%@include file="../includes/footer.jsp"%>
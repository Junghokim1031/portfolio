<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://www.springframework.org/security/tags" prefix="sec" %>    
<%@include file="includes/header.jsp"%>
	<h1>접근 권한이 없습니다.</h1>
	<h2><a href="/customLogin">다시 접속해주세요</a></h2>
	<h2><c:out value="${SPRING_SECURITY_403_EXCEPTION.getMessage()}"/></h2>
	<h2><c:out value="${msg}"/></h2>

<%@include file="includes/footer.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="includes/header.jsp"%>
<style>
	#centerLogin{
		height: 80vh;  
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
</style>
	<div id="centerLogin" class="container">	
		<div>
			<h1 class="text-center">Custom Login Page</h1>
			<h2 class="text-center"><c:out value="${error}"/></h2>
			<h2 class="text-center"><c:out value="${logout}"/></h2>
			<form method='post' action="/login">
				<div>
					<label class="form-label">ID</label>
					<input class="form-control" type='text' name='username' placeholder='id'>
				</div>
				<div>
					<label class="form-label">Password</label>
					<input type="password" name="password" id="password" class="form-control" placeholder="password">
				</div>
				<div>
					<input class="form-check-input" type='checkbox' name='remember-me' id="remember-me" checked="">
					<label class="form-check-label" for="remember-me">자동로그인</label> 
				</div>
				
				<div>
					<button type="submit">로그인</button>
				</div>
				<br>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<a href="/board/list">게시판으로 복귀</a>
			</form>
		</div>
	</div>
  
 <%@include file="includes/footer.jsp"%>
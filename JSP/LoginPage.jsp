<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Stadtplatz Login</title>
		
		
		<link rel="stylesheet" type="text/css" href="style.css"/>
		
		<script>
		
			function tryLogin() {
				
				var myParams = new XMLHttpRequest();
				myParams.open("POST", "OneServlet?cmd="+"login"+"&username=" + document.loginForm.username.value + 
						"&password=" + document.loginForm.password.value, false);
				myParams.send();
				
				// If no error message returned, return true
				if (myParams.responseText.trim().length == 0) {
					window.location.href = "HomePage.jsp";
					return false;
				}
			
				
				document.getElementById("loginErrorMessage").innerHTML = myParams.responseText.trim();
				return false;
			}
			
			
			function loadPage() {
				
			}
		
			
		</script>
	
	</head>
	
	<body onload="loadPage()">
	
	
		<div id="HomeBar" class="homeBarDiv">
			<br/>
			<a id="titleText" class="titleText" href="HomePage.jsp">Stadtplatz</a>
			
			<br/><br/>
		</div>
		
		
		
		<div id="loginForm" style="margin-left:50px;margin-right:50px;">
			<br/>
			<form name="loginForm" onsubmit="return tryLogin()" action="HomePage.jsp">
				Username
				<input name="username" type="text" placeholder="Username"><br/><br/>
				Password
				<input name="password" type="password" placeholder="Password">
				<br/>
				<input name="registerButton" type="submit" value="Login">
				<br/>
			</form>
			
			<b id="loginErrorMessage" style="color:red;"></b>
			<br/>
			<a href="RegisterPage.jsp">I don't have an account</a>
			<br/>
			
		</div>
		
	</body>
	
</html>

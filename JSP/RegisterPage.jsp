<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Stadtplatz Register</title>
		
		
		<link rel="stylesheet" type="text/css" href="style.css"/>
		
		<script>
		
			function tryRegister() {
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd=" + "register" + 
						"&username=" + document.registerForm.username.value + 
						"&fName=" + document.registerForm.firstName.value + 
						"&lName=" + document.registerForm.lastName.value + 
						"&password=" + document.registerForm.password.value + 
						"&confirmPassword=" + document.registerForm.confirmPassword.value, false);
				myParams.send();
				
				
				// If no error message returned, return true
				if (myParams.responseText.trim().length == 0) {
					window.location.href = "HomePage.jsp";
					return false;
				}
			
				document.getElementById("registerErrorMessage").innerHTML = myParams.responseText.trim();
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
			<form name="registerForm" onsubmit="return tryRegister()" action="HomePage.jsp">
				Username
				<input name="username" type="text" placeholder="Username"><br/><br/>
				First Name
				<input name="firstName" type="text" placeholder="First Name"><br/><br/>
				Last Name
				<input name="lastName" type="text" placeholder="Last Name"><br/><br/>
				Password
				<input name="password" type="password" placeholder="Password"><br/><br/>
				Confirm Password
				<input name="confirmPassword" type="password" placeholder="Password Again">
				<br/>
				<input name="registerButton" type="submit" value="Resigter">
				<br/>
			</form>
			
			<b id="registerErrorMessage" style="color:red;"></b>
			<br/>
			<a href="LoginPage.jsp">I already have an account</a>
			<br/>
			
		</div>
		
	</body>
	
</html>y>
</html>

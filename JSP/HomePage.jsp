<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Stadtplatz Home
		</title>
		
		
		<style>
			.homeBarDiv {
				background-color: green;
			}
			.titleText {
				text-decoration: none;
				color: white;
				float:left;
				margin-left:50px;
			}
			.classPicker {
				float: left;
				margin-left:50px;
			}
			.loginButton {
				text-decoration: none;
				color: white;
				float:right;
				margin-right:50px;
			}
			.registerButton {
				text-decoration: none;
				color: white;
				float:right;
				margin-right:50px;
			}
			.classSearch {
				background-color: white;
			}
			.classTitle {
				font-weight: bold;
				text-decoration: none;
				color:gray;
				margin-left:25px;
			}
			.className {
				color:gray;
			}
			.classDescription {
				color:gray;
				margin-left:50px;
				color:gray;
			}
			.classAddButton {
				margin-left:50px;
			}
			
		</style>
		
		<script>
		
			function selectClass() {
				//alert("selectClass()");
				var choice = document.classPicker.classChoice.value;
				if (choice.length == 0)
					return;
				//alert("Chose: " + choice);
				window.location.href = "PostsPage.jsp?classID=" + choice;
			}
			
			function signOut() {
				
				//alert("signOut()");
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"signOut", false);
				myParams.send();
	
				checkSignedIn();
				
			}
			
			function checkSignedIn() {
				
				//alert("checkSignedIn()");
				
				var userName = "";
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"checkSignedIn", false);
				myParams.send();
				
				userName = myParams.responseText.trim();
				
				if (userName.length == 0) {	// If not logged in
					document.getElementById("loginButton").innerHTML = "Login";
					document.getElementById("registerButton").innerHTML = "Register";
					
					document.getElementById("welcomeText").innerHTML = "";
					document.getElementById("signOutButton").innerHTML = "";
				
					document.getElementById("classPicker").innerHTML = "";
				}
				else {
					document.getElementById("loginButton").innerHTML = "";
					document.getElementById("registerButton").innerHTML = "";
					
					document.getElementById("welcomeText").innerHTML = "Hello, " + userName;
					document.getElementById("signOutButton").innerHTML = "Sign Out";
					
					loadClassPicker();
				}	
				
				
				loadClassList();
				
				
			}
			
			function loadClassPicker() {
				
				//alert("loadClassPicker()");
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"getUserClasses", false);
				myParams.send();
				
				//alert(myParams.responseText.trim());
				
				var classData = JSON.parse(myParams.responseText.trim());
				
				var numClasses = 0;
				if (classData["num"] != undefined)
					numClasses = classData["num"];
				
				
				var newHTML = "<option value=\"\" selected>Pick Class</option>";
				
				for (var i = 0; i < numClasses; i++) {
					
					newHTML += "<option value=\""+ classData["classes"][i]["id"] + "\">" + classData["classes"][i]["code"] + "</option>"
				}
				document.getElementById("classPickerSelect").innerHTML = newHTML;
			}
			
			
			function addClass(classID) {
				//alert("addClass()");
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd=" + "addClass" + "&classID="+classID, false);
				myParams.send();
				
				if (myParams.responseText.trim().length == 0) {
					document.getElementById("addButton"+classID).innerHTML = "+";
				}
				else {
					document.getElementById("addButton"+classID).innerHTML = "-";
				}
				
				
				loadClassPicker();
				
			}
			

			function loadClassList() {
				
				//alert("loadClassList()");
				
				var searchText = document.searchBar.searchText.value;
				
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"searchClasses" + "&searchText="+document.searchBar.searchText.value, false);
				myParams.send();
				
				//alert(myParams.responseText.trim());
				
				var classData = JSON.parse(myParams.responseText.trim());
				
				var numResults = 0;
				
				if (classData["num"] != undefined)
					numResults = classData["num"];
				
				
				var userName = "";
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"checkSignedIn", false);
				myParams.send();
				
				userName = myParams.responseText.trim();
				
				if (numResults == 0 && searchText.length > 0) {
					document.getElementById("searchErrorMessage").innerHTML = "Yikes, no results for " + searchText;
					document.getElementById("searchResults").innerHTML = "";
					
					return false;
				}
				
				document.getElementById("searchErrorMessage").innerHTML = "";
				
				var newHTML = "";
				
				for (var i = 0; i < numResults; i++) {
					newHTML += "<a class=\"classTitle\" href=\"PostsPage.jsp?classID=" + classData["classes"][i]["id"] + "\">" + classData["classes"][i]["code"] + "</a>";
					newHTML += "<b class=\"className\"> -- " + classData["classes"][i]["name"] + "";
					
					var enrolled = false;
					
					
					
					for (var j = 0; j < classData["enrollment"]["num"]; j++) {
						if (classData["enrollment"]["classes"][j]["id"] == classData["classes"][i]["id"]) {
							enrolled = true;
						}
					}
					
					if (userName.length != 0)
						if (!enrolled)
							newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ")\" class=\"classAddButton\"> + </button>";
						else
							newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ")\" class=\"classAddButton\"> - </button>";
						
					newHTML += "</br><b class=\"classDescription\">" + classData["classes"][i]["description"] + "</b></br></br>";
				}
				
				document.getElementById("searchResults").innerHTML = newHTML;
				
				
				return false;
				
			}
			
			
			
			function loadPage() {
				//alert("loadPage()");
				checkSignedIn();				
			}
		
			
		</script>
	
	</head>
	
	<body onload="loadPage()">
	
	
		<div id="HomeBar" class="homeBarDiv">
			<br/>
			<a id="titleText" class="titleText" href="HomePage.jsp">Stadtplatz</a>
			
			<form name="classPicker" class="classPicker" id="classPicker">
				<select id="classPickerSelect" name="classChoice" onchange="selectClass()">
				</select>
			</form>
			
			<a id="registerButton" class="registerButton" href="RegisterPage.jsp"></a>
			<a id="loginButton" class="loginButton" href="LoginPage.jsp"></a>
			
			<a id="signOutButton" class="loginButton" onclick="signOut()"></a>
			<a id="welcomeText" class="registerButton"></a>
			
			<br/><br/>
		</div>
		
		
		
		<div id="classSearch" style="margin-left:50px;margin-right:50px;">
			<br/>
			<form name="searchBar" onsubmit="return loadClassList()">
				<input name="searchText" type="text" placeholder="Class code">
				<input name="searchButton" type="submit" value="Search">
			</form>
			<br/>
			<b id="searchErrorMessage" style="color:red;"></b>
			<br/>
			<div id="searchResults" style="background-color:white;">
				
			</div>
		</div>
		
	</body>
	
</html>
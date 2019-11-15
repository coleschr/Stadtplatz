<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Stadtplatz Home
		</title>
		
		
		<link rel="stylesheet" type="text/css" href="style.css"/>
		
		<script>
			 //for use in PostsPage -> determine default welcome text in main stage.
			sessionStorage.setItem("classChosen", "0");
			sessionStorage.setItem("selected","null"); //for posts page.
			 //not actually called when you choose a class...
			function selectClass() {
				
				var choice = document.classPicker.classChoice.value;
				
				if (choice.length == 0)
					return;
				alert("Chose: " + choice);
				window.location.href = "PostsPage.jsp?classID=" + choice;
			}
			
			
			/*
				Added so clicking + desn't also try to activate the div's href anchor
			*/
			function openClass(choice) {
				sessionStorage.setItem("classChosen", "1");
				alert("openClass(choice)");
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
					document.getElementById("addButton"+classID).className = "classAddButton";
				}
				else {
					document.getElementById("addButton"+classID).className = "classRemoveButton";
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
					newHTML += "<a onclick=\"openClass('" + classData["classes"][i]["id"] + "')\"><div class=\"classResult\"><b class=\"classTitle\">" + classData["classes"][i]["code"] + "</b>";
					newHTML += "<b class=\"className\"> -- " + classData["classes"][i]["name"] + "";
					
					var enrolled = false;
					
					
					
					for (var j = 0; j < classData["enrollment"]["num"]; j++) {
						if (classData["enrollment"]["classes"][j]["id"] == classData["classes"][i]["id"]) {
							enrolled = true;
						}
					}
					
					if (userName.length != 0)
						if (!enrolled)
							newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ");event.stopPropagation()\" class=\"classAddButton\">   </button>";
						else
							newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ");event.stopPropagation()\" class=\"classRemoveButton\">   </button>";
						
					newHTML += "<p class=\"classDescription\">" + classData["classes"][i]["description"] + "</p></div></a>";
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
		
		<div class="homeScreenDiv">
			<img src="assets/logo.png"/>
			<h1>Stadtplatz</h1>
		</div>
		
		<div id="classSearch" class="classSearch">
			<br/>
			<form name="searchBar" onsubmit="return loadClassList()">
				<input class="searchText" name="searchText" type="text" placeholder="Class code">
				<input class="searchButton" name="searchButton" type="submit" value="     ">
			</form>
			<b id="searchErrorMessage" style="color:red;"></b>
			<br/>
			<div id="searchResults">
				
			</div>
		</div>
		
	</body>
	
</html>

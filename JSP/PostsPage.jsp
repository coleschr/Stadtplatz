<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Stadtplatz Posts
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
				font: 30px Ariel;
				
			}
			.className {
				color:gray;
				font: 30px Ariel;
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
				
				//checkSignedIn();
				
				window.location.href = "HomePage.jsp";
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
			
			function isSignedIn() {
				var userName = "";
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"checkSignedIn", false);
				myParams.send();
				
				userName = myParams.responseText.trim();
				
				if (userName.length == 0)
					return false;
				return true;
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
					document.getElementById("newButton").innerHTML = "";
				}
				else {
					document.getElementById("addButton"+classID).innerHTML = "-";
					document.getElementById("newButton").innerHTML = "<button onclick=\"loadNewPost()\">New</button>";
				}
				
				
				loadClassPicker();
				
			}
			
			function parseSearchParams() {
				var params = {};
			    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
			    function(m,key,value) {
			      params[key] = value;
			    });
			    return params;
			 }
			

			function loadClassList() {
				
				//alert("loadClassList()");
				
				var searchFor = parseSearchParams()["classID"];
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"getClassByID" + "&classID="+searchFor, false);
				myParams.send();
				
				
				
				var classData = JSON.parse(myParams.responseText.trim());
				
				
				var numResults = 0;
				
				if (classData["num"] != undefined)
					numResults = classData["num"];
				
				
				
				var userName = "";
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"checkSignedIn", false);
				myParams.send();
				
				userName = myParams.responseText.trim();
				
				
				
				if (numResults == 0) {
					return false;
				}
				
				
				var newHTML = "";
				var i = 0;
				newHTML += "<a class=\"classTitle\" href=\"PostsPage.jsp?classID=" + classData["classes"][i]["id"] + "\">" + classData["classes"][i]["code"] + "</a>";
				newHTML += "<b class=\"className\"> -- " + classData["classes"][i]["name"] + "";
				
				
				var theseParams = new XMLHttpRequest();
				theseParams.open("GET", "OneServlet?cmd="+"checkClass" + "&classID=" + classData["classes"][i]["id"], false);
				theseParams.send();
				
				var enrolled = "";
				if (theseParams.responseText.trim().length > 0)
					enrolled = theseParams.responseText.trim();				
				
				if (userName.length != 0) {
					if (enrolled.length == 0) {
						newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ")\" class=\"classAddButton\"> + </button>";
						document.getElementById("newButton").innerHTML = "";
					}
					else {
						newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ")\" class=\"classAddButton\"> - </button>";
						document.getElementById("newButton").innerHTML = "<button onclick=\"loadNewPost()\">New</button>";
					}
				}
				else {
					document.getElementById("newButton").innerHTML = "";
				}
				
				newHTML += "<br/><br/>";//"</br><b class=\"classDescription\">" + classData["classes"][i]["description"] + "</b></br></br>";
				
				document.getElementById("classDescription").innerHTML = newHTML;
				
				
				
				return false;
				
			}
			
			
			function newPost() {
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"newPost"+
						"&title=" + document.newPostForm.title.value + 
						"&description=" + document.newPostForm.description.value +
						"&type=" + document.newPostForm.type.value+
						"&classID=" + parseSearchParams()["classID"], false);
				myParams.send();
				
				//alert(document.newPostForm.type.value);
				
				if (myParams.responseText.trim().length > 0) {
					document.getElementById("postErrorMessage").innerHTML = myParams.responseText;
					return false;
				}
				
				document.getElementById("postErrorMessage").innerHTML = "";
				
				var type = document.newPostForm.type.value;
				
				if (type == "Exam") {
					loadExams();
				}
				else {
					loadAssignments();
				}
				
				document.getElementById("postsSection").innerHTML = "<br/><br/><b></b>Post added successfully<br/><br/>";
				
				return false;
			}
			
			function loadNewPost() {
				var newHTML = "";
				
				newHTML += "<br/><form name=\"newPostForm\" onsubmit=\"return newPost()\">";
				newHTML += "Title<br/><input name=\"title\" type=\"text\" placeholder=\"Post Title\"><br/><br/>";
				newHTML += "Description<br/>";
				newHTML += "<input style=\"width:60%; height:20%;\" name=\"description\" type=\"text\" placeholder=\"Post Description\"><br/>";
				newHTML += "<fieldset style=\"border: 0px solid white;\"><input type=\"radio\" name=\"type\" value=\"Assignment\">Assignment";
				newHTML += "<input type=\"radio\" name=\"type\" value=\"Exam\">Exam</fieldset>";
				newHTML += "<input name=\"registerButton\" type=\"submit\" value=\"Post\"><br/></form>";
				newHTML += "<b id=\"postErrorMessage\" style=\"color:red;\"></b><br/>";
				
				document.getElementById("postsSection").innerHTML = newHTML;
				
			}
			
			
			function loadPosts(type) {
				//alert("Load posts " + type);
				var searchFor = parseSearchParams()["classID"];
				
				var myParams = new XMLHttpRequest();
				if (type.length == 0)
					myParams.open("GET", "OneServlet?cmd="+"getAssignments" + "&classID="+searchFor, false);
				else
					myParams.open("GET", "OneServlet?cmd="+"getExams" + "&classID="+searchFor, false);
				myParams.send();
				
				//alert(myParams.responseText.trim());
				
				var postData = JSON.parse(myParams.responseText.trim());
				
				var numResults = 0;
				
				if (postData["num"] != undefined)
					numResults = postData["num"];
				
				var newHTML = "<b>Assignments</b><br/><br/>";
				if (type.length != 0) {
					newHTML = "<b>Exams</b><br/><br/>";
				}
				
				for (var i = 0; i < numResults; i++) {
					newHTML += "<a onclick=\"loadPost(" + postData["classes"][i]["id"] + ")\">" + postData["classes"][i]["title"] + "</a></br></br>";
					//newHTML += "<a>" + postData["classes"][i]["description"] + "</a></br></br>";
				}
				
				document.getElementById("postsList").innerHTML = newHTML;
			}
			
			function loadAssignments() {
				loadPosts("");
			}
			function loadExams() {
				loadPosts("Exams");
			}
			
			
			function loadPage() {
				//alert("loadPage()");
				checkSignedIn();	
				loadAssignments();
			}
		
			function newQuestion(postID) {
				//alert("adding question to post #" + postID);
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"newQuestion"+
						"&text=" + document.newQuestionForm.text.value + 
						"&postID=" + postID, false);
				myParams.send();
				
				if (myParams.responseText.trim().length > 0) {
					document.getElementById("questionErrorMessage").innerHTML = myParams.responseText;
					return false;
				}
				
				document.getElementById("questionErrorMessage").innerHTML = "";
				
				loadPost(postID);
				
				return false;
			}
			
			function newAnswer(questionID,postID) {
				//alert("adding answer to question #" + questionID + " and post #" + postID);
				
				//alert(document.getElementById("newAnswerForm"+questionID).text.value);
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"newAnswer"+
						"&text=" + document.getElementById("newAnswerForm"+questionID).text.value + 
						"&questionID=" + questionID, false);
				myParams.send();
				
				if (myParams.responseText.trim().length > 0) {
					document.getElementById("answerErrorMessage"+questionID).innerHTML = myParams.responseText;
					return false;
				}
				
				document.getElementById("answerErrorMessage"+questionID).innerHTML = "";
				
				loadPost(postID);
				
				return false;
			}
			
			function checkUpvoted(questionID) {
				//alert("Check upvoted #"+questionID);
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"checkUpvote"+
						"&questionID=" + questionID, false);
				myParams.send();
				
				//alert(myParams.responseText.trim());
				
				if (myParams.responseText.trim().length == 0)
					return false;
				
				return true;
			}
			
			function loadPost(postID) {
				//alert("Load post #" + postID);
				
				document.getElementById("postsSection").innerHTML = "<br/><b>Loading results...</b><br/>";
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"getPost" + "&postID="+postID, false);
				myParams.send();
				
				//alert(myParams.responseText.trim());
				
				var postData = JSON.parse(myParams.responseText.trim());
				
				if (postData["num"] != 1)
					return;
				
				
				var newHTML = "<br/>";
				newHTML += "<b>" + postData["classes"][0]["title"] + "</b><br/><br/>";
				newHTML += "<a>" + postData["classes"][0]["description"] + "</a><br/><br/>";
				newHTML += "<a id=\"postID\" value=\"" + postID + "\"></a>";
				
				newHTML += "<div style=\"margin-left:2%;\">";
				
				if (isSignedIn()) {
					newHTML += "<br/><form name=\"newQuestionForm\" onsubmit=\"return newQuestion(" + postID + ")\">";
					newHTML += "Ask a question: <input name=\"text\" type=\"text\" placeholder=\"Question text\">";
					newHTML += "<input name=\"registerButton\" type=\"submit\" value=\"Ask!\"><br/></form>";
					newHTML += "<b id=\"questionErrorMessage\" style=\"color:red;\"></b><br/>";
				}
				
				
				
				newHTML += "<br/>";
				
				var numQuestions = postData["questions"]["num"];
				
				for (var i = 0; i < numQuestions; i++) {
					if (isSignedIn()) {
						if (checkUpvoted(postData["questions"]["questions"][i]["id"]))
							newHTML += "<button id=\"btnUV"+postData["questions"]["questions"][i]["id"]+"\" onclick=\"vote(" +  postData["questions"]["questions"][i]["id"] + ","+postID+")\">+</button>";
						else
							newHTML += "<button id=\"btnUV"+postData["questions"]["questions"][i]["id"]+"\" onclick=\"vote(" +  postData["questions"]["questions"][i]["id"] + ","+postID+ ")\">-</button>";
					}
					newHTML += "<a style=\"align:left;\"> " + postData["questions"]["questions"][i]["upvotes"] + "</a><br/>";
					newHTML += "<a>" + postData["questions"]["questions"][i]["text"] + "</a>";
					newHTML += "<a> - " + postData["questions"]["questions"][i]["userName"] + "</a>";
					
					
					if (isSignedIn()) {
						newHTML += "<form style=\"margin-left:2%;\" id=\"newAnswerForm" + postData["questions"]["questions"][i]["id"] + "\" onsubmit=\"return newAnswer(" + postData["questions"]["questions"][i]["id"] + ", " + postID + ")\">";
						newHTML += "Answer: <input name=\"text\" type=\"text\" placeholder=\"Answer text\">";
						newHTML += "<input name=\"registerButton\" type=\"submit\" value=\"Answer!\"><br/></form>";
						newHTML += "<b id=\"answerErrorMessage" + postData["questions"]["questions"][i]["id"] + "\" style=\"color:red;\"></b>";
					}
					var numAnswers = postData["questions"]["questions"][i]["answers"]["num"];
					
					for (var j = 0; j < numAnswers; j++) {
						newHTML += "<br/><a style=\"margin-left:5%;\">" + postData["questions"]["questions"][i]["answers"]["answers"][j]["text"] + "</a>";
						newHTML += "<a> - " + postData["questions"]["questions"][i]["answers"]["answers"][j]["userName"] + "</a><br/>";
					}
				
					
					newHTML += "<br/><br/>";
				}
				
				newHTML += "<br/><br/></div>";
				 
				
				document.getElementById("postsSection").innerHTML = newHTML;
				
			}
			
			function downvote(questionID, postID) {
				//alert("Downvote P:" + postID + " Q:" + questionID);
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"downvote"+
						"&questionID=" + questionID, false);
				myParams.send();
				
				if (myParams.responseText.trim().length != 0)
					return false;
			
				loadPost(postID);
			}
			
			function upvote(questionID, postID) {
				//alert("Upvote P:" + postID + " Q:" + questionID);
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"upvote"+
						"&questionID=" + questionID, false);
				myParams.send();
				
				if (myParams.responseText.trim().length != 0)
					return false;
				
				loadPost(postID);
			}
			
			
			
			function vote(questionID, postID) {
				if (document.getElementById(("btnUV"+questionID)).innerHTML == "+") {
					if (!upvote(questionID, postID)) return false;
					document.getElementById(("btnUV"+questionID)).innerHTML = "-";
				} else {
					if (!downvote(questionID, postID)) return false;
					document.getElementById(("btnUV"+questionID)).innerHTML = "+";
				}
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
		
		<br/><br/>
		
		
		<div>
			<div style="background-color: white; width:25%; padding-left:2%; float:left; border:1px solid gray; border-radius:5px;" id="assignmentstList">
				<br/>
				<button onclick="loadAssignments()">Assignments</button>
				<button onclick="loadExams()">Exams</button>
				<div style="float:right; margin-right:20%;" id="newButton"></div>
				<br/><br/>
				<div id="postsList">
					
				</div>
				<br/><br/><br/>
			</div>
			<div style="margin-left:5%; width:60%; float:left;" id="classDescription"></div>
			<div style="margin-left:7.5%; width:50%; float:left;" id="postsSection">
				<a>Choose a post on the left to start!</a>
			</div>
			
		</div>
		
	</body>
	
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Stadtplatz Posts</title>
		
		
		<link rel="stylesheet" type="text/css" href="style.css"/>
		<script src= "https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"> </script>
		<script>
		
		var curr_selection = "";
		var question_ids = [];
		var curr_postid = 0;
		var curr_index = question_ids.length;
		var is_active = false;
		var on_load_new_post = false;
		
		function update_questions(){
			
			if(question_ids.length == 0){
				return;
			}
			if(curr_index == 0){
				curr_index = question_ids.length;
			}
			//update_question_by_id(question_ids[curr_index-1]);
			curr_index = curr_index - 1;
			update_question_by_id(question_ids[curr_index]);
		}
		
		function set_active(){
			is_active = true;
		}
		
		function set_inactive(){
			is_active = false;
		}
		
		function update_question_by_id(id){
			var myParams = new XMLHttpRequest();
			myParams.open("GET", "OneServlet?cmd="+"getQuestionByID"+"&qid="+id, true);
			myParams.send();
			
			myParams.onreadystatechange = function() {
				if (this.readyState == 4 && this.status == 200) {
					var postData = JSON.parse(myParams.responseText.trim());
					var newHTML = "";
					
					newHTML +="<div id=\"qid"+id+"\">"
					var numAnswers = postData["num"];
					
					for (var j = 0; j < numAnswers; j++) {
						newHTML += "<div class=\"postResponseDiv\">";
						newHTML += "<a>" + postData["answers"][j]["text"] + "</a>";
						newHTML += "<a><i style=\"color:#aaa\"> - " + postData["answers"][j]["userName"] + "</i></a><br/>";
						newHTML += "</div></br>";
					}
					newHTML += "</div>";
					
					document.getElementById("qid"+id).innerHTML = newHTML;
				}
			};

		}
		
		
		function interval() {
			  //setInterval(function(){ loadPosts(curr_selection) }, 5000);
			  setInterval(function(){ update_all_posts() }, 5000);
			  setInterval(function(){ update_questions() }, 5000);
			  
		}
		
		function update_all_posts(){
			if(!is_active){
				loadPost(curr_postid);
			}
		}
		
		//var load_question_by_id(){
			
		//}
				
		sessionStorage.setItem("currCode","Pick Class");
			function selectClass() {
				sessionStorage.setItem("classChosen", "1");
				//alert("selectClass()");
				var choice = document.classPicker.classChoice.value;
				if (choice.length == 0)
					return;
				//alert("Chose: " + choice);
				//alert($("#classPicker").val()); 
				window.location.href = "PostsPage.jsp?classID=" + choice;
			}
			
			function signOut() {
				
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
					
					document.getElementById("classPicker").innerHTML = "<select id=\"classPickerSelect\" name=\"classChoice\" onchange=\"selectClass()\"></select>";
				
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
				
				var currCode = sessionStorage.getItem("currCode");
				
				//BC CHANGED! TODO: session var holding current code.
				var newHTML = "<option value=\"\" selected>"+currCode+"</option>";
				
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
					document.getElementById("addButton" + classID).className = "classAddButton";
					document.getElementById("newButton").style.visibility = "hidden";
				}
				else {
					document.getElementById("addButton" + classID).className = "classRemoveButton";
					document.getElementById("newButton").style.visibility = "visible";
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
				newHTML += "<br/><a class=\"classTitle\">" + classData["classes"][i]["code"] + "</a>";
				newHTML += "<b class=\"className\" > -- " + classData["classes"][i]["name"] + "";
				document.getElementById("classPickerSelect").SelectedValue = classData["classes"][i]["code"];
				
				var theseParams = new XMLHttpRequest();
				theseParams.open("GET", "OneServlet?cmd="+"checkClass" + "&classID=" + classData["classes"][i]["id"], false);
				theseParams.send();
				
				var enrolled = "";
				if (theseParams.responseText.trim().length > 0)
					enrolled = theseParams.responseText.trim();				
				
				
				
				if (userName.length != 0) {
					if (enrolled.length == 0) {
						newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ")\" class=\"classAddButton\"> </button>";
						//CHNAGED FOR BUTTON STYLIZING
						//document.getElementById("newButton").innerHTML = "";
						document.getElementById("newButton").style.visibility = "hidden";
						document.getElementById("postsList").className = "postsList";
					}
					else {
						newHTML += "<button id=\"addButton" + classData["classes"][i]["id"] + "\" onclick =\"addClass(" + classData["classes"][i]["id"] + ")\" class=\"classRemoveButton\"> </button>";
						document.getElementById("newButton").style.visibility = "visible";//"<button onclick=\"loadNewPost()\">New</button>";
						document.getElementById("postsList").className = "postsListEditable";
					}
				}
				else {
					//document.getElementById("newButton").innerHTML = "";
				}
				
				newHTML += "<br/><br/>";//"</br><b class=\"classDescription\" >" + classData["classes"][i]["description"] + "</b></br></br>";
				
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
				else if (type == "Assignment") {
					loadAssignments();
				}
				else if (type == "Other") {
					loadOther();
				}
				
				document.getElementById("postsSection").innerHTML = "<br/><br/><b></b>Post added successfully<br/><br/>";
				
				return false;
			}
			
			function loadNewPost() {
				var newHTML = "";
				
				newHTML += "<br/><form name=\"newPostForm\" onsubmit=\"return newPost()\">";
				newHTML += "<br/><input class=\"newPostTitle\" name=\"title\" type=\"text\" placeholder=\"Title\"><br/><br/>";
				//newHTML += "Description<br/>";
				newHTML += "<textarea class=\"newPostDescription\" rows =\"10\" name=\"description\" placeholder=\"Description\"></textarea><br/>";
				newHTML += "<fieldset style=\"border: 0px solid white;\"><input type=\"radio\" name=\"type\" value=\"Assignment\">Assignment   ";
				newHTML += "<input type=\"radio\" name=\"type\" value=\"Exam\">Exam";
				newHTML += "<input type=\"radio\" name=\"type\" value=\"Other\">Other</fieldset>";
				newHTML += "<input class=\"newPostButton\" name=\"registerButton\" type=\"submit\" value=\"Post\"><br/></form>";
				newHTML += "<b id=\"postErrorMessage\" style=\"color:red;\"></b><br/>";
				
				document.getElementById("postsSection").innerHTML = newHTML;
				
			}
			
			/*
				Loads posts based on the type, which can be "" (for Assignments) or "Exams".
			*/
			function loadPosts(type) {
				//alert("Load posts " + type);
				
				//logic for lightening the currently selected button
				/* if(type.length != 0){
					//alert("E");
					sessionStorage.setItem("selected","e");
					
				}else{ 
					//alert("A");
					sessionStorage.setItem("selected","a");
				} */
				
				var searchFor = parseSearchParams()["classID"];
					
				var myParams = new XMLHttpRequest();
				if (type == "Assignments")
					myParams.open("GET", "OneServlet?cmd="+"getAssignments" + "&classID="+searchFor, false);
				else if (type == "Exams")
					myParams.open("GET", "OneServlet?cmd="+"getExams" + "&classID="+searchFor, false);
				else if (type == "Other")
					myParams.open("GET", "OneServlet?cmd="+"getOther" + "&classID="+searchFor, false);
				myParams.send();
				
				//alert(myParams.responseText.trim());
				
				var postData = JSON.parse(myParams.responseText.trim());
				
				var numResults = 0;
				
				if (postData["num"] != undefined)
					numResults = postData["num"];
				
				/* hopefully we can make the button color the category, eventually*/
				
				// Removed header because button gets highlighted
				/* var newHTML = "<b>Assignments</b><br/><br/>";
				if (type.length != 0) {
					newHTML = "<b>Exams</b><br/><br/>";
				} */
				var newHTML = "<table>";
				
				
				//^^^ Added for this functionality
				/*I gave up... 
				sessionStorage.setItem("category","a");
				if (type.length != 0) {
					sessionStorage.setItem("category","e");
				}
				*/
				for (var i = 0; i < numResults; i++) {
					newHTML += "<tr onclick=\"loadPost(" + postData["classes"][i]["id"] + ")\"><td>" + postData["classes"][i]["title"] + "</td></tr>";
					//newHTML += "<a>" + postData["classes"][i]["description"] + "</a></br></br>";
				}
				newHTML += "</table>";
				
				document.getElementById("postsList").innerHTML = newHTML;
			}
			
			function loadAssignments() {
				
				curr_selection = "Assignments";

				loadPosts("Assignments");
				
				document.getElementById("aButton").className = "categoryActive";
				document.getElementById("eButton").className = "category";
				document.getElementById("oButton").className = "category";
			}
			
			function loadExams() {
				
				curr_selection = "Exams";

				loadPosts("Exams");
				
				document.getElementById("aButton").className = "category";
				document.getElementById("eButton").className = "categoryActive";
				document.getElementById("oButton").className = "category";
			}
			
			function loadOther() {
				//TODO: load other from database
				curr_selection = "Other";

				loadPosts("Other");
				
				document.getElementById("aButton").className = "category";
				document.getElementById("eButton").className = "category";
				document.getElementById("oButton").className = "categoryActive";
				
			}
			
			
			function loadPage() {
				//alert("loadPage()");
				checkSignedIn();	
				loadAssignments();
				interval();

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
				curr_postid = postID;
				
				
				var myParams = new XMLHttpRequest();
				myParams.open("GET", "OneServlet?cmd="+"getPost" + "&postID="+postID, false);
				myParams.send();
				//alert(myParams.responseText.trim());
				
				var postData = JSON.parse(myParams.responseText.trim());
				
				if (postData["num"] != 1)
					return;
				
				
				var newHTML = "<br/>";
				newHTML += "<div class=\"postHeaderDiv\"><b>" + postData["classes"][0]["title"] + "</b><br/><br/>";
				newHTML += "<a>" + postData["classes"][0]["description"] + "</a><br/>";
				newHTML += "<a id=\"postID\" value=\"" + postID + "\"></a>";
				
				
				//Ask a question form
				if (isSignedIn()) {
					newHTML += "<form style=\"margin-top:10px;\" name=\"newQuestionForm\" onsubmit=\"return newQuestion(" + postID + ")\">";
					newHTML += "<input class=\"msInput\" name=\"text\" type=\"text\" placeholder=\"Ask a question...\" onfocusin=\"set_active()\" onfocusout=\"set_inactive()\">";
					newHTML += "<input class=\"msButton\" name=\"registerButton\" type=\"submit\" value=\"ASK\"><br/></form>";
					newHTML += "<b id=\"questionErrorMessage\" style=\"color:red;\"></b>";
				}
				newHTML += "</div>";
				
				var numQuestions = postData["questions"]["num"];
				
				question_ids = [];
				
				for (var i = 0; i < numQuestions; i++) {
					newHTML += "<div class=\"postQuestionDiv\">";
					
					//generates upvote stuff
					
					if (isSignedIn()) {
						if (checkUpvoted(postData["questions"]["questions"][i]["id"])) {
							newHTML += "<a style=\"align:left; color:#aaa;font-size:10px;\"> " + postData["questions"]["questions"][i]["upvotes"] + "</a>";
							newHTML += "<button id=\"btnUV"+postData["questions"]["questions"][i]["id"]+"\" onclick=\"vote(" +  postData["questions"]["questions"][i]["id"] + ","+postID+")\">⇧</button></br>";
						}
						else {
							newHTML += "<a style=\"align:left; color:#1bca9b;font-size:10px; font-weight:bold;\"> " + postData["questions"]["questions"][i]["upvotes"] + "</a>";
							newHTML += "<button id=\"btnUV"+postData["questions"]["questions"][i]["id"]+"\" onclick=\"vote(" +  postData["questions"]["questions"][i]["id"] + ","+postID+ ")\">⇩</button></br>";
						}
					}
					else {
						newHTML += "<a style=\"align:left; color:#aaa;font-size:10px;\"> " + postData["questions"]["questions"][i]["upvotes"] + "</a></br>";
					}
					
					newHTML += "<a>" + postData["questions"]["questions"][i]["text"] + "</a>";
					newHTML += "<a><i style=\"color:#aaa\"> - " + postData["questions"]["questions"][i]["userName"] + "</i></a>";
					
					
					if (isSignedIn()) {
						newHTML += "<br/><form id=\"newAnswerForm" + postData["questions"]["questions"][i]["id"] + "\" onsubmit=\"return newAnswer(" + postData["questions"]["questions"][i]["id"] + ", " + postID + ")\">";
						newHTML += "<input class=\"msInput\" name=\"text\" type=\"text\" placeholder=\"Your answer...\" onfocusin=\"set_active()\" onfocusout=\"set_inactive()\">";
						newHTML += "<input class=\"msButton\" name=\"registerButton\" type=\"submit\" value=\"REPLY\"><br/></form>";
						newHTML += "<b id=\"answerErrorMessage" + postData["questions"]["questions"][i]["id"] + "\" style=\"color:red;\"></b>";
					}
					
					newHTML += "</div>";
					newHTML +="<div id=\"qid"+postData["questions"]["questions"][i]["id"]+"\">"
					var numAnswers = postData["questions"]["questions"][i]["answers"]["num"];
					question_ids.push(postData["questions"]["questions"][i]["id"]);
					for (var j = 0; j < numAnswers; j++) {
						newHTML += "<div class=\"postResponseDiv\">";
						newHTML += "<a>" + postData["questions"]["questions"][i]["answers"]["answers"][j]["text"] + "</a>";
						newHTML += "<a><i style=\"color:#aaa\"> - " + postData["questions"]["questions"][i]["answers"]["answers"][j]["userName"] + "</i></a><br/>";
						newHTML += "</div></br>";
					}
					newHTML += "</div>";

					
					//newHTML += "<br/><br/>";
				}
				
				newHTML += "<br/><br/>";
				 
				
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
			//&#x2BC5 upvote
			//&#x2BC6 downvote
			function vote(questionID, postID) {
				if (document.getElementById(("btnUV"+questionID)).innerHTML == "⇧") {
					if (!upvote(questionID, postID)) return false;
					document.getElementById(("btnUV"+questionID)).innerHTML = "⇩";
				} else {
					if (!downvote(questionID, postID)) return false;
					document.getElementById(("btnUV"+questionID)).innerHTML = "⇧";
				}
			}
			
			/*
				Determines default greeting message to display on main stage 
			*/
			$(document).ready(function() { 
				//alert("doc on ready:");
				var chosen = sessionStorage.getItem("classChosen")
				
			});
			
			
		</script>
	
	</head>
	
	<body class="postBody" style="background:#eee; overflow-x: hidden; overflow-y: hidden;" onload="loadPage()">
		
		<div id="HomeBar" style="position:absolute;top:0;box-shadow: 2px 2px 2px 2px rgba(120, 120, 120, 0.3);height:50px;width:100vw;" class="homeBarDiv">
			
			<a id="titleText" class="titleText" href="HomePage.jsp"><img src="assets/logo.png"/>Stadtplatz</a>
			
			<form name="classPicker" class="classPicker" id="classPicker"></form>
			
			<a id="registerButton" class="registerButton" href="RegisterPage.jsp"></a>
			<a id="loginButton" class="loginButton" href="LoginPage.jsp"></a>
			
			<a id="signOutButton" class="loginButton" onclick="signOut()"></a>
			<a id="welcomeText" class="registerButton"></a>
		</div>
		
		<div style="position:absolute;top:70px;left:0;right:0;bottom:0;">
			<table style="width:100vw;height:100%;padding-bottom: 40px;"><tr><td style=" background:#222222; width:260px">
				<div id="assignmentstList">
					<div style="text-align:center;margin:0;padding-bottom:8px;vertical-align:middle;">
					<button class="category" id="aButton" onclick="loadAssignments()">Assignments</button>
					<button class="category" id="eButton" onclick="loadExams()">Exams</button>
					<button class="category" id="oButton" onclick="loadOther()">Other</button>
					</div>
					
					<div id="postsList" class="postsList"></div>
					<div>
					<div class="categoryNew" onclick="loadNewPost()" style=" margin-left:5px; visibility:hidden; width:230px;" id="newButton" >New</div>
					</div>
				</div>
			</td>
			
			<td>
			<div class="postBody">
				<!-- style="border: 1px solid rgba(0, 105, 92, .4);" -->
				<div id="classDescription" style="margin-bottom:-20px; border: 1px solid rgba(0, 105, 92, 0.4);  " class="classPostTitle" ></div>
				<div id="postsSection" style="text-align:left; height = 98%;">
				<span style="text-align:center;">
					<br/><div style = "color:#aaa; padding-top:20%;">Select conversations by topic on the left!</div>
					</span>
				</div>
			</div>
				
			</td></tr></table>
		
		</div>
		
	</body>
	
</html>

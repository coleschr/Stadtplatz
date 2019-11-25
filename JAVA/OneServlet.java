package Stadplatz;


import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Stadplatz.DBCommunicator;

/**
 * Servlet implementation class OneServlet
 */
@WebServlet("/OneServlet")
public class OneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    
    // ONE SERVLET TO RULE THEM ALL
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Set up print output
        PrintWriter out = response.getWriter();
        
        // Get command type from jsp
        String command = request.getParameter("cmd");
        
        // Get some session data
        HttpSession session = request.getSession();
        
        
        // Check if we are signed in
        if (command.equals("checkSignedIn")) {
            // Just look to see if the session attribute is set
            if (session.getAttribute("firstName") != null) {
                // If it is, print it out
                out.println(session.getAttribute("firstName"));
            }
                return;
        }
        
        // User wants to sign out
        if (command.equals("signOut")) {
            // Check if we're even signed in
            if (session.getAttribute("firstName") != null) {
                // If we are, remove the session attributes
                session.removeAttribute("firstName");
                session.removeAttribute("userID");
            }
            return;
        }
        
        // User wants to register
        if (command.equals("register")) {
            
            // Get the parameters from the form
            String username = request.getParameter("username");
            String fName = request.getParameter("fName");
            String lName = request.getParameter("lName");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate thr paramters
            if (username.length() == 0) {
                out.println("Please enter username");
                return;
            }
            if (fName.length() == 0) {
                out.println("Please enter first name");
                return;
            }
            if (lName.length() == 0) {
                out.println("Please enter last name");
                return;
            }
            if (password.length() == 0 || confirmPassword.length() == 0) {
                out.println("Please enter both passwords");
                return;
            }
            if (!password.equals(confirmPassword)) {
                out.println("Passwords do not match");
                return;
            }
            
            // Now ask DB to register
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            String DBResponse = myDB.tryRegister(username, password, fName, lName);
            
            // If something goes wrong, the error will be handed back to the jsp
            out.println(DBResponse);
            
            // If there was an error, stop here
            if (DBResponse.length() != 0)
                return;
            
            // If no error we now want to login
            command = "login";
        }
        
        // User wants to login
        if (command.equals("login")) {
            
            // Get parameters from form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Validate parameters
            if (username.length() == 0) {
                out.println("Please enter username");
                return;
            }
            if (password.length() == 0) {
                out.println("Please enter password");
                return;
            }
            
            // Now ask DB to login
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            // Error message will be returned as an int
            int userID = myDB.tryLogin(username, password);
            
            // Decode the error message and pass error message back to jsp
            if (userID == -1) {
                out.println("User not found");
                return;
            }
            if (userID == -2) {
                out.println("Incorrect password");
                return;
            }
            
            // Get the name of the user from DB
            String firstName = myDB.getFirstName(userID);
            
            // Set session attributes to remember logged in
            session.setAttribute("userID", userID);
            session.setAttribute("firstName", firstName);
            
            return;
        }
        
        // User wants list of their classes
        if (command.equals("getUserClasses")) {
            
            // Default string to avoid crash
            String classData = "{\"num\":0}";
            // If we are signed in
            if (session.getAttribute("userID") != null) {
                // Ask the DB for a list
                DBCommunicator myDB = new DBCommunicator();
                myDB.connect();
                classData = myDB.getClasses((int)session.getAttribute("userID"));
            }
            
            // Pass the list to the jsp
            out.println(classData);
            
            return;
        }
        
        // User wants to search for their class
        if (command.equals("searchClasses")) {

            // Get search parameter from jsp
            String searchText = request.getParameter("searchText");
            
           
            // Default userID to -1
            int userID = -1;
            
            // If user is signed in
            if (session.getAttribute("userID") != null)
                userID = (int)session.getAttribute("userID");
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            // Ask DB to search for the classes
            String classData = myDB.searchClasses(searchText, userID);
            // If we have no data, set a default value
            if (classData.length() == 0)
                classData = "{\"num\":0}";
                    
            // Pass Data back to jsp
            out.println(classData);
            
            return;
        }
        
        // User wants to get a specific class
        if (command.equals("getClassByID")) {
            
            // Get param from jsp
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            String classData = myDB.getClassByID(classID);
            
            // Check data is good
            if (classData.length() == 0)
                classData = "{\"num\":0}";
                
            // Pass data to jsp
            out.println(classData);
            
            return;
        }
        
        // User wants to add class
        if (command.equals("addClass")) {
            
            // Get param from jsp
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            String reply = "";
            if (session.getAttribute("userID") != null)
                reply = myDB.addClass((int)session.getAttribute("userID"), classID);
                
            out.println(reply);
            
            return;
        }
        
        // User wants to check if they are enrolled in class
        if (command.equals("checkClass")) {
            
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            String reply = "";
            if (session.getAttribute("userID") != null)
                reply = myDB.checkClass((int)session.getAttribute("userID"), classID);
                
            
            out.println(reply);
            
            return;
        }
        
        // User wants class code
        if (command.equals("getClassCode")) {
            
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            String reply = "";
            if (session.getAttribute("userID") != null)
                reply = myDB.getClassCode(classID);
                
                
            out.println(reply);
            
            return;
        }
        
        // User making new post
        if (command.equals("newPost")) {
            
            if (session.getAttribute("userID") == null) {
                out.println("Please log in to post");
                return;
            }
            
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String type = request.getParameter("type");
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            if (title.length() == 0) {
                out.println("Please enter a title");
                return;
            }
            if (description.length() == 0) {
                out.println("Please enter a description");
                return;
            }
            if (type.length() == 0) {
                out.println("Please select a post type");
                return;
            }
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int typeID = 1;
            if (type.equals("Exam"))
                typeID = 0;
            if (type.equals("Other"))
            	typeID = 2;
                
            String reply = myDB.newPost((int)session.getAttribute("userID"), classID, typeID, title, description);
            
            out.println(reply);
            
            return;
            
        }
        
        // User wants list of assignments
        if (command.equals("getAssignments")) {
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            String classData = "{\"num\":0}";
            classData = myDB.getPosts(classID,1);
            
            out.println(classData);
            
            return;
        }
        
     // User wants list of other
        if (command.equals("getOther")) {
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            String classData = "{\"num\":0}";
            classData = myDB.getPosts(classID,2);
            
            out.println(classData);
            
            return;
        }
        
        // User wants list of exams
        if (command.equals("getExams")) {

            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int classID = Integer.parseInt(request.getParameter("classID"));
            
            String classData = "{\"num\":0}";
            classData = myDB.getPosts(classID,0);
            
            out.println(classData);
            
            return;
        }
        
        // User wants specific post
        if (command.equals("getPost")) {
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int postID = Integer.parseInt(request.getParameter("postID"));
            
            String postData = "{\"num\":0}";
            postData = myDB.getPostByID(postID);
            
            out.println(postData);
            
            return;
        }
        
        // User asking question
        if (command.equals("newQuestion")) {
            
            if (session.getAttribute("firstName") == null) {
                out.println("Please log in to post");
                return;
            }
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            String text = request.getParameter("text");
            
            if (text.length() == 0) {
                out.println("Please enter text");
                return;
            }
            
            int postID = Integer.parseInt(request.getParameter("postID"));
            
            String postData = myDB.newQuestion(postID, text, (String)session.getAttribute("firstName"));
            
            out.println(postData);
            
            return;
        }
        
        // User answering question
        if (command.equals("newAnswer")) {
            
            if (session.getAttribute("firstName") == null) {
                out.println("Please log in to answer");
                return;
            }
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            String text = request.getParameter("text");
            
            if (text.length() == 0) {
                out.println("Please enter text");
                return;
            }
            
            int questionID = Integer.parseInt(request.getParameter("questionID"));
            
            String postData = myDB.newAnswer(questionID, text, (String)session.getAttribute("firstName"));
            
            out.println(postData);
            
            return;
        }
        
        // User upvoting question
        if (command.equals("upvote")) {
            
            if (session.getAttribute("userID") == null) {
                out.println("Please log in to upvote");
                return;
            }
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int questionID = Integer.parseInt(request.getParameter("questionID"));
            
            
            String error = myDB.upvoteQuestion(questionID, (int)session.getAttribute("userID"));
            
            out.println(error);
            
            return;
        }
        
        // User downvote question
        if (command.equals("downvote")) {
            
            if (session.getAttribute("userID") == null) {
                out.println("Please log in to downvote");
                return;
            }
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int questionID = Integer.parseInt(request.getParameter("questionID"));
            
            String error = myDB.downvoteQuestion(questionID, (int)session.getAttribute("userID"));
            
            out.println(error);
            
            return;
        }
        
        // Check upvote status
        if (command.equals("checkUpvote")) {
            
            if (session.getAttribute("userID") == null) {
                out.println("Please log in");
                return;
            }
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int questionID = Integer.parseInt(request.getParameter("questionID"));
            
            String msg = myDB.checkUpvoted(questionID, (int)session.getAttribute("userID"));
            
            out.println(msg);
            
            return;
        }
        
        if (command.equals("getQuestionByID")) {
            
            // Now check with DB
            DBCommunicator myDB = new DBCommunicator();
            myDB.connect();
            
            int questionID = Integer.parseInt(request.getParameter("qid"));
            String msg = "{\"num\":0}"; 
            msg = myDB.getAnswerByQuestionID(questionID);
            
            out.println(msg);
            
            return;
        }
    }
    
    
    private Object Integer(int i) {
        // TODO Auto-generated method stub
        return null;
    }
    
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OneServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }
    
}

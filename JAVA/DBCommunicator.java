package Stadplatz;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBCommunicator {

    public Connection conn = null;
    public Statement st = null;
    public PreparedStatement ps = null;
    public ResultSet rs = null;


    // Function to connect to DB
    public void connect() {
        //System.out.println ("Trying to connect");
        try {
            // String url = "jdbc:mysql://google/Stadtplatz?cloudSqlInstance=lab7-255416:us-central1:sql-db-1&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false&user=sjburton&password=wow";
            String url = "jdbc:mysql://google/Stadtplatz?cloudSqlInstance=stadtzplatz:us-west1:sql-db-1&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false&user=grujic&password=wow";
            conn = DriverManager.getConnection(url);
        } catch (SQLException sqle) {
            //System.out.println ("Code failed connect");
            //System.out.println ("SQLException: " + sqle.getMessage());
        }
    }

    // Function to disconnect from DB
    public void disconnect() {
        //System.out.println ("Trying to disconnect");
        //        try {
        //            if (rs != null) {
        //                rs.close();
        //            }
        //            if (st != null) {
        //                st.close();
        //            }
        //            if (ps != null) {
        //                ps.close();
        //            }
        //            if (conn != null) {
        //                conn.close();
        //            }
        //        } catch (SQLException sqle) {
        //System.out.println ("Code failed disconnect");
        //            //System.out.println("sqle: " + sqle.getMessage());
        //        }
    }


    // Function to login
    public int tryLogin(String username, String password) {
        //System.out.println ("Trying login");
        try {

            // Check if user exists
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM User WHERE username=?");
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (!rs.next()) {    // No user found
                return -1;
            }


            //System.out.println(password);

            // Check if username and password match
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM User WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (!rs.next()) {    // Password doesn't match
                return -2;
            }
            else {
                // If successful, return userID
                //System.out.println("found user");
                int userID = rs.getInt("userID");
                return userID;
            }

        } catch (SQLException sqle) {
            //System.out.println ("Code failed login");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished login");
        return -3;
    }

    public String getClasses(int userID) {
        //System.out.println ("Trying getClasses");
        try {
            // Ask database for classes with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Class c, Enrollment e WHERE c.classID=e.classID AND e.userID = ?"); //SELECT * FROM Enrollment WHERE userID=?

            //SELECT * FROM Class c, Enrollment e WHERE c.classID=e.classID AND  e.userID = ?

            ps.setInt(1, userID);
            rs = ps.executeQuery();
            //System.out.println("Get classes worked");


            /*String JSONResult = "";
             int classCount = 0;
             if (rs.next()) {
             int classID = rs.getInt("classID");
             JSONResult += classID;
             classCount++;
             }
             while (rs.next()) {
             int classID = rs.getInt("classID");
             JSONResult += ", " + classID;
             classCount++;
             }
             JSONResult = "{\"num\":" + classCount + ", \"classes\": [" + JSONResult + "]}";
             return JSONResult;*/

            String JSONResult = "[";
            int classCount = 0;
            if (rs.next()) {
                int classID = rs.getInt("classID");
                String className = rs.getString("name");
                String classDescription = rs.getString("description");
                String classCode = rs.getString("code");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{ \"id\": " + classID +
                ", \"code\": \"" + classCode.replace('\"','\'') +
                "\", \"name\": \"" + className.replace('\"','\'') +
                "\", \"description\": \"" + classDescription.replace('\"','\'')+
                "\"}";
                classCount++;
            }

            while (rs.next()) {
                int classID = rs.getInt("classID");
                String className = rs.getString("name");
                String classDescription = rs.getString("description");
                String classCode = rs.getString("code");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                ",{ \"id\": " + classID +
                ", \"code\": \"" + classCode.replace('\"','\'') +
                "\", \"name\": \"" + className.replace('\"','\'') +
                "\", \"description\": \"" + classDescription.replace('\"','\'')+
                "\" }";
                classCount++;
            }


            JSONResult = "{\"num\":" + classCount + ", \"classes\": " + JSONResult + "]}";

            return JSONResult;


        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }

    public String searchClasses(String searchText, int userID) {
        searchText = "%" + searchText + "%";
        //System.out.println ("Trying searchClasses: " + searchText);
        try {
            // Ask database for classes with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Class WHERE code LIKE ? ORDER BY code");
            ps.setString(1,searchText);

            //System.out.println ("Now about to search");
            rs = ps.executeQuery();
            //System.out.println ("Now searching");
            String JSONResult = "[";
            int classCount = 0;
            if (rs.next()) {
                int classID = rs.getInt("classID");
                String className = rs.getString("name");
                String classDescription = rs.getString("description");
                String classCode = rs.getString("code");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{ \"id\": " + classID +
                ", \"code\": \"" + classCode.replace('\"','\'') +
                "\", \"name\": \"" + className.replace('\"','\'') +
                "\", \"description\": \"" + classDescription.replace('\"','\'')+
                "\"}";
                classCount++;
            }

            while (rs.next()) {
                int classID = rs.getInt("classID");
                String className = rs.getString("name");
                String classDescription = rs.getString("description");
                String classCode = rs.getString("code");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                ",{ \"id\": " + classID +
                ", \"code\": \"" + classCode.replace('\"','\'') +
                "\", \"name\": \"" + className.replace('\"','\'') +
                "\", \"description\": \"" + classDescription.replace('\"','\'')+
                "\" }";
                classCount++;
            }


            JSONResult = "{\"num\":" + classCount + ", \"classes\": " + JSONResult + "], \"enrollment\":";//}

            if (userID >= 0) {
                String myClasses = getClasses(userID);
                JSONResult = JSONResult + myClasses;
            }
            else {
                JSONResult = JSONResult + "[]";
            }

            JSONResult = JSONResult + "}";

            return JSONResult;
        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }


    public String getClassByID(int classID) {

        //System.out.println ("Trying get class by id: " + classID);
        try {
            // Ask database for classes with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Class WHERE classID = ?");
            ps.setInt(1,classID);

            //System.out.println ("Now about to search");
            rs = ps.executeQuery();
            //System.out.println ("Now searching");
            String JSONResult = "[";
            int classCount = 0;
            if (rs.next()) {
                int gottenClassID = rs.getInt("classID");
                String className = rs.getString("name");
                String classDescription = rs.getString("description");
                String classCode = rs.getString("code");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{ \"id\": " + gottenClassID +
                ", \"code\": \"" + classCode.replace('\"','\'') +
                "\", \"name\": \"" + className.replace('\"','\'') +
                "\", \"description\": \"" + classDescription.replace('\"','\'')+
                "\"}";
                classCount++;
            }


            JSONResult = "{\"num\":" + classCount + ", \"classes\": " + JSONResult + "]}";
            return JSONResult;
        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }

    // Function to get username
    public String getUsername(int userID) {
        //System.out.println ("Trying getUsername");
        try {
            // Ask database for user with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM User WHERE userID=?");
            ps.setInt(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) {
                // If we find one, return the username
                //System.out.println("found user");
                String username = rs.getString("username");
                return username;
            }

        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }

    // Function to get firstname
    public String getFirstName(int userID) {
        //System.out.println ("Trying getFirstName");
        try {
            // Ask database for user with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM User WHERE userID=?");
            ps.setInt(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) {
                // If we find one, return the username
                //System.out.println("found user");
                String username = rs.getString("firstName");
                return username;
            }

        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get firstname");
        return "";
    }



    // Function to register a new user
    public String tryRegister(String username, String password, String fName, String lName) {
        //System.out.println ("Trying register");
        try {

            // Check if user already exists
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM User WHERE username=?");
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {    // User already exists
                return "Username already taken";
            }

            // If not already made, insert into DB
            ps = conn.prepareStatement("INSERT INTO User (username, password, firstName, lastName) VALUES (?,?,?,?)");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, fName);
            ps.setString(4, lName);
            //System.out.println ("Executing update");
            int row = ps.executeUpdate();
            return "";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed login");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished Increment");
        return "Yikes, that's not good";
    }


    // Function to add/remove class to enrollment
    public String addClass(int userID, int classID) {

        //    //System.out.println ("Trying add class");
        try {
            int removeID = -1;
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Enrollment WHERE userID=? AND classID=?");
            ps.setInt(1, userID);
            ps.setInt(2, classID);
            rs = ps.executeQuery();
            if (rs.next()) {
                // If it is, save it's id
                removeID = rs.getInt("enrollmentID");
            }

            //System.out.println (removeID);

            // If class is enrolled already, delete it
            if (removeID != -1) {
                //System.out.println("Unenrolling class");
                ps = conn.prepareStatement("DELETE FROM Enrollment WHERE enrollmentID=?");
                ps.setInt(1, removeID);
                //System.out.println ("Executing update");
                int row = ps.executeUpdate();
                //System.out.println ("Done update");
                return "";
            }


            ps = conn.prepareStatement("INSERT INTO Enrollment (classID, userID) VALUES (?,?)");
            ps.setInt(1, classID);
            ps.setInt(2, userID);
            //System.out.println ("Executing update");
            int row = ps.executeUpdate();
            //System.out.println ("Done update");
            return "Added";

        } catch (SQLException sqle) {

            //System.out.println("sqle: " + sqle.getMessage());
        }




        return "";
    }

    public String getClassCode(int classID) {

        //    //System.out.println ("Trying add class");
        try {

            int removeID = -1;
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Class WHERE classID=?");
            ps.setInt(1, classID);
            rs = ps.executeQuery();
            //System.out.println("get class code"+classID);
            if (rs.next()) {
                // If it is, save it's id
                //System.out.println("now get class code");
                String code = rs.getString("code");
                //System.out.println(code);
                return code;
            }


        } catch (SQLException sqle) {

            //System.out.println("sqle: " + sqle.getMessage());
        }




        return "";
    }

    // Function to add/remove class to enrollment
    public String checkClass(int userID, int classID) {

        //    //System.out.println ("Trying add class");
        try {

            int removeID = -1;
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Enrollment WHERE userID=? AND classID=?");
            ps.setInt(1, userID);
            ps.setInt(2, classID);
            rs = ps.executeQuery();
            if (rs.next()) {
                // If it is, save it's id
                return "Enrolled";
            }


        } catch (SQLException sqle) {

            //System.out.println("sqle: " + sqle.getMessage());
        }




        return "";
    }

    public String newPost(int userID, int classID, int tagID, String titleText, String postText) {

        //System.out.println ("Trying newPost");
        try {
            // If not already made, insert into DB
            ps = conn.prepareStatement("INSERT INTO Post (classID, userID, tagID, titleText, postText) VALUES (?,?,?,?,?)");
            ps.setInt(1, classID);
            ps.setInt(2, userID);
            ps.setInt(3, tagID);
            ps.setString(4, titleText);
            ps.setString(5, postText);
            //System.out.println ("Executing update");
            int row = ps.executeUpdate();
            return "";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed newPost");
            //System.out.println("sqle: " + sqle.getMessage());
        }


        return "Yikes, thats not good";
    }


    public String getPosts(int classID, int tagID) {
        //System.out.println ("Trying get posts");
        try {
            // Ask database for classes with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Post WHERE classID=? AND tagID=? ORDER BY postID DESC");
            ps.setInt(1,classID);
            ps.setInt(2,tagID);

            //System.out.println ("Now about to search");
            rs = ps.executeQuery();
            //System.out.println ("Now searching");
            String JSONResult = "[";
            int classCount = 0;
            if (rs.next()) {
                String postTitle = rs.getString("titleText");
                int postID = rs.getInt("postID");
                String postDescription = rs.getString("postText");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{\"title\": \"" + postTitle.replace('\"','\'') +
                "\", \"description\": \"" + postDescription.replace('\"','\'')+
                "\", \"id\": " + postID+
                "}";
                classCount++;
            }


            while (rs.next()) {
                String postTitle = rs.getString("titleText");
                int postID = rs.getInt("postID");
                String postDescription = rs.getString("postText");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                ",{\"title\": \"" + postTitle.replace('\"','\'') +
                "\", \"description\": \"" + postDescription.replace('\"','\'')+
                "\", \"id\": " + postID+
                "}";
                classCount++;
            }


            JSONResult = "{\"num\":" + classCount + ", \"classes\": " + JSONResult + "]";//}

            JSONResult = JSONResult + "}";

            return JSONResult;
        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }

    public String getAnswerByQuestionID(int questionID) {

        //System.out.println ("Trying get question by post id");
        try {
            // Ask database for classes with userID

            Connection conn2 = null;
            Statement st2 = null;
            PreparedStatement ps2 = null;
            ResultSet rs2 = null;

            try {
                // String url = "jdbc:mysql://google/Stadtplatz?cloudSqlInstance=lab7-255416:us-central1:sql-db-1&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false&user=sjburton&password=wow";
                String url = "jdbc:mysql://google/Stadtplatz?cloudSqlInstance=stadtzplatz:us-west1:sql-db-1&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false&user=grujic&password=wow";
                conn2 = DriverManager.getConnection(url);
            } catch (SQLException sqle) {
                //System.out.println ("Code failed connect");
                //System.out.println ("SQLException: " + sqle.getMessage());
            }

            st2 = conn2.createStatement();
            ps2 = conn2.prepareStatement("SELECT * FROM Response WHERE questionID=? ORDER BY responseID DESC");
            ps2.setInt(1,questionID);

            //System.out.println ("Now about to search");
            rs2 = ps2.executeQuery();
            //System.out.println ("Now searching");
            String JSONResult = "[";
            int classCount = 0;
            if (rs2.next()) {
                String responseText = rs2.getString("responseText");
                String userName = rs2.getString("userName");
                int id = rs2.getInt("responseID");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{\"text\": \"" + responseText.replace('\"','\'') +
                "\",\"userName\": \"" + userName.replace('\"','\'') +
                "\",\"id\": " + id+
                "}";
                classCount++;
            }

            while (rs2.next()) {
                String responseText = rs2.getString("responseText");
                String userName = rs2.getString("userName");
                int id = rs2.getInt("responseID");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                ",{\"text\": \"" + responseText.replace('\"','\'') +
                "\",\"userName\": \"" + userName.replace('\"','\'') +
                "\",\"id\": " + id+
                "}";
                classCount++;
            }


            JSONResult = "{\"num\":" + classCount + ", \"answers\": " + JSONResult+"]";//}

            JSONResult = JSONResult + "}";

            return JSONResult;
        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }

    public String getQuestionByPostID(int postID) {

        //System.out.println ("Trying get question by post id");
        try {
            // Ask database for classes with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Question WHERE postID=? ORDER BY numUpvotes DESC, questionID DESC");
            ps.setInt(1,postID);

            //System.out.println ("Now about to search");
            rs = ps.executeQuery();
            //System.out.println ("Now searching");
            String JSONResult = "[";
            int classCount = 0;
            if (rs.next()) {
                String questionText = rs.getString("questionText");
                String userName = rs.getString("userName");
                int questionUpvotes = rs.getInt("numUpvotes");
                int id = rs.getInt("questionID");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{\"text\": \"" + questionText.replace('\"','\'') +
                "\",\"userName\": \"" + userName.replace('\"','\'') +
                "\", \"upvotes\": " + questionUpvotes+
                ", \"id\": " + id+
                ",\"answers\":" + getAnswerByQuestionID(id) + "}";
                classCount++;
            }
            while (rs.next()) {
                String questionText = rs.getString("questionText");
                String userName = rs.getString("userName");
                int questionUpvotes = rs.getInt("numUpvotes");
                int id = rs.getInt("questionID");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                ",{\"text\": \"" + questionText.replace('\"','\'') +
                "\",\"userName\": \"" + userName.replace('\"','\'') +
                "\", \"upvotes\": " + questionUpvotes+
                ", \"id\": " + id+
                ",\"answers\":" + getAnswerByQuestionID(id) + "}";
                classCount++;
            }


            JSONResult = "{\"num\":" + classCount + ", \"questions\": " + JSONResult+"]";//}

            JSONResult = JSONResult + "}";

            return JSONResult;
        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }

        //System.out.println ("Finished get username");
        return "";
    }

    public String getPostByID(int postID) {
        //System.out.println ("Trying get post by id");
        try {
            // Ask database for classes with userID
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Post WHERE postID=?");
            ps.setInt(1,postID);

            //System.out.println ("Now about to search");
            rs = ps.executeQuery();
            //System.out.println ("Now searching");
            String JSONResult = "[";
            int classCount = 0;
            if (rs.next()) {
                String postTitle = rs.getString("titleText");
                String postDescription = rs.getString("postText");
                //System.out.println ("Found class: " + classCode);
                JSONResult +=
                "{\"title\": \"" + postTitle.replace('\"','\'') +
                "\", \"description\": \"" + postDescription.replace('\"','\'')+
                "\", \"id\": " + postID+
                "}";
                classCount++;
            }

            JSONResult = "{\"num\":" + classCount + ", \"classes\": " + JSONResult + "]";//}

            JSONResult = JSONResult + ", \"questions\": " + getQuestionByPostID(postID) + "}";

            return JSONResult;
        } catch (SQLException sqle) {
            //System.out.println ("Code failed getUsername");
            //System.out.println("sqle: " + sqle.getMessage());
        }
        //System.out.println ("Finished get username");
        return "";
    }


    public String newQuestion(int postID, String text, String userName) {
        //System.out.println ("Trying newQuestion");
        try {
            // If not already made, insert into DB
            ps = conn.prepareStatement("INSERT INTO Question (postID, questionText, numUpvotes, userName) VALUES (?,?,0,?)");
            ps.setInt(1, postID);
            ps.setString(2, text);
            ps.setString(3, userName);
            //System.out.println ("Executing update");
            int row = ps.executeUpdate();
            return "";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed newPost");
            //System.out.println("sqle: " + sqle.getMessage());
        }


        return "Yikes, thats not good";
    }

    public String newAnswer(int questionID, String text, String userName) {
        //System.out.println ("Trying newQuestion");
        try {
            // If not already made, insert into DB
            ps = conn.prepareStatement("INSERT INTO Response (questionID, responseText, userName) VALUES (?,?,?)");
            ps.setInt(1, questionID);
            ps.setString(2, text);
            ps.setString(3, userName);
            //System.out.println ("Executing update");
            int row = ps.executeUpdate();
            return "";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed newPost");
            //System.out.println("sqle: " + sqle.getMessage());
        }


        return "Yikes, thats not good";
    }

    public String checkUpvoted(int questionID, int userID) {

//      //System.out.println ("Trying check upvote");
        try {
            // Check if user upvoted post
            st = conn.createStatement();
            ps = conn.prepareStatement("SELECT * FROM Upvote WHERE userID=? AND questionID=?");
            ps.setInt(1, userID);
            ps.setInt(2, questionID);
            //System.out.println("Checking upvote");
            rs = ps.executeQuery();
            if (rs.next()) {
            	//System.out.println("Was upvoted");
                return "";
            }
           // System.out.println("Was not upvoted");
            return "Not upvoted";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed check upvote");
            //System.out.println("sqle: " + sqle.getMessage());
        }

    	return "";
    }

    public String upvoteQuestion(int questionID, int userID) {
        //System.out.println ("Trying upvote");
        try {
            // If not already made, insert into DB
            ps = conn.prepareStatement("INSERT INTO Upvote (questionID, userID) VALUES (?,?)");
            ps.setInt(1, questionID);
            ps.setInt(2, userID);
            //System.out.println ("Executing update");
            int row = ps.executeUpdate();

            //System.out.println ("Updating numUpvotes +1");
			ps = conn.prepareStatement("UPDATE Question SET numUpvotes = numUpvotes + 1 WHERE questionID=?");
			ps.setInt(1, questionID);
			row = ps.executeUpdate();
			//System.out.println ("Done update +1 numUpdates");

            return "";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed upvote");
            //System.out.println("sqle: " + sqle.getMessage());
        }


        return "Yikes, thats not good";
    }

    public String downvoteQuestion(int questionID, int userID) {
        //System.out.println ("Trying down");
        try {
            // If not already made, insert into DB
            ps = conn.prepareStatement("DELETE FROM Upvote WHERE questionID=? AND userID=?");
            ps.setInt(1, questionID);
            ps.setInt(2, userID);
            //System.out.println ("Executing update -1");
            int row = ps.executeUpdate();


            //System.out.println ("Updating numUpvotes -1");
			ps = conn.prepareStatement("UPDATE Question SET numUpvotes = numUpvotes - 1 WHERE questionID=?");
			ps.setInt(1, questionID);
			row = ps.executeUpdate();
			//System.out.println ("Done update -1 numUpdates");

            return "";

        } catch (SQLException sqle) {
            //System.out.println ("Code failed upvote");
            //System.out.println("sqle: " + sqle.getMessage());
        }


        return "Yikes, thats not good";
    }

    // Main function -- not used
    public static void main (String[] args) {

    }
}

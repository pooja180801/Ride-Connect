<%@include file="structure.jsp"%>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    // Extract the access_token and id_token from session attribute
        String accessToken = (String) request.getSession().getAttribute("access_token");
        String idToken = (String) request.getSession().getAttribute("id_token");

    // Check if the access token is not null or empty
    if (accessToken != null && !accessToken.isEmpty()) {
        // Define userinfo endpoint
        // Read properties from the authorization.properties file
Properties props = new Properties();
InputStream input = getServletContext().getResourceAsStream("/WEB-INF/authorization.properties");
props.load(input);

String userinfoEndpoint = props.getProperty("oauth.userinfo_endpoint");
String introspectionEndpoint = props.getProperty("oauth.introspection_endpoint");


        try {
            // Create a URL object for the userinfo endpoint
            URL userinfoUrl = new URL(userinfoEndpoint);

            // Open a connection to the userinfo endpoint
            HttpURLConnection userinfoConnection = (HttpURLConnection) userinfoUrl.openConnection();

            // Set the request method to GET
            userinfoConnection.setRequestMethod("GET");

            // Set the Authorization header with the access token
            userinfoConnection.setRequestProperty("Authorization", "Bearer " + accessToken);

            // Get the response code from the userinfo endpoint
            int userinfoResponseCode = userinfoConnection.getResponseCode();

            // Read the response data from the userinfo endpoint
            try (BufferedReader userinfoReader = new BufferedReader(new InputStreamReader(userinfoConnection.getInputStream()))) {
                String userinfoInputLine;
                StringBuilder userinfoResponse = new StringBuilder();

                while ((userinfoInputLine = userinfoReader.readLine()) != null) {
                    userinfoResponse.append(userinfoInputLine);
                }

                // Parse the userinfo response data as JSON
                JSONObject userinfoJson = new JSONObject(userinfoResponse.toString());

                // Extract user information
                String username = userinfoJson.optString("username");
                String name = userinfoJson.optString("given_name");
                String email = userinfoJson.optString("email");
                
                String contactNumber = userinfoJson.optString("phone_number");
                String lastname = userinfoJson.optString("family_name");
                JSONObject addressObject = userinfoJson.optJSONObject("address");

                // Extract the "country" property from the "address" object
                String country = (addressObject != null) ? addressObject.optString("country") : "";
                
                session.setAttribute("username", username);
%>
<!doctype>
<html>
<head>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        margin: 0;
        padding: 0;
    }

    h3 {
        color: #007BFF;
        text-align: center;
    }

    .profile-info {
        max-width: 400px;
        margin: 0 auto;
        background-color: #fff;
        padding: 20px;
         margin: 50px auto; 
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        text-align: center;
    }

    .text-capitalize {
        text-transform: capitalize;
        font-weight: bold;
        font-size: 18px;
    }

    .mb-0 {
        margin-bottom: 10px;
    }

    h4 {
        font-size: 16px;
        color: #333;
    }
     .info-pair {
        margin: 10px 0;
    }

    .info-label {
        text-transform: uppercase;
        font-weight: bold;
        font-size: 16px;
        color: #007BFF;
    }

    .info-value {
        font-size: 16px;
        color: #333;
    }
</style>

</head>
<body>
<div class="profile-info">
    <h2>Profile</h2>

    <div class="info-pair">
        <p class="info-label">USERNAME</p>
        <h4 class="info-value"><%= username %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">NAME</p>
        <h4 class="info-value"><%= name %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">EMAIL</p>
        <h4 class="info-value"><%= email %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">CONTACT NO</p>
        <h4 class="info-value"><%= contactNumber %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">COUNTRY</p>
        <h4 class="info-value"><%= country %></h4>
    </div>
</div>
			
</body>
</html>


				

    

<%
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    } else {
        // Handle the case where the access token is not present
         response.sendRedirect("index.jsp");
    }
%>
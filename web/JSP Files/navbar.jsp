<%@page import="app.classes.User"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskPilot Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .profile-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
        }
        .nav-icon span {
            margin-right: 10px;
        }
        .nav-icon img {
            margin-right: 10px;
        }
    </style>
</head>
<body>
<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null) {
        response.sendRedirect("../index.html");
        return;
    }
    User user = (User) session.getAttribute("loggedInUser");
    
%>
<!-- Navbar -->
<nav class="navbar navbar-expand px-4 px-3" style="background-color:#2C456B">
    <h2>TaskPilot Management System</h2>
    <div class="navbar-collapse collapse">
        <ul class="navbar-nav ms-auto">
            <li class="nav-item dropdown">
                <a href="#" class="nav-icon pe-md-0 d-flex align-items-center" data-bs-toggle="dropdown">
                    <span class="me-3" style="color:white"><%= user.getFirstName() %> <%= user.getLastName() %></span>
                    <img src="<%= user.getProfile_picture() %>" class="avatar img-fluid profile-img me-3" alt="Profile Image" id="navbarProfileImg">
                    <i class="lni lni-cog me-3" style="color:white"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-end rounded view_profile">
                    <a href="#" class="dropdown-item" id="viewAccountLink">
                        <i class="lni lni-cog"></i>
                        <span>View Account</span>
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="logout.jsp" class="dropdown-item">
                        <i class="lni lni-exit"></i>
                        <span>Log Out</span>
                    </a>
                </div>
            </li>
        </ul>
    </div>
</nav>

<!-- View Account Modal -->
<!-- View Account Modal -->
<div class="modal fade" id="viewAccountModal" tabindex="-1" aria-labelledby="viewAccountModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewAccountModalLabel">View Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label for="firstName" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="firstName" placeholder="First Name" value="<%= user.getFirstName() %>" disabled>
                    </div>
                    <div class="mb-3">
                        <label for="lastName" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="lastName" placeholder="Last Name" value="<%= user.getLastName() %>" disabled>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" placeholder="Email" value="<%= user.getEmail() %>" disabled>
                    </div>
                    
                    <div class="mb-3 text-center">
                        <img src="<%= user.getProfile_picture() %>" class="avatar img-fluid profile-img" alt="User Profile Icon" id="modalProfileImg">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


<!-- Bootstrap JS -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('viewAccountLink').addEventListener('click', function() {
        var viewAccountModal = new bootstrap.Modal(document.getElementById('viewAccountModal'));
        viewAccountModal.show();
    });

    document.getElementById('profilePic').addEventListener('change', function(event) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var profileImg = document.getElementById('modalProfileImg');
            profileImg.src = e.target.result;

    
            var navbarProfileImg = document.getElementById('navbarProfileImg');
            navbarProfileImg.src = e.target.result;
        }
        reader.readAsDataURL(event.target.files[0]);
    });
</script>
</body>
</html>

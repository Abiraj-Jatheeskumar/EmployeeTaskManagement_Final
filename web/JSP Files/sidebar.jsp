<%-- 
    Document   : sidebar_01
    Created on : Jul 15, 2024, 9:23:22 PM
    Author     : TAKESHI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.lineicons.com/3.0/lineicons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
            ::after,
            ::before {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            .content{
                width:100%;
                position:relative;
                box-sizing: border-box; 
            }
            
            .container:not(.text-center):not(.navbar), .container-fluid{
                padding:3%;
                padding-bottom:20%;
                margin:0px;
            }
            

            a {
                text-decoration: none;
            }

            li {
                list-style: none;
            }

            body {
                font-family: 'Poppins', sans-serif;
                
                display: flex;
                flex-direction: column;
            }

            .wrapper{
                display:flex;
                height: 100%;
                flex: 1;
                min-height:100vh;
            }

            
            #sidebar{
                width:70px;
                min-width:70px;
                z-index:1000;
                transition:all .25s ease-in-out;
                background-color:#0c380c;
                display:flex;
                flex-direction:column;
                text-decoration: none;
            }
            #sidebar.expand{
                width:260px;
                min-width:260px;
            }
            #toggle-btn{
                background-color:transparent;
                cursor:pointer;
                border:0;
                padding:1rem 1.5rem;

            }
            
            #toggle-btn i{
                font-size:1.5rem;
                color:#fff;

            }

            .sidebar-logo{
                margin:auto 0;
            }
            .profile-img{
                border-radius:50%;
            }
            .sidebar-logo a{
                color:#fff;
                font-size:1.15rem;
                font-weight:600;
            }

            #sidebar:not(.expand) .sidebar-logo,
            #sidebar:not(.expand) a.sidebar-link span {
                display:none;
            }

            #sidebar.expand .sidebar-logo,
            #sidebar.expand a.sidebar-link span, li span{
                animation:fadeIn .25s ease;
            }

            @keyframes fadeIn{
                0%{
                    opacity:0;
                }
                100%{
                    opacity:1;
                }
            }

            .sidebar-nav{
                padding:2rem 0;
                flex:1 1 auto;
            }

            a.sidebar-link{
                padding: .625rem 1.625rem;
                color:#fff;
                display:block;
                font-size:0.9rem;
                white-space:nowrap;
                border-left:3px solid transparent;
            }

            .sidebar-link i,.dropdon-item i {
                font-size:1.1rem;
                margin-right:.75rem;

            }
            a.sidebar-link:hover{
                background-color:rgba(255,255,255,.075);
                border-left:3px solid #3b7ddd;
                text-decoration: none;
            }
            .sidebar-item{
                position:relative;
            }

            #sidebar:not(.expand) .sidebar-item .sidebar-dropdown {
                position: absolute;
                top: 0;
                left: 70px;
                background-color: #0e2238;
                padding: 0;
                min-width: 15rem;
                display: none;
            }

            #sidebar:not(.expand) .sidebar-item:hover .has-dropdown+.sidebar-dropdown {
                display: block;
                max-height: 15em;
                width: 100%;
                opacity: 1;
            }

            #sidebar.expand .sidebar-link[data-bs-toggle="collapse"]::after {
                border: solid;
                border-width: 0 .075rem .075rem 0;
                content: "";
                display: inline-block;
                padding: 2px;
                position: absolute;
                right: 1.5rem;
                top: 1.4rem;
                transform: rotate(-135deg);
                transition: all .2s ease-out;
            }

            #sidebar.expand .sidebar-link[data-bs-toggle="collapse"].collapsed::after {
                transform: rotate(45deg);
                transition: all .2s ease-out;
            }
            .logo{
                max-height:50px;
                width:auto;
                min-height:40px;
                cursor:pointer;
            }
            h1{
                font-weight:900;
            }
            .sidebar-footer{
                margin-bottom:400px;
            }
            #sidebar{
                
                background: #343a40;
            }
            
            h1{
                font-weight:900;
            }

            .navbar {
                background-color: #0066FF;
                box-shadow: 0 0 2rem 0 rgba(33, 37, 41, .1);
                color:white;
            }
            

            .navbar-expand .navbar-collapse {
                min-width: 200px;
            }

            .avatar {
                height: 40px;
                width: 40px;
            }
            .card{
                background:#f5f5f5;
                transform: .4s;
                cursor:pointer;
                color:#000;
                margin-bottom:1rem;
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
%>
        <div class='wrapper'>
            <aside id='sidebar' class="expand">
                <div class='d-flex'>
                    <button id='toggle-btn' type='button'>
                        <i class="lni lni-grid-alt"></i>
                    </button>
                    <div class='sidebar-logo'>
                        <a href='#'>Menu</a>
                    </div>
                </div>
                <ul class='sidebar-nav'>
                    <li class='sidebar-item'>
                        <a href='home.jsp' class='sidebar-link'>
                            <i class="fas fa-tachometer-alt"></i>
                            <span>DashBoard</span>
                        </a>
                    </li>
                    <%
                       if ("admin".equals(userRole)) {
                        
                    %>
                    <li class='sidebar-item'>
                        <a href='#' class='sidebar-link has-dropdown oollapsed' data-bs-toggle="collapse" data-bs-target="#auth" aria-expanded="false" aria-controls="auth">
                            <i class="fas fa-briefcase"></i>
                            <span>Projects</span>
                        </a>
                        <ul id='auth' class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                            <li class="sidebar-item">
                                <a href="addproject.jsp" class="sidebar-link" id="projectNew"><i class="fas fa-plus-circle"></i> Add New</a>
                            </li>
                            <li class="sidebar-item">
                                <a href="projectlist.jsp" class="sidebar-link" id="projectList"><i class="fas fa-list"></i> List</a>
                            </li>
                        </ul>
                    </li>
                    
                    <li class="sidebar-item">
                        <a href="#" class ="sidebar-link has-dropdown oollapsed" data-bs-toggle="collapse" data-bs-target="#multi" aria-expanded="false" aria-controls="multi">
                            <i class="fas fa-tasks"></i>
                            <span>Tasks</span>
                        </a>
                        <ul id="multi" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">

                            <li class="sidebar-item">
                                <a href="addtask.jsp" class="sidebar-link" id="taskNew"><i class="fas fa-plus-circle"></i>Add New</a>
                            </li>
                            
                            <li class="sidebar-item">
                                <a href="tasklist.jsp" class="sidebar-link" id="taskList"><i class="fas fa-list"></i> List</a>
                            </li>
                            
                        </ul>
                    </li>
                    
                    <li class="sidebar-item">
                        <a href="#" class ="sidebar-link has-dropdown oollapsed" data-bs-toggle="collapse" data-bs-target="#userly" aria-expanded="false" aria-controls="userly">
                            <i class="fas fa-users"></i> 
                            <span>Users</span>
                        </a>
                        <ul id="userly" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">

                            <li class="sidebar-item">
                                <a href="adduser.jsp" class="sidebar-link" id="userNew"><i class="fas fa-user-plus"></i> Add New</a>
                            </li>
                            <li class="sidebar-item">
                                <a href="userlist.jsp" class="sidebar-link" id="userList"><i class="fas fa-list"></i> List</a>
                            </li>
                        </ul>
                    </li>
                    <li class='sidebar-item'>
                        <a href='report.jsp' class='sidebar-link' id="reports">
                            <i class="fas fa-chart-line"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                    <%
                            
                        }
                        %>
                        
                        
                      <%
                       if ("manager".equals(userRole)) {
                        
                    %>
                   
                            <li class="sidebar-item">
                                <a href="projectlist.jsp" class="sidebar-link" id="projectList"><i class="fas fa-list"></i><span>Projects List</span></a>
                            </li>
                   
                    
                    <li class="sidebar-item">
                        <a href="#" class ="sidebar-link has-dropdown oollapsed" data-bs-toggle="collapse" data-bs-target="#multi" aria-expanded="false" aria-controls="multi">
                            <i class="fas fa-tasks"></i>
                            <span>Tasks</span>
                        </a>
                        <ul id="multi" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">

                            <li class="sidebar-item">
                                <a href="addtask.jsp" class="sidebar-link" id="taskNew"><i class="fas fa-plus-circle"></i>Add New</a>
                            </li>
                            
                            <li class="sidebar-item">
                                <a href="tasklist.jsp" class="sidebar-link" id="taskList"><i class="fas fa-list"></i> List</a>
                            </li>
                            
                        </ul>
                    </li>
                    
                    
                            <li class="sidebar-item">
                                <a href="userlist.jsp" class="sidebar-link" id="userList"><i class="fas fa-list"></i><span>User List</span></a>
                            </li>
                        
                    <li class='sidebar-item'>
                        <a href='report.jsp' class='sidebar-link' id="reports">
                            <i class="fas fa-chart-line"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                    <%
                            
                        }
                        %>  
                        
                        
                       <%
                       if ("employee".equals(userRole)) {
                        
                    %>
                    
                    
                    
                            
                            <li class="sidebar-item">
                                <a href="tasklist.jsp" class="sidebar-link" id="taskList"><i class="fas fa-list"></i><span>Task List</span></a>
                            </li>
                      
                    
                    
                            <li class="sidebar-item">
                                <a href="userlist.jsp" class="sidebar-link" id="userList"><i class="fas fa-list"></i><span>Users List</span></a>
                            </li>
                        
                    
                    <%
                            
                        }
                        %> 
                        
                        
                        
                    <li class='sidebar-item'>
                        <a href='profile.jsp' class='sidebar-link' id="profile">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                </ul>
                <div class="sidebar-footer">
                    <a href="logout.jsp" class="sidebar-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Log Out</span>
                    </a>
                </div>
            </aside>
            
              
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const hamBurger = document.querySelector("#toggle-btn");

                hamBurger.addEventListener("click", function () {
                    document.querySelector("#sidebar").classList.toggle("expand");
                });

                const sidebar = document.getElementById('sidebar');

                function adjustSidebarClass() {
                    if (window.innerWidth <= 768) {
                        sidebar.classList.remove('expand');
                    } else {
                        sidebar.classList.add('expand');
                    }
                }

                adjustSidebarClass();

                window.addEventListener('resize', adjustSidebarClass);
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>

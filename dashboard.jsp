<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Multywave Technologies</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; min-height: 100vh; display: flex; }

        .sidebar {
            width: 220px;
            background-color: #333;
            color: white;
            height: 100vh;
            padding-top: 20px;
            position: fixed;
        }

        .sidebar a {
            display: block;
            color: white;
            padding: 12px;
            text-decoration: none;
            cursor: pointer;
        }

        .sidebar a:hover { background-color: #575757; }

        .main {
            margin-left: 220px;
            padding: 20px;
            flex: 1;
            background-image: url('${pageContext.request.contextPath}/images/multywave.jpg');
            background-size: 100% 100%;
            background-repeat: no-repeat;
            background-position: center;
            background-attachment: fixed;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 100vh;
        }

        .main::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(255, 255, 255, 0.8);
            z-index: 0;
        }

        .main > * {
            position: relative;
            z-index: 1;
        }

        .content { flex-grow: 1; }

        footer {
            padding: 10px;
            text-align: center;
            background: #f0f0f0;
            font-size: 14px;
        }

        .sidebar-popup {
            position: fixed;
            top: 0;
            left: -360px;
            width: 350px;
            height: 100vh;
            background-color: #f8f8f8;
            box-shadow: 2px 0 5px rgba(0,0,0,0.2);
            padding: 20px;
            transition: left 0.3s ease;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-popup.active { left: 220px; }

        .panel-section { display: none; }
        .panel-section.active { display: block; }

        .tabs { display: flex; gap: 10px; margin-bottom: 15px; }
        .tabs button {
            padding: 6px 12px;
            cursor: pointer;
            border: 1px solid #ccc;
            background-color: #eee;
        }

        .tabs button.active {
            background-color: #333;
            color: white;
        }

        form input, form button {
            padding: 6px;
            margin: 5px 0;
            width: 100%;
        }

        .hidden { display: none; }

        .success-msg {
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h2 style="text-align: center;">Multywave Technologies</h2>
    <a onclick="openPanel('Departments')">Departments</a>
    <a onclick="openPanel('Designations')">Designations</a>
    <a onclick="openPanel('Employees')">Employees</a>
    <a onclick="openPanel('Users')">Users</a>
    <a onclick="openPanel('Roles')">User Roles</a>
    <a onclick="openPanel('Leaves')">Leaves</a>
    <a onclick="openPanel('Salaries')">Salaries</a>
</div>

<!-- Main Content -->
<div class="main">
    <div class="content">
        <h1>Welcome to Multywave Technologies</h1>
        <p>Security at your fingertips</p>
        <h3>About the Company</h3>
    </div>
    <footer>
        Address: Kavuri Hills, Madhapur, Hyderabad, India | Phone: +91-9876543210
    </footer>
</div>

<!-- Popup Panel -->
<div class="sidebar-popup" id="popupPanel">
    <h3 id="panelTitle">Title</h3>

    <div class="tabs">
        <button id="viewTab" class="active" onclick="switchTab('view')">View Data</button>
        <button id="addTab" onclick="switchTab('add')">Add Data</button>
    </div>

    <!-- Success Message -->
    <c:if test="${not empty message}">
        <div class="success-msg">${message}</div>
    </c:if>

    <!-- Department View -->
    <div id="Departments-view" class="panel-section active">
        <ul>
            <c:forEach var="d" items="${departments}">
                <li>${d.name}</li>
            </c:forEach>
        </ul>
    </div>

    <!-- Department Add -->
    <div id="Departments-add" class="panel-section">
        <form method="post" action="${pageContext.request.contextPath}/departments">
            <input type="text" name="name" placeholder="Department Name" required />
            <button type="submit">Add Department</button>
        </form>
    </div>

    <!-- Other Sections -->
    <c:forEach var="section" items="${['Designations','Employees','Users','Roles','Leaves','Salaries']}">
        <div id="${section}-view" class="panel-section">
            <ul>
                <c:forEach var="item" items="${pageScope[section.toLowerCase()]}">
                    <li>
                        <c:choose>
                            <c:when test="${section == 'Designations'}">${item.title}</c:when>
                            <c:when test="${section == 'Employees'}">${item.name}</c:when>
                            <c:when test="${section == 'Users'}">${item.username}</c:when>
                            <c:when test="${section == 'Roles'}">${item.name}</c:when>
                            <c:when test="${section == 'Leaves'}">${item.reason}</c:when>
                            <c:when test="${section == 'Salaries'}">${item.employeeName} - ₹${item.amount}</c:when>
                        </c:choose>
                    </li>
                </c:forEach>
            </ul>
        </div>
        <div id="${section}-add" class="panel-section">
            <p style="font-style: italic;">Add form for ${section} not implemented.</p>
        </div>
    </c:forEach>

    <button onclick="closePanel()">Close</button>
</div>

<!-- Script -->
<script>
    let currentSection = "";

    function openPanel(sectionId) {
        currentSection = sectionId;
        document.getElementById("panelTitle").innerText = sectionId;
        switchTab('view');
        document.getElementById("popupPanel").classList.add("active");
    }

    function closePanel() {
        document.getElementById("popupPanel").classList.remove("active");
    }

    function switchTab(mode) {
        document.getElementById("viewTab").classList.remove("active");
        document.getElementById("addTab").classList.remove("active");
        document.getElementById(mode + "Tab").classList.add("active");

        document.querySelectorAll('.panel-section').forEach(el => el.classList.remove('active'));

        const section = document.getElementById(`${currentSection}-${mode}`);
        if (section) section.classList.add('active');
    }
</script>
</body>
</html>

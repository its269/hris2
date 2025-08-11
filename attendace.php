<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

$conn = new mysqli("localhost", "root", "", "hris");

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "DB connection failed"]);
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $sql = "
        SELECT 
            a.EmployeeID,
            e.EmployeeName,
            a.Date,
            a.TimeIn,
            a.TimeOut,
            lr.LeaveType,
            lr.StartDate,
            lr.EndDate
        FROM Attendance a
        JOIN Employees e ON a.EmployeeID = e.EmployeeID
        LEFT JOIN LeaveRequests lr 
          ON a.EmployeeID = lr.EmployeeID 
          AND a.Date BETWEEN lr.StartDate AND lr.EndDate
        ORDER BY a.Date DESC
    ";

    $result = $conn->query($sql);

    $attendance = [];
    while ($row = $result->fetch_assoc()) {
        $attendance[] = $row;
    }

    echo json_encode($attendance);
}
$conn->close();

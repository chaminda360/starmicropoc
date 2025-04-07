<?php
/**
 * Starline Service Main Entry Point
 * 
 * This file handles all API requests for the Starline service,
 * including user management and core business logic.
 */

# Load environment variables
$host = getenv('MYSQL_HOST');
$db = getenv('MYSQL_STARLINE_DB');
$user = getenv('MYSQL_STARLINE_USER');
$pass = getenv('MYSQL_STARLINE_PASSWORD');
$charset = getenv('MYSQL_CHARSET');

# Construct Database DSN (Data Source Name)
$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,    // Throw exceptions on error
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,         // Return arrays
    PDO::ATTR_EMULATE_PREPARES   => false,                    // Use real prepared statements
];

# Establish database connection
try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

# Get clean request URI for routing
$requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

# Route: GET /starline/ or /starline
# Returns: Welcome message
if ($_SERVER['REQUEST_METHOD'] === 'GET' && ($requestUri === '/starline' || $requestUri === '/starline/')) {
    header('Content-Type: application/json');
    echo json_encode(['message' => 'Welcome to the Starline service!']);
    exit;
}

# Route: GET /starline/users
# Returns: List of all users
if ($_SERVER['REQUEST_METHOD'] === 'GET' && $requestUri === '/starline/users') {
    try {
        $stmt = $pdo->query('SELECT * FROM users');
        $users = $stmt->fetchAll();
        header('Content-Type: application/json');
        echo json_encode($users);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to fetch users: ' . $e->getMessage()]);
    }
    exit;
}

# Route: GET /starline/test.php
# Returns: PHP configuration information
if ($requestUri === '/starline/test.php') {
    phpinfo();
    exit;
}

# Default response for undefined routes
http_response_code(404);
echo json_encode(['error' => 'Endpoint not found']);
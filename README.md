# Starline Microservices Project

A microservices-based application consisting of two PHP services (Starline and Starline-Stock) with MySQL database backend, orchestrated using Docker and Nginx.

## Project Overview

The project implements two microservices:
- **Starline Service**: Handles user management and core business logic
- **Starline Stock Service**: Manages product inventory and stock transactions

## Technology Stack

- PHP 8.2 with FPM (FastCGI Process Manager)
- MySQL 5.7
- Nginx (Latest)
- Docker & Docker Compose

## Project Structure

```
.
├── docker-compose.yml          # Main Docker composition file
├── docker/
│   ├── mysql/
│   │   └── init.sql           # Database initialization
│   ├── ngnix/
│   │   └── conf.d/
│   │       └── starline-service.conf  # Nginx configuration
│   └── php/
│       └── Dockerfile         # PHP-FPM configuration
├── Starline/                  # Core service
│   ├── index.php             # Main application logic
│   └── test.php              # Health check endpoint
└── starline-stock/           # Stock management service
    ├── index.php             # Stock service logic
    └── test.php              # Health check endpoint
```

## Features

### Starline Service
- User management system
- RESTful API endpoints
- Database integration
- Endpoints:
  - `GET /starline/` - Welcome message
  - `GET /starline/users` - List all users
  - `GET /starline/test.php` - Service health check

### Starline Stock Service
- Product inventory management
- Stock transaction tracking
- RESTful API endpoints
- Endpoints:
  - `GET /starline-stock/` - Welcome message
  - `GET /starline-stock/products` - List all products
  - `GET /starline-stock/test.php` - Service health check

## Database Schema

### Starline Service Database (starline_service_db)
- **Users Table**
  - id (INT, PRIMARY KEY)
  - name (VARCHAR)
  - email (VARCHAR, UNIQUE)
  - created_at (TIMESTAMP)
- **Orders Table**
  - id (INT, PRIMARY KEY)
  - user_id (INT, FOREIGN KEY)
  - product_name (VARCHAR)
  - order_date (TIMESTAMP)

### Stock Service Database (starline_stock_db)
- **Products Table**
  - id (INT, PRIMARY KEY)
  - name (VARCHAR)
  - price (DECIMAL)
  - stock (INT)
  - created_at (TIMESTAMP)
- **Transactions Table**
  - id (INT, PRIMARY KEY)
  - product_id (INT, FOREIGN KEY)
  - quantity (INT)
  - transaction_date (TIMESTAMP)

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd starpoc
   ```

2. **Environment Setup**
   ```bash
   # Copy the example environment file
   cp .env.example .env
   ```
   The `.env` file contains important configuration variables for the project. Review and modify these variables according to your environment if needed:
   ```
   # MySQL Root Configuration
   MYSQL_ROOT_PASSWORD=root

   # Starline Service Database
   MYSQL_STARLINE_DB=starline_service_db
   MYSQL_STARLINE_USER=root
   MYSQL_STARLINE_PASSWORD=root

   # Starline Stock Database
   MYSQL_STOCK_DB=starline_stock_db
   MYSQL_STOCK_USER=root
   MYSQL_STOCK_PASSWORD=root

   # Common Database Configuration
   MYSQL_HOST=mysql
   MYSQL_CHARSET=utf8mb4
   ```
   > ⚠️ **Important**: For security in production environments, make sure to change default passwords and usernames.

3. **Docker Network Setup**
   ```bash
   # Remove existing network (if exists)
   docker network rm starline-network

   # Create Docker Network
   docker network create starline-network
   ```

4. **Start Services**
   ```bash
   docker-compose up -d
   ```

## API Documentation

### Starline Service (Core)

#### Welcome Endpoint
- **URL**: `/starline/`
- **Method**: GET
- **Response**: 
  ```json
  {"message": "Welcome to the Starline service!"}
  ```

#### List Users
- **URL**: `/starline/users`
- **Method**: GET
- **Response**: Array of user objects
  ```json
  [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john.doe@example.com",
      "created_at": "2025-04-07 00:00:00"
    }
  ]
  ```

### Starline Stock Service

#### Welcome Endpoint
- **URL**: `/starline-stock/`
- **Method**: GET
- **Response**: 
  ```json
  {"message": "Welcome to the Starline Stock service!"}
  ```

#### List Products
- **URL**: `/starline-stock/products`
- **Method**: GET
- **Response**: Array of product objects
  ```json
  [
    {
      "id": 1,
      "name": "Satellite A",
      "price": 1000.00,
      "stock": 50,
      "created_at": "2025-04-07 00:00:00"
    }
  ]
  ```

## Development

### File Locations
- PHP application files are mounted in their respective containers:
  - Starline: `/var/www/starline`
  - Starline Stock: `/var/www/starline-stock`
- Nginx configuration: `/etc/nginx/conf.d/`
- MySQL data: Persisted using Docker volumes

### Logging
- Nginx logs: `/var/log/nginx/`
  - access.log
  - error.log (debug level enabled)
- PHP-FPM logs: `/var/log/php-fpm.log`

## Troubleshooting

### Common Issues

1. **Service Not Accessible**
   - Check if containers are running:
     ```bash
     docker ps
     ```
   - Verify Nginx logs:
     ```bash
     docker logs nginx
     ```

2. **Database Connection Issues**
   - Verify MySQL is running:
     ```bash
     docker logs mysql
     ```
   - Check database connectivity:
     ```bash
     docker exec -it mysql mysql -uroot -proot
     ```

3. **Permission Issues**
   - Services run as www-data user
   - Check file permissions in mounted volumes

### Health Checks
- Each service has a test.php endpoint
- PHP-FPM includes built-in health check
- Use Docker health status:
  ```bash
  docker ps --format "table {{.Names}}\t{{.Status}}"
  ```

## Security Notes

1. **Database**
   - Root password should be changed in production
   - Implement proper user authentication
   - Restrict database access

2. **PHP Configuration**
   - Error reporting enabled for debugging
   - Should be disabled in production
   - Implement proper error handling

3. **Network Security**
   - Services communicate over internal Docker network
   - Only necessary ports exposed
   - Implement SSL/TLS in production

## Maintenance

### Updating Services
1. Make code changes
2. Rebuild containers:
   ```bash
   docker-compose up -d --build
   ```

### Backing Up Data
1. Database backup:
   ```bash
   docker exec mysql mysqldump -uroot -proot --all-databases > backup.sql
   ```

### Monitoring
- Use docker logs for monitoring:
  ```bash
  docker logs -f [container_name]
  ```

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Create pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Starline Microservices Project
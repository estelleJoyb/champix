# README.md

# Champix Backend

Champix Backend is a FastAPI application designed to manage mushroom data and user authentication. This project provides a RESTful API for CRUD operations on mushrooms and user management, including authentication features.

## Project Structure

```
champix-backend
├── docker-compose.yml       # Defines services for Docker application
├── Dockerfile               # Instructions to build the Docker image
├── requirements.txt         # Python dependencies
├── README.md                # Project documentation
├── app
│   ├── config.py           # Configuration settings
│   ├── main.py             # Entry point of the application
│   ├── database.py         # Database connection and session management
│   ├── auth
│   │   ├── auth_controller.py  # User authentication functions
│   │   ├── auth_routes.py       # Authentication routes
│   │   └── auth_model.py        # Authentication data models
│   ├── controllers
│   │   ├── user_controller.py    # User management functions
│   │   └── mushroom_controller.py # Mushroom management functions
│   ├── models
│   │   ├── user_model.py         # User data model
│   │   └── mushroom_model.py      # Mushroom data model
│   ├── routes
│   │   ├── user_routes.py        # User-related routes
│   │   └── mushroom_routes.py     # Mushroom-related routes
```

## Setup Instructions

1. **Clone the repository:**
   ```
   git clone <repository-url>
   cd champix-backend
   ```

2. **Build and run the application using Docker:**
   ```
   docker-compose up --build
   ```

3. **Access the API:**
   The API will be available at `http://localhost:8000`.

## Usage

### API Endpoints

- **User Management**
  - `GET /users/` - List all users
  - `POST /users/` - Create a new user
  - `PUT /users/{id}` - Update an existing user
  - `DELETE /users/{id}` - Delete a user

- **Mushroom Management**
  - `GET /mushrooms/` - List all mushrooms
  - `POST /mushrooms/` - Create a new mushroom
  - `PUT /mushrooms/{id}` - Update an existing mushroom
  - `DELETE /mushrooms/{id}` - Delete a mushroom

- **Authentication**
  - `POST /auth/login` - User login
  - `POST /auth/register` - User registration

## Requirements

- Python 3.8+
- Docker
- Docker Compose

## License

This project is licensed under the MIT License.
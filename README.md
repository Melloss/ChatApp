# Chat Application

This is a real-time chat application built using FastAPI for the backend and Flutter for the frontend. The application supports real-time messaging using WebSockets.

## Features

- **Real-time Messaging**: Uses WebSockets for instant communication.
- **User Authentication**: Secure login and signup functionality.
- **Message Persistence**: Stores messages in a database.
- **User Presence**: Displays online/offline status.

## Technologies Used

### Backend (FastAPI)
- FastAPI
- WebSockets
- SQLite (Database)
- SQLAlchemy (ORM)
- Pydantic (Data validation)
- JWT Authentication

### Frontend (Flutter)
- Flutter (Dart)
- WebSocket Package for real-time communication
- Bloc (State Management)
- Secure Storage (Local storage)

## Setup Instructions

### Backend Setup

1. Clone the repository:
   ```sh
   git clone git@github.com:Melloss/ChatApp.git
   cd backend
   ```
2. Create a virtual environment and activate it:
   ```sh
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```
3. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
4. Start the FastAPI server:
   ```sh
   fastapi dev ./app/main.py
   ```
5. Open the API docs in a browser:
   ```
   http://127.0.0.1:8000/docs
   ```

### Frontend Setup

1. Clone the frontend repository:
   ```sh
   git clone https://github.com/YOUR_GITHUB/chat-app-frontend.git
   cd frontend
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## License
This project is licensed under the MIT License.


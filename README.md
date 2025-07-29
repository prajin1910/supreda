# SmartEval Android Application

A comprehensive Android application built with Kotlin and Jetpack Compose that mirrors the functionality of the SmartEval web application. This app provides AI-powered learning tools, assessment management, task tracking, and communication features for students, professors, and alumni.

## Features

### For Students
- **Dashboard**: Overview of assessments, tasks, and AI-powered learning tools
- **Assessments**: Take assigned assessments with real-time session management
- **Task Management**: Create, organize, and track personal tasks with priority levels
- **AI Roadmap**: Generate personalized learning paths using AI
- **AI Practice**: Take AI-generated practice tests with detailed feedback
- **Chat**: Communicate with professors and alumni

### For Professors
- **Dashboard**: Manage assessments, alumni requests, and student interactions
- **Assessment Management**: Create, assign, and monitor student assessments
- **Alumni Management**: Review and approve alumni registration requests
- **Chat**: Communicate with students and alumni
- **Analytics**: View detailed assessment analytics and student performance

### For Alumni
- **Dashboard**: Connect with students and share professional experience
- **Chat**: Mentor current students and connect with professors

## Technology Stack

- **Language**: Kotlin
- **UI Framework**: Jetpack Compose
- **Architecture**: MVVM with Repository Pattern
- **Dependency Injection**: Hilt
- **Networking**: Retrofit + OkHttp
- **Local Storage**: DataStore Preferences
- **Navigation**: Navigation Compose
- **Async Operations**: Coroutines + Flow
- **Backend**: Same Spring Boot backend with MongoDB

## Project Structure

```
app/
├── src/main/java/com/smarteval/app/
│   ├── data/
│   │   ├── local/          # DataStore preferences
│   │   ├── model/          # Data models
│   │   ├── remote/         # API service interfaces
│   │   └── repository/     # Repository implementations
│   ├── di/                 # Dependency injection modules
│   ├── presentation/       # UI layer
│   │   ├── auth/          # Authentication screens
│   │   ├── student/       # Student dashboard and features
│   │   ├── professor/     # Professor dashboard and features
│   │   ├── alumni/        # Alumni dashboard and features
│   │   └── navigation/    # Navigation setup
│   ├── ui/theme/          # Material Design theme
│   └── utils/             # Utility classes
└── build.gradle           # App-level dependencies
```

## Setup Instructions

### Prerequisites
- Android Studio Arctic Fox or later
- JDK 8 or later
- Android SDK API 24 or later
- Running SmartEval backend server

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smarteval-android
   ```

2. **Open in Android Studio**
   - Open Android Studio
   - Select "Open an existing project"
   - Navigate to the cloned directory and select it

3. **Configure Backend URL**
   - Open `app/src/main/java/com/smarteval/app/di/NetworkModule.kt`
   - Update the `BASE_URL` constant to point to your backend server:
   ```kotlin
   private const val BASE_URL = "http://your-backend-url:8080/api/"
   ```
   - For local development with emulator, use: `http://10.0.2.2:8080/api/`
   - For physical device, use your computer's IP address

4. **Sync Project**
   - Click "Sync Now" when prompted
   - Wait for Gradle sync to complete

5. **Run the Application**
   - Connect an Android device or start an emulator
   - Click the "Run" button or press Ctrl+R

## Key Components

### Authentication Flow
- **Login/Register**: Complete user authentication with OTP verification
- **Role-based Navigation**: Automatic routing based on user role
- **Secure Token Storage**: JWT tokens stored securely using DataStore

### Data Layer
- **Repository Pattern**: Clean separation between data sources and UI
- **Retrofit Integration**: RESTful API communication with the backend
- **Local Caching**: User preferences and authentication data cached locally

### UI Layer
- **Jetpack Compose**: Modern declarative UI framework
- **Material Design 3**: Latest Material Design components and theming
- **Responsive Design**: Optimized for various screen sizes
- **Navigation**: Type-safe navigation between screens

### Features Implementation

#### Student Features
- **Assessment Taking**: Real-time assessment interface with timer and progress tracking
- **Task Management**: CRUD operations for personal task management
- **AI Integration**: Roadmap generation and practice test creation using AI APIs
- **Chat System**: Real-time messaging with professors and alumni

#### Professor Features
- **Assessment Creation**: Comprehensive assessment builder with question management
- **Student Monitoring**: Track student progress and performance
- **Alumni Approval**: Review and approve alumni registration requests

#### Alumni Features
- **Mentorship**: Connect with current students for guidance
- **Professional Networking**: Share experience and career insights

## API Integration

The app integrates with the same Spring Boot backend used by the web application:

- **Authentication**: `/api/auth/*`
- **Assessments**: `/api/assessments/*`
- **Tasks**: `/api/tasks/*`
- **Chat**: `/api/chat/*`
- **AI Services**: `/api/ai/*`
- **Alumni Management**: `/api/alumni/*`

## Security Features

- **JWT Authentication**: Secure token-based authentication
- **Automatic Token Refresh**: Seamless session management
- **Role-based Access Control**: Feature access based on user roles
- **Secure Storage**: Sensitive data encrypted using Android Keystore

## Performance Optimizations

- **Lazy Loading**: Efficient data loading with pagination
- **Image Caching**: Optimized image loading and caching
- **Background Processing**: Heavy operations performed on background threads
- **Memory Management**: Proper lifecycle management to prevent memory leaks

## Testing

The project includes:
- **Unit Tests**: Repository and ViewModel testing
- **Integration Tests**: API integration testing
- **UI Tests**: Compose UI testing

Run tests using:
```bash
./gradlew test
./gradlew connectedAndroidTest
```

## Building for Release

1. **Generate Signed APK**
   - Build → Generate Signed Bundle/APK
   - Select APK and follow the signing process

2. **Build AAB for Play Store**
   ```bash
   ./gradlew bundleRelease
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## Changelog

### Version 1.0.0
- Initial release with complete feature parity to web application
- Authentication system with OTP verification
- Role-based dashboards for students, professors, and alumni
- Assessment management and taking functionality
- Task management system
- AI-powered learning tools
- Real-time chat system
- Material Design 3 UI with dark/light theme support
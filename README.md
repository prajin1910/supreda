# SmartEval Flutter Application

A comprehensive Flutter mobile application that mirrors the functionality of the SmartEval web application. This app provides AI-powered learning tools, assessment management, task tracking, and communication features for students, professors, and alumni.

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

### For Alumni
- **Dashboard**: Connect with students and share professional experience
- **Chat**: Mentor current students and connect with professors

## Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences & SQLite
- **Backend**: Java Spring Boot with MongoDB (same as web version)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── assessment.dart
│   ├── task.dart
│   ├── chat.dart
│   ├── ai.dart
│   └── alumni.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── assessment_provider.dart
│   ├── task_provider.dart
│   ├── chat_provider.dart
│   ├── ai_provider.dart
│   └── alumni_provider.dart
├── screens/                  # Main screens
│   ├── auth/
│   ├── student/
│   ├── professor/
│   └── alumni/
├── widgets/                  # Reusable widgets
│   ├── student/
│   ├── professor/
│   ├── alumni/
│   └── common/
├── services/                 # API services
│   └── api_service.dart
└── utils/                    # Utilities
    ├── theme.dart
    ├── constants.dart
    └── helpers.dart
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.0 or later
- Dart SDK 3.0 or later
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)
- Running SmartEval Java backend server

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smarteval-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure Backend URL**
   - Open `lib/services/api_service.dart`
   - Update the `baseUrl` constant to point to your backend server:
   ```dart
   static const String baseUrl = 'http://your-backend-url:8080/api';
   ```
   - For local development with emulator, use: `http://10.0.2.2:8080/api`
   - For physical device, use your computer's IP address

5. **Run the application**
   ```bash
   flutter run
   ```

## Key Components

### Authentication Flow
- **Login/Register**: Complete user authentication with OTP verification
- **Role-based Navigation**: Automatic routing based on user role
- **Secure Token Storage**: JWT tokens stored securely using SharedPreferences

### Data Layer
- **Provider Pattern**: Clean state management with Provider
- **Dio Integration**: RESTful API communication with the backend
- **Local Caching**: User preferences and authentication data cached locally

### UI Layer
- **Material Design**: Modern Material Design 3 components
- **Responsive Design**: Optimized for various screen sizes
- **Navigation**: Type-safe navigation with GoRouter

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

The app integrates with the same Java Spring Boot backend used by the web application:

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
- **Secure Storage**: Sensitive data stored using platform-specific secure storage

## Performance Optimizations

- **Lazy Loading**: Efficient data loading with pagination
- **State Management**: Optimized state updates with Provider
- **Background Processing**: Heavy operations performed on background isolates
- **Memory Management**: Proper lifecycle management to prevent memory leaks

## Testing

The project includes:
- **Unit Tests**: Provider and service testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end testing

Run tests using:
```bash
flutter test
```

## Building for Release

### Android
1. **Generate signed APK**
   ```bash
   flutter build apk --release
   ```

2. **Generate App Bundle for Play Store**
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. **Build for iOS**
   ```bash
   flutter build ios --release
   ```

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `shared_preferences`: Local storage
- `json_annotation`: JSON serialization

### UI Dependencies
- `material_design_icons_flutter`: Material Design icons
- `flutter_spinkit`: Loading animations
- `fluttertoast`: Toast messages
- `fl_chart`: Charts and graphs

### Utility Dependencies
- `intl`: Internationalization
- `permission_handler`: Permissions
- `url_launcher`: URL launching
- `image_picker`: Image selection
- `file_picker`: File selection

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
- Check the documentation

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
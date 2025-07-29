import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/assessment_provider.dart';
import 'providers/task_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/ai_provider.dart';
import 'providers/alumni_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/professor/professor_dashboard.dart';
import 'screens/alumni/alumni_dashboard.dart';
import 'utils/theme.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  
  runApp(SmartEvalApp(
    prefs: prefs,
    apiService: apiService,
  ));
}

class SmartEvalApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiService apiService;

  const SmartEvalApp({
    Key? key,
    required this.prefs,
    required this.apiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(prefs, apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => AssessmentProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => AIProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => AlumniProvider(apiService),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'SmartEval',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _createRouter(authProvider),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isAuthenticated ? _getInitialRoute(authProvider) : '/login',
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoginRoute = state.location == '/login' || 
                           state.location == '/register' || 
                           state.location.startsWith('/otp');

        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }

        if (isAuthenticated && isLoginRoute) {
          return _getInitialRoute(authProvider);
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/otp/:email',
          builder: (context, state) => OtpVerificationScreen(
            email: state.pathParameters['email']!,
          ),
        ),
        GoRoute(
          path: '/student',
          builder: (context, state) => const StudentDashboard(),
        ),
        GoRoute(
          path: '/professor',
          builder: (context, state) => const ProfessorDashboard(),
        ),
        GoRoute(
          path: '/alumni',
          builder: (context, state) => const AlumniDashboard(),
        ),
      ],
    );
  }

  String _getInitialRoute(AuthProvider authProvider) {
    final user = authProvider.user;
    if (user == null) return '/login';
    
    switch (user.role) {
      case 'STUDENT':
        return '/student';
      case 'PROFESSOR':
        return '/professor';
      case 'ALUMNI':
        return '/alumni';
      default:
        return '/login';
    }
  }
}
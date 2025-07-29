package com.smarteval.app.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.smarteval.app.data.model.UserRole
import com.smarteval.app.presentation.auth.AuthViewModel
import com.smarteval.app.presentation.auth.LoginScreen
import com.smarteval.app.presentation.auth.RegisterScreen
import com.smarteval.app.presentation.auth.OtpVerificationScreen
import com.smarteval.app.presentation.student.StudentDashboard
import com.smarteval.app.presentation.professor.ProfessorDashboard
import com.smarteval.app.presentation.alumni.AlumniDashboard

@Composable
fun SmartEvalNavigation(
    navController: NavHostController = rememberNavController(),
    authViewModel: AuthViewModel = hiltViewModel()
) {
    val authState by authViewModel.authState.collectAsState()
    
    NavHost(
        navController = navController,
        startDestination = if (authState.isAuthenticated) {
            when (authState.user?.role) {
                UserRole.STUDENT -> "student_dashboard"
                UserRole.PROFESSOR -> "professor_dashboard"
                UserRole.ALUMNI -> "alumni_dashboard"
                else -> "login"
            }
        } else "login"
    ) {
        composable("login") {
            LoginScreen(
                onNavigateToRegister = { navController.navigate("register") },
                onLoginSuccess = { user ->
                    when (user.role) {
                        UserRole.STUDENT -> navController.navigate("student_dashboard") {
                            popUpTo("login") { inclusive = true }
                        }
                        UserRole.PROFESSOR -> navController.navigate("professor_dashboard") {
                            popUpTo("login") { inclusive = true }
                        }
                        UserRole.ALUMNI -> navController.navigate("alumni_dashboard") {
                            popUpTo("login") { inclusive = true }
                        }
                    }
                }
            )
        }
        
        composable("register") {
            RegisterScreen(
                onNavigateToLogin = { navController.navigate("login") },
                onNavigateToOtp = { email -> navController.navigate("otp_verification/$email") }
            )
        }
        
        composable("otp_verification/{email}") { backStackEntry ->
            val email = backStackEntry.arguments?.getString("email") ?: ""
            OtpVerificationScreen(
                email = email,
                onNavigateToLogin = { navController.navigate("login") },
                onNavigateBack = { navController.popBackStack() }
            )
        }
        
        composable("student_dashboard") {
            StudentDashboard(
                onLogout = {
                    navController.navigate("login") {
                        popUpTo(0) { inclusive = true }
                    }
                }
            )
        }
        
        composable("professor_dashboard") {
            ProfessorDashboard(
                onLogout = {
                    navController.navigate("login") {
                        popUpTo(0) { inclusive = true }
                    }
                }
            )
        }
        
        composable("alumni_dashboard") {
            AlumniDashboard(
                onLogout = {
                    navController.navigate("login") {
                        popUpTo(0) { inclusive = true }
                    }
                }
            )
        }
    }
}
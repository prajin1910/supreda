package com.smarteval.app.presentation.auth

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.smarteval.app.data.local.UserPreferences
import com.smarteval.app.data.model.*
import com.smarteval.app.data.repository.AuthRepository
import com.smarteval.app.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

data class AuthState(
    val isAuthenticated: Boolean = false,
    val user: User? = null,
    val token: String? = null,
    val isLoading: Boolean = false,
    val error: String? = null
)

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val authRepository: AuthRepository,
    private val userPreferences: UserPreferences
) : ViewModel() {
    
    private val _authState = MutableStateFlow(AuthState())
    val authState: StateFlow<AuthState> = _authState.asStateFlow()
    
    init {
        checkAuthStatus()
    }
    
    private fun checkAuthStatus() {
        viewModelScope.launch {
            combine(
                userPreferences.authToken,
                userPreferences.userData
            ) { token, user ->
                AuthState(
                    isAuthenticated = token != null && user != null,
                    user = user,
                    token = token
                )
            }.collect { state ->
                _authState.value = state
            }
        }
    }
    
    fun login(email: String, password: String) {
        viewModelScope.launch {
            authRepository.login(LoginRequest(email, password)).collect { result ->
                when (result) {
                    is Resource.Loading -> {
                        _authState.value = _authState.value.copy(isLoading = true, error = null)
                    }
                    is Resource.Success -> {
                        result.data?.let { loginResponse ->
                            userPreferences.saveAuthData(loginResponse.token, loginResponse.user)
                            _authState.value = _authState.value.copy(
                                isLoading = false,
                                isAuthenticated = true,
                                user = loginResponse.user,
                                token = loginResponse.token,
                                error = null
                            )
                        }
                    }
                    is Resource.Error -> {
                        _authState.value = _authState.value.copy(
                            isLoading = false,
                            error = result.message
                        )
                    }
                }
            }
        }
    }
    
    fun register(username: String, email: String, password: String, role: String, professorEmail: String? = null) {
        viewModelScope.launch {
            authRepository.register(
                RegisterRequest(username, email, password, role, professorEmail)
            ).collect { result ->
                when (result) {
                    is Resource.Loading -> {
                        _authState.value = _authState.value.copy(isLoading = true, error = null)
                    }
                    is Resource.Success -> {
                        _authState.value = _authState.value.copy(isLoading = false, error = null)
                    }
                    is Resource.Error -> {
                        _authState.value = _authState.value.copy(
                            isLoading = false,
                            error = result.message
                        )
                    }
                }
            }
        }
    }
    
    fun verifyOtp(email: String, otp: String) {
        viewModelScope.launch {
            authRepository.verifyOtp(OtpVerificationRequest(email, otp)).collect { result ->
                when (result) {
                    is Resource.Loading -> {
                        _authState.value = _authState.value.copy(isLoading = true, error = null)
                    }
                    is Resource.Success -> {
                        _authState.value = _authState.value.copy(isLoading = false, error = null)
                    }
                    is Resource.Error -> {
                        _authState.value = _authState.value.copy(
                            isLoading = false,
                            error = result.message
                        )
                    }
                }
            }
        }
    }
    
    fun resendOtp(email: String) {
        viewModelScope.launch {
            authRepository.resendOtp(email).collect { result ->
                when (result) {
                    is Resource.Loading -> {
                        _authState.value = _authState.value.copy(isLoading = true, error = null)
                    }
                    is Resource.Success -> {
                        _authState.value = _authState.value.copy(isLoading = false, error = null)
                    }
                    is Resource.Error -> {
                        _authState.value = _authState.value.copy(
                            isLoading = false,
                            error = result.message
                        )
                    }
                }
            }
        }
    }
    
    fun logout() {
        viewModelScope.launch {
            userPreferences.clearAuthData()
            _authState.value = AuthState()
        }
    }
    
    fun clearError() {
        _authState.value = _authState.value.copy(error = null)
    }
}
class Constants {
  // API Constants
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // User Roles
  static const String studentRole = 'STUDENT';
  static const String professorRole = 'PROFESSOR';
  static const String alumniRole = 'ALUMNI';
  
  // Task Status
  static const String taskPending = 'PENDING';
  static const String taskOngoing = 'ONGOING';
  static const String taskCompleted = 'COMPLETED';
  
  // Task Priority
  static const String taskLow = 'LOW';
  static const String taskMedium = 'MEDIUM';
  static const String taskHigh = 'HIGH';
  
  // Assessment Status
  static const String assessmentScheduled = 'SCHEDULED';
  static const String assessmentOngoing = 'ONGOING';
  static const String assessmentCompleted = 'COMPLETED';
  
  // Alumni Request Status
  static const String alumniPending = 'PENDING';
  static const String alumniApproved = 'APPROVED';
  static const String alumniRejected = 'REJECTED';
  
  // AI Difficulty Levels
  static const String difficultyEasy = 'EASY';
  static const String difficultyMedium = 'MEDIUM';
  static const String difficultyHard = 'HARD';
  
  // Shared Preferences Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  
  // Date Formats
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
}
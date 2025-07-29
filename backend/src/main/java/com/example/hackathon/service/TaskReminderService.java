package com.example.hackathon.service;

import com.example.hackathon.model.Task;
import com.example.hackathon.model.User;
import com.example.hackathon.repository.TaskRepository;
import com.example.hackathon.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
public class TaskReminderService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    // Run every hour to check for tasks due within 24 hours
    @Scheduled(fixedRate = 3600000) // 1 hour = 3600000 ms
    public void checkTaskReminders() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime twentyFourHoursLater = now.plusHours(24);

        // Find all tasks that are due within 24 hours and not completed
        List<Task> tasksDueSoon = taskRepository.findTasksDueWithin24Hours(now, twentyFourHoursLater);

        for (Task task : tasksDueSoon) {
            // Check if reminder hasn't been sent yet
            if (!task.isReminderSent()) {
                sendTaskReminder(task);
                // Mark reminder as sent
                task.setReminderSent(true);
                taskRepository.save(task);
            }
        }
    }

    private void sendTaskReminder(Task task) {
        try {
            // Get student details
            User student = userRepository.findById(task.getStudentId()).orElse(null);
            if (student == null) return;

            // Calculate time remaining
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime endTime = task.getEndDateTime();
            long hoursRemaining = ChronoUnit.HOURS.between(now, endTime);
            long minutesRemaining = ChronoUnit.MINUTES.between(now, endTime) % 60;

            String timeRemainingText;
            if (hoursRemaining > 0) {
                timeRemainingText = hoursRemaining + " hours and " + minutesRemaining + " minutes";
            } else {
                timeRemainingText = minutesRemaining + " minutes";
            }

            // Send email reminder
            emailService.sendTaskReminder(
                student.getEmail(),
                student.getUsername(),
                task.getTitle(),
                task.getDescription(),
                timeRemainingText,
                task.getEndDateTime().toString()
            );

        } catch (Exception e) {
            System.err.println("Failed to send task reminder: " + e.getMessage());
        }
    }

    public List<Task> getTasksDueSoon(String studentId) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime twentyFourHoursLater = now.plusHours(24);
        return taskRepository.findTasksDueSoonForStudent(studentId, now, twentyFourHoursLater);
    }
}
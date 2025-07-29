package com.example.hackathon.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender emailSender;

    public void sendOTP(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("noreply@smarteval.com");
        message.setTo(to);
        message.setSubject("SmartEval - Email Verification");
        message.setText("Your verification code is: " + otp + "\n\nThis code will expire in 10 minutes.");
        
        emailSender.send(message);
    }

    public void sendAlumniApprovalNotification(String to, String professorName, boolean approved) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("noreply@smarteval.com");
        message.setTo(to);
        message.setSubject("SmartEval - Alumni Request Status");
        
        String status = approved ? "approved" : "rejected";
        message.setText("Your alumni registration request has been " + status + " by Professor " + professorName + ".");
        
        emailSender.send(message);
    }

    public void sendTaskReminder(String to, String studentName, String taskTitle, String taskDescription, String timeRemaining, String dueDate) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("noreply@smarteval.com");
        message.setTo(to);
        message.setSubject("SmartEval - Task Reminder: " + taskTitle);
        
        StringBuilder messageText = new StringBuilder();
        messageText.append("Dear ").append(studentName).append(",\n\n");
        messageText.append("This is a reminder that your task \"").append(taskTitle).append("\" is due soon.\n\n");
        messageText.append("Task Details:\n");
        messageText.append("Title: ").append(taskTitle).append("\n");
        if (taskDescription != null && !taskDescription.trim().isEmpty()) {
            messageText.append("Description: ").append(taskDescription).append("\n");
        }
        messageText.append("Due Date: ").append(dueDate).append("\n");
        messageText.append("Time Remaining: ").append(timeRemaining).append("\n\n");
        messageText.append("Please complete your task before the deadline.\n\n");
        messageText.append("Best regards,\n");
        messageText.append("SmartEval Team");
        
        message.setText(messageText.toString());
        emailSender.send(message);
    }
}
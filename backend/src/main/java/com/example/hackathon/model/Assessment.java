package com.example.hackathon.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "assessments")
public class Assessment {
    @Id
    private String id;
    
    private String title;
    private String description;
    private List<Question> questions;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String createdBy; // Professor ID
    private List<String> assignedStudents;
    private AssessmentStatus status = AssessmentStatus.SCHEDULED;
    private LocalDateTime createdAt = LocalDateTime.now();

    public enum AssessmentStatus {
        SCHEDULED, ONGOING, COMPLETED
    }

    // Constructors
    public Assessment() {}

    public Assessment(String title, String description, List<Question> questions, 
                     LocalDateTime startTime, LocalDateTime endTime, String createdBy, 
                     List<String> assignedStudents) {
        this.title = title;
        this.description = description;
        this.questions = questions;
        this.startTime = startTime;
        this.endTime = endTime;
        this.createdBy = createdBy;
        this.assignedStudents = assignedStudents;
        this.updateStatus();
    }

    // Method to update status based on current time
    public void updateStatus() {
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(this.startTime)) {
            this.status = AssessmentStatus.SCHEDULED;
        } else if (now.isAfter(this.startTime) && now.isBefore(this.endTime)) {
            this.status = AssessmentStatus.ONGOING;
        } else {
            this.status = AssessmentStatus.COMPLETED;
        }
    }

    // Method to check if assessment is currently available
    public boolean isAvailable() {
        LocalDateTime now = LocalDateTime.now();
        return now.isAfter(this.startTime) && now.isBefore(this.endTime);
    }

    // Method to check if assessment has started
    public boolean hasStarted() {
        return LocalDateTime.now().isAfter(this.startTime);
    }

    // Method to check if assessment has ended
    public boolean hasEnded() {
        return LocalDateTime.now().isAfter(this.endTime);
    }
    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }

    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public List<String> getAssignedStudents() { return assignedStudents; }
    public void setAssignedStudents(List<String> assignedStudents) { this.assignedStudents = assignedStudents; }

    public AssessmentStatus getStatus() { 
        updateStatus();
        return status; 
    }
    public void setStatus(AssessmentStatus status) { 
        this.status = status; 
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
package com.example.hackathon.service;

import com.example.hackathon.model.Assessment;
import com.example.hackathon.repository.AssessmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AssessmentSchedulerService {

    @Autowired
    private AssessmentRepository assessmentRepository;

    // Run every minute to update assessment statuses
    @Scheduled(fixedRate = 60000) // 1 minute = 60000 ms
    public void updateAssessmentStatuses() {
        try {
            List<Assessment> assessments = assessmentRepository.findAll();
            LocalDateTime now = LocalDateTime.now();
            boolean hasUpdates = false;

            for (Assessment assessment : assessments) {
                Assessment.AssessmentStatus oldStatus = assessment.getStatus();
                Assessment.AssessmentStatus newStatus;

                if (now.isBefore(assessment.getStartTime())) {
                    newStatus = Assessment.AssessmentStatus.SCHEDULED;
                } else if (now.isAfter(assessment.getStartTime()) && now.isBefore(assessment.getEndTime())) {
                    newStatus = Assessment.AssessmentStatus.ONGOING;
                } else {
                    newStatus = Assessment.AssessmentStatus.COMPLETED;
                }

                if (oldStatus != newStatus) {
                    assessment.setStatus(newStatus);
                    assessmentRepository.save(assessment);
                    hasUpdates = true;
                    
                    System.out.println("Updated assessment " + assessment.getId() + 
                                     " status from " + oldStatus + " to " + newStatus + 
                                     " at " + now);
                }
            }

            if (hasUpdates) {
                System.out.println("Assessment statuses updated at " + now);
            }
        } catch (Exception e) {
            System.err.println("Error updating assessment statuses: " + e.getMessage());
        }
    }

    // Run every 5 minutes to log current assessment states for debugging
    @Scheduled(fixedRate = 300000) // 5 minutes = 300000 ms
    public void logAssessmentStates() {
        try {
            List<Assessment> assessments = assessmentRepository.findAll();
            LocalDateTime now = LocalDateTime.now();
            
            System.out.println("=== Assessment Status Report at " + now + " ===");
            for (Assessment assessment : assessments) {
                System.out.println("Assessment: " + assessment.getTitle());
                System.out.println("  ID: " + assessment.getId());
                System.out.println("  Start: " + assessment.getStartTime());
                System.out.println("  End: " + assessment.getEndTime());
                System.out.println("  Current Status: " + assessment.getStatus());
                System.out.println("  Is Available: " + assessment.isAvailable());
                System.out.println("  Has Started: " + assessment.hasStarted());
                System.out.println("  Has Ended: " + assessment.hasEnded());
                System.out.println("  ---");
            }
            System.out.println("=== End Report ===");
        } catch (Exception e) {
            System.err.println("Error logging assessment states: " + e.getMessage());
        }
    }
}
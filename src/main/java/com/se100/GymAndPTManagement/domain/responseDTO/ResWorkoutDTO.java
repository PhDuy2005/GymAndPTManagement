package com.se100.GymAndPTManagement.domain.responseDTO;

import java.time.Instant;

import com.se100.GymAndPTManagement.util.enums.WorkoutDifficultyEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResWorkoutDTO {
    private Long id;
    private String name;
    private String description;
    private Integer duration; // in minutes
    private WorkoutDifficultyEnum difficulty;
    private String type;

    // Audit fields
    private Instant createdAt;
    private Instant updatedAt;
    private String createdBy;
    private String updatedBy;
}

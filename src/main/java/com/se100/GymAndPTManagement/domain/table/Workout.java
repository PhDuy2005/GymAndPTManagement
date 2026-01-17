package com.se100.GymAndPTManagement.domain.table;

import java.time.Instant;

import com.se100.GymAndPTManagement.util.SecurityUtil;
import com.se100.GymAndPTManagement.util.enums.WorkoutDifficultyEnum;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "workouts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Workout {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "workout_id")
    private Long id;

    @Column(name = "name", nullable = false, unique = true, length = 255)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "duration")
    private Integer duration; // in minutes

    @Enumerated(EnumType.STRING)
    @Column(name = "difficulty", length = 20)
    private WorkoutDifficultyEnum difficulty;

    @Column(name = "type", length = 100)
    private String type;

    // Audit fields (bắt buộc)
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "created_by", length = 100)
    private String createdBy;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
        createdBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
        updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }
}

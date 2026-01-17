package com.se100.GymAndPTManagement.domain.table;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

import com.se100.GymAndPTManagement.util.SecurityUtil;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "body_metrics")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BodyMetrics {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "metric_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne
    @JoinColumn(name = "measured_by")
    private User measuredBy;

    @Column(name = "measured_date", nullable = false)
    private LocalDate measuredDate;

    @Column(name = "weight", precision = 5, scale = 2)
    private BigDecimal weight;

    @Column(name = "height", precision = 5, scale = 2)
    private BigDecimal height;

    @Column(name = "muscle_mass", precision = 5, scale = 2)
    private BigDecimal muscleMass;

    @Column(name = "body_fat_percentage", precision = 5, scale = 2)
    private BigDecimal bodyFatPercentage;

    @Column(name = "bmi", precision = 5, scale = 2)
    private BigDecimal bmi;

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
        calculateBMI();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
        updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
        calculateBMI();
    }

    private void calculateBMI() {
        if (height != null && height.compareTo(BigDecimal.ZERO) > 0 && weight != null) {
            BigDecimal heightInMeters = height.divide(BigDecimal.valueOf(100)); // assuming height is in cm
            this.bmi = weight.divide(heightInMeters.multiply(heightInMeters), 2, BigDecimal.ROUND_HALF_UP);
        } else {
            this.bmi = null;
        }
    }
}

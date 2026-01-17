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
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "workout_devices")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkoutDevice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "device_id")
    private Long id;

    @Column(name = "name", nullable = false, unique = true, length = 255)
    private String name;

    @Column(name = "type", length = 100)
    private String type;

    @Column(name = "price", precision = 15, scale = 2)
    private BigDecimal price;

    @Column(name = "date_imported")
    private LocalDate dateImported;

    @Column(name = "date_maintenance")
    private LocalDate dateMaintenance;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

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

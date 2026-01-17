package com.se100.GymAndPTManagement.domain.table;

import java.math.BigDecimal;
import java.time.Instant;

import com.se100.GymAndPTManagement.util.SecurityUtil;
import com.se100.GymAndPTManagement.util.enums.PackageTypeEnum;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "service_packages", indexes = {
        @Index(name = "idx_package_name", columnList = "package_name"),
        @Index(name = "idx_is_active", columnList = "is_active"),
        @Index(name = "idx_type", columnList = "type")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServicePackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "package_id")
    private Long id;

    @Column(name = "package_name", nullable = false, length = 255)
    private String packageName;

    @Column(name = "price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", length = 50)
    private PackageTypeEnum type;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @Column(name = "description", columnDefinition = "MEDIUMTEXT")
    private String description;

    @Column(name = "duration_in_days")
    private Integer durationInDays;

    @Column(name = "number_of_sessions")
    private Integer numberOfSessions;

    // Audit fields
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
        if (isActive == null) {
            isActive = true;
        }
        if (price == null) {
            price = BigDecimal.ZERO;
        }
        if (numberOfSessions == null) {
            numberOfSessions = 0;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
        updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }
}

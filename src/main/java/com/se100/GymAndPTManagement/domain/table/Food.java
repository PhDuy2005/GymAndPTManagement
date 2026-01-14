package com.se100.GymAndPTManagement.domain.table;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Entity
@Table(name = "food", indexes = {
    @Index(name = "idx_name", columnList = "name"),
    @Index(name = "idx_status", columnList = "status")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Food {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Tên thực phẩm không được để trống")
    @Column(nullable = false, unique = true, length = 255)
    private String name;
    
    @NotNull(message = "Calo không được để trống")
    @Column(nullable = false)
    private Float calories;
    
    @NotNull(message = "Protein không được để trống")
    @Column(nullable = false)
    private Float protein;
    
    @NotNull(message = "Chất béo không được để trống")
    @Column(nullable = false)
    private Float fat;
    
    @NotNull(message = "Carbohydrate không được để trống")
    @Column(nullable = false)
    private Float carbohydrate;
    
    @Column(length = 100)
    private String type;
    
    @Column(length = 255)
    private String foodPhoto;
    
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    @Column(length = 50, nullable = false)
    @Builder.Default
    private String status = "ACTIVE";
    
    // Audit Fields
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    
    @Column(length = 255)
    @JsonProperty("created_by")
    private String createdBy;
    
    @Column(length = 255)
    @JsonProperty("updated_by")
    private String updatedBy;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}







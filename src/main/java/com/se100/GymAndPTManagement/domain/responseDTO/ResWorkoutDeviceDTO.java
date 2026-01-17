package com.se100.GymAndPTManagement.domain.responseDTO;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResWorkoutDeviceDTO {
    private Long id;
    private String name;
    private String type;
    private BigDecimal price;
    private LocalDate dateImported;
    private LocalDate dateMaintenance;
    private String imageUrl;
    private Instant createdAt;
    private Instant updatedAt;
    private String createdBy;
    private String updatedBy;
}

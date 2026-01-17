package com.se100.GymAndPTManagement.domain.requestDTO;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReqUpdateWorkoutDeviceDTO {

    @Size(max = 255, message = "Tên thiết bị không được vượt quá 255 ký tự")
    private String name;

    @Size(max = 100, message = "Loại thiết bị không được vượt quá 100 ký tự")
    private String type;

    private BigDecimal price;

    private LocalDate dateImported;

    private LocalDate dateMaintenance;

    @Size(max = 500, message = "URL hình ảnh không được vượt quá 500 ký tự")
    private String imageUrl;
}
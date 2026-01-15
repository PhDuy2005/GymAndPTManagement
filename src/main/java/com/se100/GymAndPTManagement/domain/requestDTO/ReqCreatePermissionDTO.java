package com.se100.GymAndPTManagement.domain.requestDTO;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request DTO for creating a new Permission
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReqCreatePermissionDTO {

    @NotBlank(message = "Tên permission không được để trống")
    private String name;

    @NotBlank(message = "API path không được để trống")
    private String apiPath;

    @NotBlank(message = "Method không được để trống")
    private String method;

    private String module;
}

package com.se100.GymAndPTManagement.domain.requestDTO;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request DTO for updating an existing Permission
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReqUpdatePermissionDTO {

    @NotNull(message = "ID không được để trống")
    private Long id;

    private String name;

    private String apiPath;

    private String method;

    private String module;
}

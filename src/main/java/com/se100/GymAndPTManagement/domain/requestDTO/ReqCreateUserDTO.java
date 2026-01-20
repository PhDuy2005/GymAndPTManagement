package com.se100.GymAndPTManagement.domain.requestDTO;

import java.time.LocalDate;

import com.se100.GymAndPTManagement.util.enums.GenderEnum;
import com.se100.GymAndPTManagement.util.enums.UserStatusEnum;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request DTO for creating new user
 * Sử dụng cho các user không thuộc Member hoặc PT (ví dụ: Admin)
 * 
 * @author SE100 Team
 * @version 1.0
 * @since 2026-01-20
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReqCreateUserDTO {

    @NotBlank(message = "Fullname không được để trống")
    @Size(max = 100, message = "Fullname không được vượt quá 100 ký tự")
    private String fullname;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không hợp lệ")
    @Size(max = 150, message = "Email không được vượt quá 150 ký tự")
    private String email;

    @Size(min = 8, message = "Password phải có ít nhất 8 ký tự")
    private String password;

    @Size(max = 15, message = "Phone number không được vượt quá 15 ký tự")
    private String phoneNumber;

    @Size(max = 500, message = "Avatar URL không được vượt quá 500 ký tự")
    private String avatarUrl;

    private LocalDate dob;

    private GenderEnum gender;

    private UserStatusEnum status;

    @NotNull(message = "Role name không được để trống")
    @NotBlank(message = "Role name không được để trống")
    private String roleName; // "ADMIN", "MEMBER", "PT"
}

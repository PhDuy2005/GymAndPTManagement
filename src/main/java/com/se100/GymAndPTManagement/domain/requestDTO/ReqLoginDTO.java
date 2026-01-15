package com.se100.GymAndPTManagement.domain.requestDTO;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReqLoginDTO {
    @NotBlank(message = "Không được để trống tên đăng nhập")
    private String username;
    @NotBlank(message = "Không được để trống mật khẩu")
    private String password;
}

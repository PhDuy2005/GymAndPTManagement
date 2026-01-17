package com.se100.GymAndPTManagement.domain.requestDTO;

import com.se100.GymAndPTManagement.util.enums.WorkoutDifficultyEnum;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReqUpdateWorkoutDTO {

    @Size(max = 255, message = "Tên bài tập không được vượt quá 255 ký tự")
    private String name;

    private String description;

    @Min(value = 1, message = "Thời lượng phải lớn hơn 0 phút")
    private Integer duration;

    private WorkoutDifficultyEnum difficulty;

    @Size(max = 100, message = "Loại bài tập không được vượt quá 100 ký tự")
    private String type;
}

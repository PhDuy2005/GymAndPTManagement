package com.se100.GymAndPTManagement.controller;

import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.se100.GymAndPTManagement.domain.requestDTO.ReqCreateWorkoutDTO;
import com.se100.GymAndPTManagement.domain.requestDTO.ReqUpdateWorkoutDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResWorkoutDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResultPaginationDTO;
import com.se100.GymAndPTManagement.service.WorkoutService;
import com.se100.GymAndPTManagement.util.annotation.ApiMessage;
import com.se100.GymAndPTManagement.util.enums.WorkoutDifficultyEnum;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/workouts")
@Tag(name = "Workout Management", description = "APIs for managing workout exercises library")
public class WorkoutController {

    private final WorkoutService workoutService;

    public WorkoutController(WorkoutService workoutService) {
        this.workoutService = workoutService;
    }

    @GetMapping
    @ApiMessage("Lấy danh sách tất cả bài tập")
    @Operation(summary = "Get all workouts", description = "Retrieve all workouts with pagination")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of workouts retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> getAllWorkouts(Pageable pageable) {
        ResultPaginationDTO result = workoutService.handleFetchWorkouts(null, pageable);
        return ResponseEntity.ok(result);
    }

    @PostMapping
    @ApiMessage("Tạo bài tập mới")
    @Operation(summary = "Create new workout", description = "Create a new workout exercise in the library")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Workout created successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid input or workout name already exists")
    })
    public ResponseEntity<ResWorkoutDTO> createWorkout(@Valid @RequestBody ReqCreateWorkoutDTO dto) {
        ResWorkoutDTO createdWorkout = workoutService.createWorkout(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdWorkout);
    }

    @GetMapping("/{id}")
    @ApiMessage("Lấy thông tin bài tập theo ID")
    @Operation(summary = "Get workout by ID", description = "Retrieve workout details by ID")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout found"),
            @ApiResponse(responseCode = "404", description = "Workout not found")
    })
    public ResponseEntity<ResWorkoutDTO> getWorkoutById(@PathVariable("id") Long id) {
        ResWorkoutDTO workout = workoutService.getWorkoutById(id);
        return ResponseEntity.ok(workout);
    }

    @GetMapping("/by-name")
    @ApiMessage("Lấy thông tin bài tập theo tên")
    @Operation(summary = "Get workout by name", description = "Retrieve workout details by exact name")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout found"),
            @ApiResponse(responseCode = "404", description = "Workout not found")
    })
    public ResponseEntity<ResWorkoutDTO> getWorkoutByName(@RequestParam("name") String name) {
        ResWorkoutDTO workout = workoutService.getWorkoutByName(name);
        return ResponseEntity.ok(workout);
    }

    @GetMapping("/search")
    @ApiMessage("Tìm kiếm bài tập theo tên")
    @Operation(summary = "Search workouts by name", description = "Search workouts by name containing the search term (case insensitive)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Search results retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> searchWorkoutsByName(
            @RequestParam String name,
            Pageable pageable) {
        ResultPaginationDTO result = workoutService.searchWorkoutsByName(name, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/by-difficulty/{difficulty}")
    @ApiMessage("Lấy danh sách bài tập theo độ khó")
    @Operation(summary = "Get workouts by difficulty", description = "Retrieve workouts by difficulty level (BEGINNER, INTERMEDIATE, ADVANCED)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of workouts by difficulty retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> getWorkoutsByDifficulty(
            @PathVariable("difficulty") WorkoutDifficultyEnum difficulty,
            Pageable pageable) {
        ResultPaginationDTO result = workoutService.getWorkoutsByDifficulty(difficulty, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/by-type")
    @ApiMessage("Lấy danh sách bài tập theo loại")
    @Operation(summary = "Get workouts by type", description = "Retrieve workouts by exact type (e.g., Cardio, Strength, Flexibility)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of workouts by type retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> getWorkoutsByType(
            @RequestParam("type") String type,
            Pageable pageable) {
        ResultPaginationDTO result = workoutService.getWorkoutsByType(type, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/search-type")
    @ApiMessage("Tìm kiếm bài tập theo loại")
    @Operation(summary = "Search workouts by type", description = "Search workouts by type containing the search term (case insensitive)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Search results retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> searchWorkoutsByType(
            @RequestParam("type") String type,
            Pageable pageable) {
        ResultPaginationDTO result = workoutService.searchWorkoutsByType(type, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/count-by-difficulty/{difficulty}")
    @ApiMessage("Đếm số lượng bài tập theo độ khó")
    @Operation(summary = "Count workouts by difficulty", description = "Get count of workouts by difficulty level")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout count retrieved successfully")
    })
    public ResponseEntity<Long> countWorkoutsByDifficulty(
            @PathVariable("difficulty") WorkoutDifficultyEnum difficulty) {
        long count = workoutService.countWorkoutsByDifficulty(difficulty);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/count-by-type")
    @ApiMessage("Đếm số lượng bài tập theo loại")
    @Operation(summary = "Count workouts by type", description = "Get count of workouts by type")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout count retrieved successfully")
    })
    public ResponseEntity<Long> countWorkoutsByType(@RequestParam("type") String type) {
        long count = workoutService.countWorkoutsByType(type);
        return ResponseEntity.ok(count);
    }

    @PutMapping("/{id}")
    @ApiMessage("Cập nhật thông tin bài tập")
    @Operation(summary = "Update workout", description = "Update workout information")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout updated successfully"),
            @ApiResponse(responseCode = "404", description = "Workout not found"),
            @ApiResponse(responseCode = "400", description = "Invalid input or workout name conflict")
    })
    public ResponseEntity<ResWorkoutDTO> updateWorkout(
            @PathVariable("id") Long id,
            @Valid @RequestBody ReqUpdateWorkoutDTO dto) {
        ResWorkoutDTO updatedWorkout = workoutService.updateWorkout(id, dto);
        return ResponseEntity.ok(updatedWorkout);
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Xóa bài tập")
    @Operation(summary = "Delete workout", description = "Delete a workout from the library")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Workout deleted successfully"),
            @ApiResponse(responseCode = "404", description = "Workout not found")
    })
    public ResponseEntity<Void> deleteWorkout(@PathVariable Long id) {
        workoutService.deleteWorkout(id);
        return ResponseEntity.noContent().build();
    }
}

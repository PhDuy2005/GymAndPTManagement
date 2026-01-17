package com.se100.GymAndPTManagement.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.format.annotation.DateTimeFormat;
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

import com.se100.GymAndPTManagement.domain.requestDTO.ReqCreateWorkoutDeviceDTO;
import com.se100.GymAndPTManagement.domain.requestDTO.ReqUpdateWorkoutDeviceDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResWorkoutDeviceDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResultPaginationDTO;
import com.se100.GymAndPTManagement.domain.table.WorkoutDevice;
import com.se100.GymAndPTManagement.service.WorkoutDeviceService;
import com.se100.GymAndPTManagement.util.annotation.ApiMessage;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/workout-devices")
@Tag(name = "Workout Device Management", description = "APIs for managing gym workout devices and equipment")
public class WorkoutDeviceController {

    private final WorkoutDeviceService workoutDeviceService;

    public WorkoutDeviceController(WorkoutDeviceService workoutDeviceService) {
        this.workoutDeviceService = workoutDeviceService;
    }

    @PostMapping
    @ApiMessage("Tạo thiết bị tập luyện mới")
    @Operation(summary = "Create new workout device", description = "Create a new workout device/equipment in the gym")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Workout device created successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid input or device name already exists")
    })
    public ResponseEntity<ResWorkoutDeviceDTO> createWorkoutDevice(
            @Valid @RequestBody ReqCreateWorkoutDeviceDTO dto) {
        ResWorkoutDeviceDTO createdDevice = workoutDeviceService.createWorkoutDevice(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdDevice);
    }

    @GetMapping("/{id}")
    @ApiMessage("Lấy thông tin thiết bị theo ID")
    @Operation(summary = "Get workout device by ID", description = "Retrieve workout device details by ID")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout device found"),
            @ApiResponse(responseCode = "404", description = "Workout device not found")
    })
    public ResponseEntity<ResWorkoutDeviceDTO> getWorkoutDeviceById(@PathVariable("id") Long id) {
        ResWorkoutDeviceDTO device = workoutDeviceService.getWorkoutDeviceById(id);
        return ResponseEntity.ok(device);
    }

    @GetMapping("/by-name")
    @ApiMessage("Tìm kiếm thiết bị theo tên")
    @Operation(summary = "Search workout devices by name", description = "Search workout devices by name containing the keyword (case insensitive)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of workout devices found")
    })
    public ResponseEntity<List<ResWorkoutDeviceDTO>> searchWorkoutDevicesByName(@RequestParam("name") String name) {
        List<ResWorkoutDeviceDTO> devices = workoutDeviceService.searchWorkoutDevicesByName(name);
        return ResponseEntity.ok(devices);
    }

    @GetMapping("/by-type")
    @ApiMessage("Lấy danh sách thiết bị theo loại")
    @Operation(summary = "Get devices by type", description = "Retrieve workout devices filtered by type")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of devices by type retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> getWorkoutDevicesByType(
            @RequestParam("type") String type,
            Pageable pageable) {
        ResultPaginationDTO result = workoutDeviceService.getWorkoutDevicesByType(type, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/maintenance-required")
    @ApiMessage("Lấy danh sách thiết bị cần bảo trì")
    @Operation(summary = "Get devices requiring maintenance", description = "Retrieve devices that require maintenance before or on specified date")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of devices requiring maintenance retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> getDevicesRequiringMaintenance(
            @RequestParam("beforeDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate beforeDate,
            Pageable pageable) {
        ResultPaginationDTO result = workoutDeviceService.getDevicesRequiringMaintenance(beforeDate, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/imported-after")
    @ApiMessage("Lấy danh sách thiết bị nhập sau ngày cụ thể")
    @Operation(summary = "Get devices imported after date", description = "Retrieve devices imported after a specific date")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List of devices imported after date retrieved successfully")
    })
    public ResponseEntity<ResultPaginationDTO> getDevicesImportedAfter(
            @RequestParam("afterDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate afterDate,
            Pageable pageable) {
        ResultPaginationDTO result = workoutDeviceService.getDevicesImportedAfter(afterDate, pageable);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/count-by-type")
    @ApiMessage("Đếm số lượng thiết bị theo loại")
    @Operation(summary = "Count devices by type", description = "Get count of devices for a specific type")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Device count retrieved successfully")
    })
    public ResponseEntity<Long> countDevicesByType(@RequestParam("type") String type) {
        long count = workoutDeviceService.countDevicesByType(type);
        return ResponseEntity.ok(count);
    }

    @PutMapping("/{id}")
    @ApiMessage("Cập nhật thông tin thiết bị")
    @Operation(summary = "Update workout device", description = "Update workout device information")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Workout device updated successfully"),
            @ApiResponse(responseCode = "404", description = "Workout device not found"),
            @ApiResponse(responseCode = "400", description = "Invalid input or device name conflict")
    })
    public ResponseEntity<ResWorkoutDeviceDTO> updateWorkoutDevice(
            @PathVariable("id") Long id,
            @Valid @RequestBody ReqUpdateWorkoutDeviceDTO dto) {
        ResWorkoutDeviceDTO updatedDevice = workoutDeviceService.updateWorkoutDevice(id, dto);
        return ResponseEntity.ok(updatedDevice);
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Xóa thiết bị")
    @Operation(summary = "Delete workout device", description = "Delete a workout device from the system")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Workout device deleted successfully"),
            @ApiResponse(responseCode = "404", description = "Workout device not found")
    })
    public ResponseEntity<Void> deleteWorkoutDevice(@PathVariable Long id) {
        workoutDeviceService.deleteWorkoutDevice(id);
        return ResponseEntity.noContent().build();
    }
}

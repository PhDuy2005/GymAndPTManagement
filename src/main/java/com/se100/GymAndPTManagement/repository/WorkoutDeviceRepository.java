package com.se100.GymAndPTManagement.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.se100.GymAndPTManagement.domain.table.WorkoutDevice;

@Repository
public interface WorkoutDeviceRepository
        extends JpaRepository<WorkoutDevice, Long>, JpaSpecificationExecutor<WorkoutDevice> {

    // Find by name (exact match)
    Optional<WorkoutDevice> findByName(String name);

    // Search by name (contains keyword, case insensitive)
    List<WorkoutDevice> findByNameContainingIgnoreCase(String name);

    // Check if device exists by name
    boolean existsByName(String name);

    // Find by type
    List<WorkoutDevice> findByType(String type);

    Page<WorkoutDevice> findByType(String type, Pageable pageable);

    // Find devices requiring maintenance (dateMaintenance before or equal to date)
    List<WorkoutDevice> findByDateMaintenanceLessThanEqual(LocalDate date);

    Page<WorkoutDevice> findByDateMaintenanceLessThanEqual(LocalDate date, Pageable pageable);

    // Find devices imported after a specific date
    List<WorkoutDevice> findByDateImportedAfter(LocalDate date);

    Page<WorkoutDevice> findByDateImportedAfter(LocalDate date, Pageable pageable);

    // Count devices by type
    long countByType(String type);
}

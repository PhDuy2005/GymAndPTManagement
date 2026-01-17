package com.se100.GymAndPTManagement.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.se100.GymAndPTManagement.domain.table.Workout;
import com.se100.GymAndPTManagement.util.enums.WorkoutDifficultyEnum;

@Repository
public interface WorkoutRepository extends JpaRepository<Workout, Long>, JpaSpecificationExecutor<Workout> {

    // Find by name (exact match)
    Optional<Workout> findByName(String name);

    // Find by name containing (search)
    List<Workout> findByNameContainingIgnoreCase(String name);

    Page<Workout> findByNameContainingIgnoreCase(String name, Pageable pageable);

    // Check if workout exists by name
    boolean existsByName(String name);

    // Find by difficulty
    List<Workout> findByDifficulty(WorkoutDifficultyEnum difficulty);

    Page<Workout> findByDifficulty(WorkoutDifficultyEnum difficulty, Pageable pageable);

    // Find by type
    List<Workout> findByType(String type);

    Page<Workout> findByType(String type, Pageable pageable);

    // Find by type containing (search)
    List<Workout> findByTypeContainingIgnoreCase(String type);

    Page<Workout> findByTypeContainingIgnoreCase(String type, Pageable pageable);

    // Count by difficulty
    long countByDifficulty(WorkoutDifficultyEnum difficulty);

    // Count by type
    long countByType(String type);
}

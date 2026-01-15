package com.se100.GymAndPTManagement.controller;

import org.springframework.data.domain.Pageable;
import jakarta.validation.Valid;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.se100.GymAndPTManagement.domain.requestDTO.ReqCreateRoleDTO;
import com.se100.GymAndPTManagement.domain.requestDTO.ReqUpdateRoleDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResRoleDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResultPaginationDTO;
import com.se100.GymAndPTManagement.domain.table.Role;
import com.se100.GymAndPTManagement.service.RoleService;
import com.se100.GymAndPTManagement.util.annotation.ApiMessage;
import com.turkraft.springfilter.boot.Filter;

@RestController
@RequestMapping("/api/v1")
public class RoleController {
    private final RoleService roleService;

    public RoleController(RoleService roleService) {
        this.roleService = roleService;
    }

    @PostMapping("/roles")
    @ApiMessage("Create a new role")
    public ResponseEntity<ResRoleDTO> createRole(@Valid @RequestBody ReqCreateRoleDTO request) {
        ResRoleDTO createdRole = roleService.createRole(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdRole);
    }

    @PutMapping("/roles")
    @ApiMessage("Update an existing role")
    public ResponseEntity<ResRoleDTO> updateRole(@Valid @RequestBody ReqUpdateRoleDTO request) {
        ResRoleDTO updatedRole = roleService.updateRole(request);
        return ResponseEntity.ok(updatedRole);
    }

    @GetMapping("/roles")
    @ApiMessage("Fetch roles with filter and pagination")
    public ResponseEntity<ResultPaginationDTO> fetchRolesWithFilterAndPagination(
            @Filter Specification<Role> spec,
            Pageable pageable) {
        ResultPaginationDTO roles = this.roleService.handleGetAllRoles(spec, pageable);
        return ResponseEntity.ok(roles);
    }

    @GetMapping("/roles/{id}")
    @ApiMessage("Fetch role by ID")
    public ResponseEntity<ResRoleDTO> fetchRoleById(@PathVariable("id") Long id) {
        ResRoleDTO role = this.roleService.handleFetchRoleById(id);
        if (role == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(role);
    }

    @DeleteMapping("/roles/{id}")
    @ApiMessage("Delete role by ID")
    public ResponseEntity<Void> deleteRole(@PathVariable("id") Long id) {
        this.roleService.deleteRole(id);
        return ResponseEntity.noContent().build();
    }
}
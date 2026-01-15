package com.se100.GymAndPTManagement.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import com.se100.GymAndPTManagement.domain.responseDTO.ResultPaginationDTO;
import com.se100.GymAndPTManagement.domain.table.Permission;
import com.se100.GymAndPTManagement.repository.PermissionRepository;

@Service
public class PermissionService {
    private final PermissionRepository permissionRepository;

    public PermissionService(PermissionRepository permissionRepository) {
        this.permissionRepository = permissionRepository;
    }

    /**
     * Validates permission parameters and checks if permission already exists in
     * database.
     * 
     * @param apiPath API endpoint path (must start with '/')
     * @param method  HTTP method (GET, POST, PUT, DELETE, PATCH)
     * @param module  Module name
     * @return true if permission exists, false otherwise
     * @throws IllegalArgumentException if any parameter is invalid
     */
    boolean checkPermissionExistsAndValidate(String apiPath, String method, String module) {
        // validate data
        if (apiPath == null || apiPath.isEmpty() || apiPath.charAt(0) != '/')
            throw new IllegalArgumentException("API path must start with '/'");
        if (method == null || method.isEmpty()
                || !List.of("GET", "POST", "PUT", "DELETE", "PATCH").contains(method.toUpperCase()))
            throw new IllegalArgumentException("Method must be one of: GET, POST, PUT, DELETE, PATCH");
        if (module == null || module.isEmpty())
            throw new IllegalArgumentException("Arguments must not be empty");

        if (this.permissionRepository.existsByApiPathAndMethodAndModule(apiPath, method, module))
            return true;
        return false;
    }

    public Permission createPermission(Permission entity) {
        String apiPath = entity.getApiPath();
        String method = entity.getMethod();
        String module = entity.getModule();

        if (this.checkPermissionExistsAndValidate(apiPath, method, module))
            throw new IllegalArgumentException("Permission already exists");
        return permissionRepository.save(entity);
    }

    public ResultPaginationDTO handleGetAllPermissions(Specification<Permission> spec, Pageable pageable) {
        Page<Permission> pagePermissions = this.permissionRepository.findAll(spec, pageable);
        ResultPaginationDTO rs = new ResultPaginationDTO();
        ResultPaginationDTO.Meta meta = new ResultPaginationDTO.Meta();

        meta.setPage(pageable.getPageNumber() + 1);
        meta.setPageSize(pageable.getPageSize());
        meta.setTotalPages(pagePermissions.getTotalPages());
        meta.setTotalItems(pagePermissions.getTotalElements());

        rs.setMeta(meta);
        rs.setResult(pagePermissions.getContent());

        return rs;
    }

    public Permission updatePermission(Permission entity) {
        String apiPath = entity.getApiPath();
        String method = entity.getMethod();
        String module = entity.getModule();

        Permission curPermission = permissionRepository.findById(entity.getId()).orElse(null);

        if (curPermission == null)
            throw new IllegalArgumentException("Permission with id = " + entity.getId() + " does not exist");

        if (this.checkPermissionExistsAndValidate(apiPath, method, module)) {
            if (entity.getName().equals(curPermission.getName()))
                throw new IllegalArgumentException("Permission with the same parameters already exists");
        }

        curPermission.setApiPath(apiPath);
        curPermission.setMethod(method);
        curPermission.setModule(module);
        if (entity.getName() != null)
            curPermission.setName(entity.getName());
        return permissionRepository.save(curPermission);
    }

    public void deletePermission(Long id) {
        if (!permissionRepository.existsById(id))
            throw new IllegalArgumentException("Permission with id " + id + " does not exist");
        Permission curPermission = this.permissionRepository.findById(id).get();
        curPermission.getRoles().forEach(role -> role.getPermissions().remove(curPermission));
        this.permissionRepository.deleteById(id);
    }
}
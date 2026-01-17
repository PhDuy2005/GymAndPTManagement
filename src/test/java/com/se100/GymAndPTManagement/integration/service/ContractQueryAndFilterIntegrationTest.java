package com.se100.GymAndPTManagement.integration.service;

import com.se100.GymAndPTManagement.domain.table.Contract;
import com.se100.GymAndPTManagement.domain.table.Member;
import com.se100.GymAndPTManagement.domain.table.PersonalTrainer;
import com.se100.GymAndPTManagement.domain.table.ServicePackage;
import com.se100.GymAndPTManagement.util.enums.ContractStatusEnum;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Contract Query and Filter Integration Tests
 * Tests for filtering, pagination, and query operations.
 */
@DisplayName("Contract Query and Filter Integration Tests")
public class ContractQueryAndFilterIntegrationTest extends ContractIntegrationTestBase {

    // ==================== BASIC QUERIES ====================

    @Test
    @DisplayName("Test 1: Get all contracts")
    public void testGetAllContracts() {
        // Given
        Contract contract1 = createContract(testMember, testPackage);
        Member member2 = createMember();
        Contract contract2 = createContract(member2, testPackage);

        // When
        var allContracts = contractRepository.findAll();

        // Then
        assertTrue(allContracts.size() >= 2);
    }

    @Test
    @DisplayName("Test 2: Get contract by ID")
    public void testGetContractById() {
        // Given
        Contract created = createContract(testMember, testPackage);

        // When
        var retrieved = contractRepository.findById(created.getId());

        // Then
        assertTrue(retrieved.isPresent());
        assertEquals(created.getId(), retrieved.get().getId());
    }

    @Test
    @DisplayName("Test 3: Get non-existent contract returns empty")
    public void testGetNonExistentContract() {
        // When
        var retrieved = contractRepository.findById(99999L);

        // Then
        assertFalse(retrieved.isPresent());
    }

    // ==================== MEMBER FILTERS ====================

    @Test
    @DisplayName("Test 4: Get contracts by member ID")
    public void testGetContractsByMember() {
        // Given
        Contract contract1 = createContract(testMember, testPackage);
        ServicePackage package2 = createServicePackage();
        Contract contract2 = createContract(testMember, package2);
        Member otherMember = createMember();
        Contract contract3 = createContract(otherMember, testPackage);

        // When
        List<Contract> memberContracts = contractRepository.findByMemberId(testMember.getId());

        // Then
        assertEquals(2, memberContracts.size());
        assertTrue(memberContracts.stream().allMatch(c -> c.getMember().getId().equals(testMember.getId())));
    }

    @Test
    @DisplayName("Test 5: Get contracts by member returns empty if no contracts")
    public void testGetContractsByMemberEmpty() {
        // Given
        Member memberWithoutContracts = createMember();

        // When
        List<Contract> contracts = contractRepository.findByMemberId(memberWithoutContracts.getId());

        // Then
        assertTrue(contracts.isEmpty());
    }

    // ==================== STATUS FILTERS ====================

    @Test
    @DisplayName("Test 6: Get contracts by status - ACTIVE")
    public void testGetContractsByStatusActive() {
        // Given
        Contract active1 = createContract(testMember, testPackage);
        Contract active2 = createContract(createMember(), testPackage);
        
        // Create expired contract
        Contract expired = createContract(createMember(), testPackage);
        expired.setStatus(ContractStatusEnum.EXPIRED);
        contractRepository.save(expired);

        // When
        List<Contract> activeContracts = contractRepository.findByStatus(ContractStatusEnum.ACTIVE);

        // Then
        assertTrue(activeContracts.size() >= 2);
        assertTrue(activeContracts.stream().allMatch(c -> c.getStatus() == ContractStatusEnum.ACTIVE));
    }

    @Test
    @DisplayName("Test 7: Get contracts by status - EXPIRED")
    public void testGetContractsByStatusExpired() {
        // Given
        Contract expired1 = createContract(testMember, testPackage);
        expired1.setStatus(ContractStatusEnum.EXPIRED);
        contractRepository.save(expired1);

        Contract active = createContract(createMember(), testPackage);

        // When
        List<Contract> expiredContracts = contractRepository.findByStatus(ContractStatusEnum.EXPIRED);

        // Then
        assertTrue(expiredContracts.size() >= 1);
        assertTrue(expiredContracts.stream().allMatch(c -> c.getStatus() == ContractStatusEnum.EXPIRED));
    }

    @Test
    @DisplayName("Test 8: Get contracts by status - CANCELLED")
    public void testGetContractsByStatusCancelled() {
        // Given
        Contract cancelled1 = createContract(testMember, testPackage);
        cancelled1.setStatus(ContractStatusEnum.CANCELLED);
        contractRepository.save(cancelled1);

        Contract active = createContract(createMember(), testPackage);

        // When
        List<Contract> cancelledContracts = contractRepository.findByStatus(ContractStatusEnum.CANCELLED);

        // Then
        assertTrue(cancelledContracts.stream()
                .allMatch(c -> c.getStatus() == ContractStatusEnum.CANCELLED));
    }

    // ==================== PT FILTERS ====================

    @Test
    @DisplayName("Test 9: Get contracts by PT")
    public void testGetContractsByPT() {
        // Given
        Contract contractWithPT = createContractWithPT(testMember, testPackage, testPT);
        PersonalTrainer otherPT = createAdditionalPersonalTrainer();
        Contract contractWithOtherPT = createContractWithPT(createMember(), testPackage, otherPT);
        Contract contractNoPT = createContract(createMember(), testPackage);

        // When
        List<Contract> ptContracts = contractRepository.findByMainPtId(testPT.getId());

        // Then
        assertTrue(ptContracts.size() >= 1);
        assertTrue(ptContracts.stream().allMatch(c -> c.getMainPt() != null && 
                                                      c.getMainPt().getId().equals(testPT.getId())));
    }

    @Test
    @DisplayName("Test 10: Get contracts by PT with status filter")
    public void testGetContractsByPTAndStatus() {
        // Given
        Contract contractActive = createContractWithPT(testMember, testPackage, testPT);
        
        Contract contractExpired = createContractWithPT(createMember(), testPackage, testPT);
        contractExpired.setStatus(ContractStatusEnum.EXPIRED);
        contractRepository.save(contractExpired);

        // When
        List<Contract> activeContracts = contractRepository.findByMainPtId(testPT.getId());

        // Then
        assertTrue(activeContracts.size() >= 1);
        assertTrue(activeContracts.stream().allMatch(c -> c.getMainPt().getId().equals(testPT.getId())));
    }
}

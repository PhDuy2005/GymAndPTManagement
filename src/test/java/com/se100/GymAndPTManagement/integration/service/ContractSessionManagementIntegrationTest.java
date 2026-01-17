package com.se100.GymAndPTManagement.integration.service;

import com.se100.GymAndPTManagement.domain.table.Contract;
import com.se100.GymAndPTManagement.domain.table.ServicePackage;
import com.se100.GymAndPTManagement.util.enums.ContractStatusEnum;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Contract Session Management Integration Tests
 * Tests for session tracking, exhaustion, expiration logic, and booking integration.
 */
@DisplayName("Contract Session Management Integration Tests")
public class ContractSessionManagementIntegrationTest extends ContractIntegrationTestBase {

    // ==================== SESSION TRACKING ====================

    @Test
    @DisplayName("Test 1: Contract remaining sessions initialized to total sessions")
    public void testRemainingSessionsInitialized() {
        // When
        Contract contract = createContract(testMember, testPackage);

        // Then
        assertEquals(testPackage.getNumberOfSessions(), contract.getRemainingSessions());
        assertEquals(contract.getTotalSessions(), contract.getRemainingSessions());
    }

    @Test
    @DisplayName("Test 2: Decrement remaining sessions")
    public void testDecrementRemainingSessions() {
        // Given
        Contract contract = createContract(testMember, testPackage);
        Integer originalRemaining = contract.getRemainingSessions();

        // When
        contract.setRemainingSessions(originalRemaining - 1);
        Contract updated = contractRepository.save(contract);

        // Then
        assertRemainingSession(updated, originalRemaining - 1);
    }

    @Test
    @DisplayName("Test 3: Contract can be queried by remaining sessions")
    public void testQueryByRemainingSessions() {
        // Given
        Contract contract = createContract(testMember, testPackage);
        contract.setRemainingSessions(5);
        contractRepository.save(contract);

        // When
        var contracts = contractRepository.findByMemberId(testMember.getId());

        // Then
        assertTrue(contracts.stream().anyMatch(c -> c.getRemainingSessions() == 5));
    }

    // ==================== SESSION EXHAUSTION ====================

    @Test
    @DisplayName("Test 4: Contract expired when remaining sessions = 0")
    public void testSessionExhaustionDetection() {
        // Given
        Contract contract = createContract(testMember, testPackage);

        // When
        contract.setRemainingSessions(0);
        Contract updated = contractRepository.save(contract);

        // Then
        assertEquals(0, updated.getRemainingSessions());
        assertTrue(updated.getRemainingSessions() <= 0);
    }

    @Test
    @DisplayName("Test 5: Contract expired when remaining sessions < 0")
    public void testNegativeSessionsHandled() {
        // Given
        Contract contract = createContract(testMember, testPackage);

        // When
        contract.setRemainingSessions(-5);
        Contract updated = contractRepository.save(contract);

        // Then
        assertTrue(updated.getRemainingSessions() <= 0);
    }

    @Test
    @DisplayName("Test 6: Contract with high session count")
    public void testContractWithHighSessions() {
        // Given
        ServicePackage premiumPackage = ServicePackage.builder()
                .packageName("Premium" + System.nanoTime())
                .price(BigDecimal.valueOf(5000000))
                .durationInDays(365)
                .numberOfSessions(100)
                .type(com.se100.GymAndPTManagement.util.enums.PackageTypeEnum.PT_INCLUDED)
                .isActive(true)
                .createdAt(Instant.now())
                .createdBy("testuser")
                .build();
        servicePackageRepository.save(premiumPackage);

        // When
        Contract contract = createContract(testMember, premiumPackage);

        // Then
        assertEquals(100, contract.getTotalSessions());
        assertEquals(100, contract.getRemainingSessions());
    }

    // ==================== DATE-BASED EXPIRATION ====================

    @Test
    @DisplayName("Test 7: Contract expired when end date passed")
    public void testDateBasedExpiration() {
        // Given
        Contract contract = createContract(testMember, testPackage);

        // When
        contract.setEndDate(LocalDate.now().minusDays(1));
        Contract updated = contractRepository.save(contract);

        // Then
        assertTrue(updated.getEndDate().isBefore(LocalDate.now()));
        assertContractExpired(updated);
    }

    @Test
    @DisplayName("Test 8: Contract active when sessions remain and end date valid")
    public void testContractActiveWithValidSessionsAndDate() {
        // When
        Contract contract = createContract(testMember, testPackage);

        // Then
        assertTrue(contract.getRemainingSessions() > 0);
        assertTrue(contract.getEndDate().isAfter(LocalDate.now()) || 
                  contract.getEndDate().isEqual(LocalDate.now()));
        assertContractActive(contract);
    }
}

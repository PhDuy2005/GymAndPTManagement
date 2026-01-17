package com.se100.GymAndPTManagement.integration.service;

import com.se100.GymAndPTManagement.domain.table.*;
import com.se100.GymAndPTManagement.util.enums.ContractStatusEnum;
import com.se100.GymAndPTManagement.util.enums.PackageTypeEnum;
import com.se100.GymAndPTManagement.util.enums.PTStatusEnum;
import com.se100.GymAndPTManagement.repository.*;
import com.se100.GymAndPTManagement.service.ContractService;
import com.se100.GymAndPTManagement.service.InvoiceService;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.HashSet;

/**
 * Base class for Contract integration tests with injected repositories and services.
 * Provides test data factory methods and assertion helpers.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
public abstract class ContractIntegrationTestBase {

    @Autowired
    protected ContractRepository contractRepository;

    @Autowired
    protected ContractService contractService;

    @Autowired
    protected MemberRepository memberRepository;

    @Autowired
    protected PersonalTrainerRepository personalTrainerRepository;

    @Autowired
    protected ServicePackageRepository servicePackageRepository;

    @Autowired
    protected InvoiceRepository invoiceRepository;

    @Autowired
    protected InvoiceDetailRepository invoiceDetailRepository;

    @Autowired
    protected UserRepository userRepository;

    @Autowired
    protected InvoiceService invoiceService;

    protected User testUser;
    protected User testPTUser;
    protected Member testMember;
    protected PersonalTrainer testPT;
    protected ServicePackage testPackage;

    private static int memberCounter = 0;
    private static int ptCounter = 0;
    private static int packageCounter = 0;
    private static int userCounter = 0;

    @BeforeEach
    public void setupTestData() {
        // Create test user for member
        testUser = User.builder()
                .email("member_" + System.nanoTime() + "@example.com")
                .fullname("Test Member User")
                .phoneNumber("0123456789")
                .passwordHash("hashed_password")
                .build();
        userRepository.save(testUser);

        // Create separate test user for PT (due to OneToOne unique constraint)
        testPTUser = User.builder()
                .email("pt_" + System.nanoTime() + "@example.com")
                .fullname("Test PT User")
                .phoneNumber("0987654321")
                .passwordHash("hashed_password")
                .build();
        userRepository.save(testPTUser);

        // Create test member
        testMember = createMember();

        // Create test PT
        testPT = createPersonalTrainer();

        // Create test service package
        testPackage = createServicePackage();
    }

    /**
     * Factory method to create test member with unique CCCD and its own User
     */
    protected Member createMember() {
        memberCounter++;
        // Create a unique user for this member (due to OneToOne unique constraint)
        User memberUser = User.builder()
                .email("member_" + System.nanoTime() + "_" + memberCounter + "@example.com")
                .fullname("Test Member " + memberCounter)
                .phoneNumber("010" + String.format("%07d", memberCounter))
                .passwordHash("hashed_password")
                .build();
        userRepository.save(memberUser);

        Member member = Member.builder()
                .user(memberUser)
                .cccd(String.format("%012d", 100000000000L + memberCounter))
                .moneySpent(BigDecimal.ZERO)
                .moneyDebt(BigDecimal.ZERO)
                .joinDate(LocalDate.now())
                .build();
        return memberRepository.save(member);
    }

    /**
     * Factory method to create test personal trainer
     */
    protected PersonalTrainer createPersonalTrainer() {
        ptCounter++;
        PersonalTrainer pt = PersonalTrainer.builder()
                .user(testPTUser)
                .specialization("Weight Training")
                .experienceYears(5)
                .about("Expert in strength training")
                .certifications("NASM Certified")
                .status(PTStatusEnum.AVAILABLE)
                .createdAt(Instant.now())
                .createdBy("testuser")
                .build();
        return personalTrainerRepository.save(pt);
    }

    /**
     * Factory method to create additional personal trainer with its own User
     */
    protected PersonalTrainer createAdditionalPersonalTrainer() {
        ptCounter++;
        // Create a unique user for this PT (due to OneToOne unique constraint)
        User ptUser = User.builder()
                .email("pt_" + System.nanoTime() + "_" + ptCounter + "@example.com")
                .fullname("Test PT " + ptCounter)
                .phoneNumber("020" + String.format("%07d", ptCounter))
                .passwordHash("hashed_password")
                .build();
        userRepository.save(ptUser);

        PersonalTrainer pt = PersonalTrainer.builder()
                .user(ptUser)
                .specialization("Cardio Training")
                .experienceYears(3)
                .about("Expert in cardio exercises")
                .certifications("CPT Certified")
                .status(PTStatusEnum.AVAILABLE)
                .createdAt(Instant.now())
                .createdBy("testuser")
                .build();
        return personalTrainerRepository.save(pt);
    }

    /**
     * Factory method to create test service package with unique name
     */
    protected ServicePackage createServicePackage() {
        packageCounter++;
        ServicePackage pkg = ServicePackage.builder()
                .packageName("Package" + packageCounter)
                .price(BigDecimal.valueOf(1000000))
                .durationInDays(30)
                .numberOfSessions(10)
                .type(PackageTypeEnum.PT_INCLUDED)
                .isActive(true)
                .description("Test Package")
                .createdAt(Instant.now())
                .createdBy("testuser")
                .build();
        return servicePackageRepository.save(pkg);
    }

    /**
     * Factory method to create contract with default values
     */
    protected Contract createContract(Member member, ServicePackage pkg) {
        Contract contract = Contract.builder()
                .member(member)
                .servicePackage(pkg)
                .startDate(LocalDate.now())
                .endDate(LocalDate.now().plusDays(pkg.getDurationInDays()))
                .totalSessions(pkg.getNumberOfSessions())
                .remainingSessions(pkg.getNumberOfSessions())
                .status(ContractStatusEnum.ACTIVE)
                .notes("Test contract")
                .signedAt(Instant.now())
                .createdAt(Instant.now())
                .createdBy("testuser")
                .build();
        return contractRepository.save(contract);
    }

    /**
     * Factory method to create contract with PT
     */
    protected Contract createContractWithPT(Member member, ServicePackage pkg, PersonalTrainer pt) {
        Contract contract = Contract.builder()
                .member(member)
                .servicePackage(pkg)
                .mainPt(pt)
                .startDate(LocalDate.now())
                .endDate(LocalDate.now().plusDays(pkg.getDurationInDays()))
                .totalSessions(pkg.getNumberOfSessions())
                .remainingSessions(pkg.getNumberOfSessions())
                .status(ContractStatusEnum.ACTIVE)
                .notes("Test contract with PT")
                .signedAt(Instant.now())
                .createdAt(Instant.now())
                .createdBy("testuser")
                .build();
        return contractRepository.save(contract);
    }

    // ==================== ASSERTION HELPERS ====================

    /**
     * Assert contract has expected status
     */
    protected void assertContractStatus(Contract contract, ContractStatusEnum expectedStatus) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        assert contract.getStatus() == expectedStatus : 
            "Expected status " + expectedStatus + " but got " + contract.getStatus();
    }

    /**
     * Assert contract has expected remaining sessions
     */
    protected void assertRemainingSession(Contract contract, Integer expected) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        assert contract.getRemainingSessions().equals(expected) :
            "Expected " + expected + " sessions but got " + contract.getRemainingSessions();
    }

    /**
     * Assert contract has expected end date
     */
    protected void assertContractEndDate(Contract contract, LocalDate expectedDate) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        assert contract.getEndDate().equals(expectedDate) :
            "Expected end date " + expectedDate + " but got " + contract.getEndDate();
    }

    /**
     * Assert contract is expired
     */
    protected void assertContractExpired(Contract contract) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        boolean isExpired = contract.getEndDate().isBefore(LocalDate.now()) || 
                          contract.getRemainingSessions() <= 0;
        assert isExpired : "Contract should be expired but is active";
    }

    /**
     * Assert contract is not expired
     */
    protected void assertContractActive(Contract contract) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        boolean isExpired = contract.getEndDate().isBefore(LocalDate.now()) || 
                          contract.getRemainingSessions() <= 0;
        assert !isExpired : "Contract should be active but is expired";
    }

    /**
     * Assert invoice was auto-generated for contract
     */
    protected void assertInvoiceCreated(Contract contract) {
        var invoices = invoiceRepository.findByMemberId(contract.getMember().getId());
        assert !invoices.isEmpty() : "No invoice created for contract";
    }

    /**
     * Assert invoice total matches contract amount minus discount
     */
    protected void assertInvoiceAmount(Contract contract, BigDecimal expectedTotal) {
        var invoices = invoiceRepository.findByMemberId(contract.getMember().getId());
        assert !invoices.isEmpty() : "No invoice found";
        var invoice = invoices.get(0);
        assert invoice.getTotalAmount().equals(expectedTotal) :
            "Expected total " + expectedTotal + " but got " + invoice.getTotalAmount();
    }

    /**
     * Assert contract has PT assigned
     */
    protected void assertContractHasPT(Contract contract, PersonalTrainer expectedPT) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        assert contract.getMainPt() != null : "PT should be assigned";
        assert contract.getMainPt().getId().equals(expectedPT.getId()) :
            "Expected PT " + expectedPT.getId() + " but got " + contract.getMainPt().getId();
    }

    /**
     * Assert contract has no PT assigned
     */
    protected void assertContractNoPT(Contract contract) {
        contract = contractRepository.findById(contract.getId()).orElseThrow();
        assert contract.getMainPt() == null : "PT should not be assigned";
    }
}

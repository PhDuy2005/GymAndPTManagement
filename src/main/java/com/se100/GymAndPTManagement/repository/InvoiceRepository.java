package com.se100.GymAndPTManagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.se100.GymAndPTManagement.domain.table.Invoice;
import java.util.List;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    
    /**
     * Find all invoices for a member
     * Used in InvoiceService.getInvoicesByMemberId() and InvoiceController
     */
    List<Invoice> findByMemberId(Long memberId);
}

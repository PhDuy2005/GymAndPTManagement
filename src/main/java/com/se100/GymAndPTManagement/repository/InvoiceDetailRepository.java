package com.se100.GymAndPTManagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.se100.GymAndPTManagement.domain.table.InvoiceDetail;
import java.util.List;

@Repository
public interface InvoiceDetailRepository extends JpaRepository<InvoiceDetail, Long> {
    
    /**
     * Find all details for an invoice
     * Used in InvoiceService to retrieve invoice line items and InvoiceController
     */
    List<InvoiceDetail> findByInvoiceId(Long invoiceId);
}

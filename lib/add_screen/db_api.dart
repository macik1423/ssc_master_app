import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview/models/invoice_dto.dart';

abstract class DbApi {
  Future<void> addInvoice(InvoiceDto invoiceDto);
  Future<QuerySnapshot> getAllInvoices();
}

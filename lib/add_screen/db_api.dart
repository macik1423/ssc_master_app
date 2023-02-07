import 'package:interview/models/invoice_dto.dart';

abstract class DbApi {
  Future<void> addInvoice(InvoiceDto invoiceDto);
}

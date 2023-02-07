import 'package:interview/add_screen/db_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interview/models/invoice_dto.dart';

class CloudDb implements DbApi {
  final CollectionReference invoice =
      FirebaseFirestore.instance.collection('invoice');

  @override
  Future<void> addInvoice(InvoiceDto invoiceDto) {
    return invoice.add(invoiceDto.toJson());
  }
}

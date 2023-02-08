import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview/add_screen/db_api.dart';
import 'package:interview/models/invoice_dto.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key, required this.db}) : super(key: key);
  final DbApi db;
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: widget.db.getAllInvoices(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          final List<InvoiceDto> invoices = documents
              .map((e) => InvoiceDto.fromJson(e.data() as Map<String, dynamic>))
              .toList();
          return ListView(
            children: invoices
                .map(
                  (e) => Card(
                    child: ListTile(
                      title: Text(e.invoiceNumber),
                    ),
                  ),
                )
                .toList(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

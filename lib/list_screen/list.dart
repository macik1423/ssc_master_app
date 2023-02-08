import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview/add_screen/db_api.dart';
import 'package:interview/models/invoice_dto.dart';

enum Menu {
  edit('Edytuj'),
  remove('Usun');

  final String label;

  const Menu(this.label);
}

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
                      leading: Text(e.invoiceNumber),
                      title: Text(e.contractorName),
                      subtitle: Text('${e.netWorth}'),
                      trailing: PopupMenuButton<Menu>(
                        onSelected: (Menu choice) {
                          return handleMoreVert(
                            choice,
                          );
                        },
                        child: const Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<Menu>>[
                            PopupMenuItem(
                              value: Menu.edit,
                              child: Row(
                                children: [
                                  const Icon(
                                    IconData(0xef8d,
                                        fontFamily: 'MaterialIcons'),
                                  ),
                                  Text(' ${Menu.edit.label}'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: Menu.remove,
                              child: Row(
                                children: [
                                  const Icon(
                                    IconData(0xf0fe,
                                        fontFamily: 'MaterialIcons'),
                                  ),
                                  Text(' ${Menu.remove.label}'),
                                ],
                              ),
                            )
                          ];
                        },
                      ),
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

  void handleMoreVert(Menu choice) {
    switch (choice) {
      case Menu.edit:
        break;
      case Menu.remove:
        break;
    }
  }
}

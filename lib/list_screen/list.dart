import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interview/add_screen/db_api.dart';
import 'package:interview/list_screen/edit_screen.dart';
import 'package:interview/models/invoice_dto.dart';
import 'package:provider/provider.dart';

import '../add_screen/provider/form_state.dart';

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
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Text(invoices.elementAt(index).invoiceNumber),
                  title: Text(invoices.elementAt(index).contractorName),
                  subtitle: Text('${invoices.elementAt(index).netWorth}'),
                  trailing: PopupMenuButton<Menu>(
                    onSelected: (Menu choice) {
                      return handleMoreVert(
                        choice,
                        invoices.elementAt(index),
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
                                IconData(0xef8d, fontFamily: 'MaterialIcons'),
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
                                IconData(0xf0fe, fontFamily: 'MaterialIcons'),
                              ),
                              Text(' ${Menu.remove.label}'),
                            ],
                          ),
                        )
                      ];
                    },
                  ),
                ),
              );
            },
            itemCount: invoices.length,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void handleMoreVert(Menu choice, InvoiceDto invoice) {
    switch (choice) {
      case Menu.edit:
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            context.read<FormModel>().setEdit(invoice);
            return const EditScreen();
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
        );
        break;
      case Menu.remove:
        break;
    }
  }
}

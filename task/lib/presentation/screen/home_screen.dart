import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task/dependency_injection.dart';
import 'package:task/domain/model/email.dart';
import 'package:task/presentation/route/route_generator.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailList = ref.watch(emailNotifierProvider).getEmails();

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: emailList.isNotEmpty ? Alignment.topCenter : Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: emailList.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Iznos'), numeric: true),
                      ],
                      rows: _addDataRows(emailList),
                    )
                  : Text('Trenutno nema podataka', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RouteGenerator.sendMailScreen,
          arguments: {'showGoogleMaps': false},
        ),
        child: const Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  DataRow _createRow(final String email, final double price) {
    return DataRow(
      cells: [
        DataCell(
          Text(email),
        ),
        DataCell(Text(price.toString()))
      ],
    );
  }

  List<DataRow> _addDataRows(final List<Email> emails) {
    List<DataRow> tempList = [];
    emails.map((email) {
      for (var element in email.recipient) {
        tempList.add(_createRow(element, email.price));
      }
    }).toList();
    return tempList;
  }
}

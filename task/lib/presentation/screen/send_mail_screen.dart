import 'dart:io';

import 'package:choose_input_chips/choose_input_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task/dependency_injection.dart';
import 'package:task/presentation/util/dialog_util.dart';
import 'package:task/presentation/widget/loading_indicator_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SendMailScreen extends HookConsumerWidget {
  final bool showGoogleMaps;
  const SendMailScreen({super.key, required this.showGoogleMaps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceController = useTextEditingController();
    final messageController = useTextEditingController();
    File? image = ref.watch(emailNotifierProvider).cachedImage;
    List<String> recipients = [];

    const mockEmails = <String>['mac.steuber@ethereal.email', 'a@a.com', 'b@b.com'];

    return Scaffold(
      appBar: AppBar(
          elevation: 2,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'Sastavi',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(emailNotifierProvider).getImage();
              },
              icon: const Icon(Icons.attachment),
            ),
            IconButton(
              onPressed: () {
                sendEmail(
                  ref,
                  context,
                  recipients,
                  priceController.text,
                  messageController.text,
                );
              },
              icon: const Icon(Icons.send),
            )
          ]),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
          child: Column(
            children: [
              SingleChildScrollView(
                child: ChipsInput(
                  allowChipEditing: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Primatelj',
                  ),
                  findSuggestions: (String query) {
                    if (query.isNotEmpty) {
                      var lowercaseQuery = query.toLowerCase();
                      return mockEmails.where((email) {
                        return email.toLowerCase().contains(query.toLowerCase());
                      }).toList(growable: false)
                        ..sort((a, b) => a
                            .toLowerCase()
                            .indexOf(lowercaseQuery)
                            .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
                    }
                    return mockEmails;
                  },
                  onChanged: (data) {
                    recipients = data;
                  },
                  chipBuilder: (context, state, email) {
                    return InputChip(
                      label: Text(email),
                      onDeleted: () => state.deleteChip(email),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  },
                  suggestionBuilder: (context, state, email) {
                    return ListTile(
                      title: Text(email),
                      onTap: () => state.selectSuggestion(email),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Iznos',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(flex: 3, child: Text('EUR'))
                ],
              ),
              const SizedBox(height: 10),
              !showGoogleMaps
                  ? Expanded(
                      child: TextField(
                        controller: messageController,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Poruka',
                          alignLabelWithHint: true,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    )
                  : const Expanded(child: GoogleMapWidget()),
              image != null ? Expanded(child: Image.file(image)) : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void validate() {}

  Future<void> sendEmail(
    final WidgetRef ref,
    final BuildContext context,
    final List<String> recipients,
    final String price,
    final String message,
  ) async {
    try {
      LoadingIndicatorDialog().show(context);
      await ref.read(emailNotifierProvider).sendEmail(
            recipients: recipients,
            price: double.parse(price),
            message: message,
          );
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss(context);
        Navigator.of(context).pop();
      }
    } catch (_) {
      await DialogUtil.showErrorDialog(
        context,
        'Pogreška',
        'Došlo je do pogreške, molim Vas pokušajte ponovno',
      );
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss(context);
      }
    }
  }
}

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(46, 16),
      ),
    );
  }
}

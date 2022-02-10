import 'package:flutter/material.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({Key? key}) : super(key: key);

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(S.of(context).note),
      body: const Text('434'),
    );
  }
}

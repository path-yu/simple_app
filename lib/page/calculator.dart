import 'package:flutter/material.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBaseAppBar(S.of(context).calculator),
        body: Container(
          child: Text('34'),
        ));
  }
}

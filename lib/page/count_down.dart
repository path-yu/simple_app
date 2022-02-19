import 'package:flutter/material.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({Key? key}) : super(key: key);

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(title: S.of(context).countDown),
      body: Center(
        child: Text('count_down'),
      ),
    );
  }
}

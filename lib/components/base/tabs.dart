import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/generated/l10n.dart';

import '../../common/Color.dart';
import '../../page/setting_page.dart';
import '../../page/tool_kit_page.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final tabsList = [
    const ToolKitPage(),
    const SettingPage(),
  ];
  //
  int currentIndex = 0;
  late Widget currentPage;

  @override
  void initState() {
    currentPage = tabsList[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomTabsList = [
      BottomNavigationBarItem(
          icon: const Icon(
            Icons.toc_outlined,
          ),
          label: S.of(context).toolKit),
      BottomNavigationBarItem(
          icon: const Icon(
            CupertinoIcons.settings,
          ),
          label: S.of(context).setting),
    ];
    //设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(375, 750),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 245, 245, 0.5),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabsList,
        selectedItemColor: themeColor,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabsList[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}

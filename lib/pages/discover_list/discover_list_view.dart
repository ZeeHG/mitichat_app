import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'discover_list_logic.dart';

class DiscoverListPage extends StatelessWidget {
  DiscoverListPage({super.key});

  final DiscoverListLogic logic = Get.put(DiscoverListLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.c_FFFFFF,
      body: SingleChildScrollView(
        child: Column(
          children: [Text("发现")],
        ),
      ),
    );
    ;
  }
}

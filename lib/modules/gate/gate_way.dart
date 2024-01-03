import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shovving_web/modules/gate/gate_way_controller.dart';

class GateWay extends StatelessWidget {
  const GateWay({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GateWayController>(
      init: GateWayController(),
      builder: (GetxController controller) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/ui_helper/icon_path/common_icon_path.dart';

Widget myIndicator(){
  return Container(width: 390*screenRatio, height: Get.height,
    color: Colors.black.withOpacity(0.5),
    child: const Center(
      child: SizedBox(
          child: CircularProgressIndicator(),
          // child: RiveAnimation.asset(RivePath.myIndicator)
      ),
    ),
  );
}

class IndicatorController extends GetxController{
  bool isLoading = false;

  nowLoading(){
    isLoading = true;
    update();
  }
  completeLoading(){
    isLoading = false;
    update();
  }
}
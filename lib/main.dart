import 'dart:html';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shovving_web/modules/gate/gate_way.dart';
import 'package:shovving_web/modules/poll/poll_controller.dart';
import 'package:shovving_web/util/indicator/indicator.dart';
import 'package:shovving_web/util/safe_print.dart';
import 'modules/app_store_screen.dart';
import 'modules/poll/poll_deleted_screen.dart';
import 'package:encrypt/encrypt.dart' as en;

double screenRatio =  isMobile?Get.width/390:475/390;


bool isMobile = false;

Future<void> main() async {

  if (window.location.hostname == "shovving-pre.web.app" ||
      window.location.hostname == "shovving-pre.firebaseapp.com") {
    window.location.href = 'https://naemonemon.com';
  }


  usePathUrlStrategy();
  await GetStorage.init();
  final box = GetStorage();

  String baseUrl = Uri.base.toString(); //get complete url
  String? pollId;
  String? originText = Uri.base.queryParameters["pollId"];

    if(originText!=null){
      final key = en.Key.fromUtf8('dhrmeoduqntjwlwl');
      final iv = en.IV.fromLength(16);
      final encrypter = en.Encrypter(AES(key));
      final text = encrypter.decrypt64(originText, iv: iv);

      pollId = text;
      mainController.setPollId(pollId);
    }else{
      safePrint('파라미터 null');
      mainController.setPollId('-2');
    }

    ///디버그 코드
  //mainController.setPollId('122');

  final deviceInfoPlugin = DeviceInfoPlugin();
  final webInfo = await deviceInfoPlugin.webBrowserInfo;
  String userAgent = webInfo.userAgent??'';
  isMobile = userAgent.contains('Mobile') || userAgent.contains('Android');

  runApp(MyApp(pollId: mainController.pollId.toString()));
}

final indicatorController = Get.put(IndicatorController(), permanent: true);
final mainController = Get.put(MainController(),permanent: true);
final pollController = Get.put(PollController(),permanent: true);

class MyApp extends StatelessWidget {
   const MyApp({super.key, required this.pollId,});

   final String? pollId;


  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (BuildContext context) {
        return  GetMaterialApp(
          home: pollId==null?const PollDeletedScreen():pollId=='-2'?const AppStoreScreen():const GateWay(),
        );
      },
      maximumSize: const Size(475.0, 812.0),
    );
  }
}


class MainController extends GetxController{

  int? pollId;

  setPollId(String? id){
    if(id!=null){

      pollId = int.parse(id);

    }
  }

}

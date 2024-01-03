import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/modules/gate/gate_way_repository.dart';
import 'package:shovving_web/modules/poll/poll_deleted_screen.dart';
import 'package:shovving_web/modules/poll/poll_detail/poll_detail_screen.dart';
import 'package:shovving_web/util/safe_print.dart';

class GateWayController extends GetxController{
  @override
  void onInit() {
    pollId = mainController.pollId;
    pollId ??= -1;
    safePrint(pollId);
    getPollData();
    super.onInit();
  }

  PollRepository pollRepository = PollRepository();
  int? pollId;

  getPollData() async {
    if(pollId!=null){
      final deviceInfoPlugin = DeviceInfoPlugin();
      final webInfo = await deviceInfoPlugin.webBrowserInfo;
      String? deviceToken = webInfo.userAgent?.replaceAll('/', '').replaceAll(' ', '').replaceAll(',', '-');

      Poll? getData = await pollRepository.getPollById(pollId!);

      pollController.setPollData(getData);

      safePrint('뭐여');
      safePrint(pollController.pollData!=null);


      if(pollController.pollData!=null){
          Get.offAll(const PollDetailScreen());
      }else{
        Get.offAll(const PollDeletedScreen());
      }




    }
  }
}

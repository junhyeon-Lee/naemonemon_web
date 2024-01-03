import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/modules/gate/gate_way_controller.dart';
import 'package:shovving_web/modules/gate/gate_way_repository.dart';
import 'package:shovving_web/modules/poll/poll_detail/poll_detail_controller.dart';
import 'package:shovving_web/util/safe_print.dart';

class PollController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Poll? pollData;

  setPollData(Poll? getData){
    pollData = getData;
    update();
  }

  PollRepository pollRepository = PollRepository();
  joinPoll() async {
    final pollDetailController = Get.find<PollDetailController>();
    indicatorController.nowLoading();
    update();
    pollDetailController.update();



    ///먼저 조인을 만들어야 하고
    ///아이템의 길이 selectedindex사용하면 될 듯
    safePrint('조인 정보');
    safePrint(pollData!.join);
    safePrint(pollData!.items.length);
    safePrint(pollDetailController.selectedItemIndex);

    List<int> tempJoin = [];

    if(pollData!.items.length==1){
      if(pollDetailController.selectedItemIndex==0){
        tempJoin = [1,0];
      }else{
        tempJoin = [0,1];
      }
    }else{
      for(int i=0; i<pollData!.items.length; i++){
        if(i==pollDetailController.selectedItemIndex){
          tempJoin.add(1);
        }else{
          tempJoin.add(0);
        }
      }
    }




    await pollRepository.joinPolls(tempJoin, pollData!.id, pollData!.id);

    indicatorController.completeLoading();
    update();
    pollDetailController.update();
  }


}
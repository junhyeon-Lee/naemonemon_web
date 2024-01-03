import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/util/safe_print.dart';
import 'package:url_launcher/url_launcher.dart';

class PollDetailController extends GetxController{
  List<String> alphabetList = List.generate(26, (index) {
    String alphabet = String.fromCharCode(65 + index);
    return alphabet;
  });

  Poll? pollData;
  setPollData(Poll poll){
    pollData = poll;
    update();
  }


  PageController imageListPageController = PageController();


  int selectedItemIndex = 0;

  selectItem(int index) {
    safePrint('인덱스 변경 $index');
    selectedItemIndex = index;
    safePrint(selectedItemIndex);
    update();
  }

  secondItem(int itemsLength) {
    int secondIndex = (selectedItemIndex + 1) % itemsLength;
    return secondIndex;
  }

  thirdItem(int itemsLength) {
    int thirdItem = (selectedItemIndex + 2) % itemsLength;
    return thirdItem;
  }



  bool isExpanded = false;
  pollCommentClose(){
    isExpanded = false;
    update();
  }
  pollCommentExpanded(){
    isExpanded = true;
    update();
  }


  seeDetail(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
    launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
    // ignore: avoid_print
    print("Can't launch $url");
    }
  }





}
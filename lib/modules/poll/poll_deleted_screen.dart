import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/modules/poll/poll_controller.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';

class PollDeletedScreen extends StatelessWidget {
  const PollDeletedScreen({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CommonContainer(
            containerColor: Colors.white,
            width: double.infinity,
            height: 124,
            child: Center(
              child: Text(
                '사용자에 의해 삭제된 투표입니다.',
                style: CTextStyle.eHeader22,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

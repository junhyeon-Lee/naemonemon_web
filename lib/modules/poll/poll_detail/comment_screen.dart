import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/api_model/social/comment.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';
import 'package:shovving_web/ui_helper/common_widget/common_appbar.dart';
import 'package:shovving_web/util/dio/api_constants.dart';

import 'poll_detail_controller.dart';
import 'poll_detail_widget.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({Key? key, required this.commentDataList}) : super(key: key);

  final List<Comment> commentDataList;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CommonAppbar(title: '댓글',),
      body: Stack(
        children: [
          commentList(commentDataList),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: (){
                  Get.find<PollDetailController>().seeDetail(APIConstants.naemonemonStore);
                },
                child: Container(
                  width: 390*screenRatio - 40,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(width: 1, color: const Color(0xffE0E0E0)),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          width: 390*screenRatio - 40 - 10 - 20 - 20 - 24,
                          child: FocusScope(
                            child: TextField(
                              enabled: false,
                              style: CTextStyle.light12.copyWith(color: const Color(0xff525252)),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: '댓글 작성 하기',
                                hintStyle: CTextStyle.light12.copyWith(color: const Color(0xff525252)),
                              ),
                              onTap: () {
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () async {
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(color: Color(0xffF8A940), borderRadius: BorderRadius.all(Radius.circular(34))),
                            child: Center(
                                child: SvgPicture.asset(
                                  CIconPath.arrowRight24p,
                                  width: 24,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

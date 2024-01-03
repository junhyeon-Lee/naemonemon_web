
import 'package:cached_network_image/cached_network_image.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/api_model/social/comment.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/modules/poll/poll_controller.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';
import 'package:shovving_web/util/calculator.dart';
import 'package:shovving_web/util/dio/api_constants.dart';
import 'package:shovving_web/util/safe_print.dart';

import 'comment_screen.dart';
import 'pollDetail_calculator.dart';
import 'poll_detail_controller.dart';
import 'result_screen.dart';


Widget pollComment(Poll pollData) {
  return GetBuilder<PollDetailController>(builder: (pollDetailController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,20),
      child: Container(
        width: 390*screenRatio - 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: CColor.brightGray,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Stack(alignment: Alignment.centerLeft,
                      children: [
                        SizedBox(
                          width:  390*screenRatio - 120*screenRatio,
                          height: 34,
                        ),
                        Positioned(
                          left: 40,
                          child: Text(
                            pollData.user?.nickName ?? '',
                            style: CTextStyle.bold14.copyWith(color: Colors.black),
                          ),
                        ),

                        ///여기에 신고하기 걸기 타입 수정하기
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(28)),
                            border: Border.all(width: 2, color: Colors.white),

                            image: DecorationImage(
                              image: NetworkImage(pollData.user?.profileImage ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),



                      ],
                    ),
                  Text(
                    timeCalculator(pollData.createAt),
                    style: CTextStyle.regular12.copyWith(color: const Color(0xff525252), height: 1),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 390*screenRatio - 80,
                child: Text(
                  pollData.pollComment==''?'작성자가 본문 내용을 작성하지 않은 투표입니다.':
                  pollData.pollComment,
                  style: CTextStyle.bold12.copyWith(color:
                  pollData.pollComment==''?CColor.gray:
                  Colors.black, height: 20 / 12),
                ),
              ),
            ),
          ],
        )

      ),
    );
  });
}

Widget joinButton(bool isJoin, int index, bool isFinished) {
  List<String> alphabetList = List.generate(26, (index) {
    String alphabet = String.fromCharCode(65 + index);
    return alphabet;
  });

  if(isFinished){
    return Container(
      width: 160*screenRatio,
      height: 46*screenRatio,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(36)),
        color: const Color(0xffF8408D).withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '종료 됨',
            style: CTextStyle.bold20.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }else{
    return Container(
      width: 160*screenRatio,
      height: 46*screenRatio,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(36)),
        color: isJoin ? Colors.white : const Color(0xffFEDB07),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isJoin
              ? SvgPicture.asset(
            CIconPath.check,
            color: Colors.red,
            width: 36,
          )
              : Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(36)),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  alphabetList[index],
                  style: CTextStyle.heavy10,
                ),
              )),
          const SizedBox(
              width: 12
          ),
          isJoin
              ? Text(
            '내 선택',
            style: CTextStyle.bold20.copyWith(color: Colors.black),
          )
              : Text(
            '투표하기',
            style: CTextStyle.bold20,
          )
        ],
      ),
    );
  }



}





Widget vsJoinButton(bool isLeft, List<int>? joins, bool isFinished) {
  bool myChoice = false;

  List<int> joinList = joins ?? [];
  if (joinList.length == 2) {
    if (isLeft) {
      if (joinList[0] == 1) {
        myChoice = true;
      }
    } else {
      if (joinList[1] == 1) {
        myChoice = true;
      }
    }
  }

  if (joinList.length == 2) {
    return Container(
      width: 160*screenRatio,
      height: 46*screenRatio,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(36)),
        color: myChoice ? Colors.white : CColor.brightGray,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (myChoice)
            SvgPicture.asset(
              CIconPath.check,
              color: const Color(0xffFF2E7E),
              width: 36,
            ),
          if (myChoice)
            SizedBox(
              width: 12*screenRatio,
            ),
          Text(
            myChoice ? '내 선택' : '선택 안 함',
            style: CTextStyle.bold20.copyWith(color: myChoice ? Colors.black : CColor.gray),
          )
        ],
      ),
    );
  } else {
    return Container(
      width: 160*screenRatio,
      height: 46*screenRatio,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(36)),
        color: isLeft ? CColor.mainPurple : const Color(0xff71C587),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 20*screenRatio,
              height: 20*screenRatio,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(36)),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  isLeft ? 'A' : 'B',
                  style: CTextStyle.heavy10,
                ),
              )),
          SizedBox(
            width: 12*screenRatio,
          ),
          joinList.length == 2
              ? //myChoice
              Text(
                  myChoice ? '내 선택' : '선택 안 함',
                  style: CTextStyle.bold20,
                )
              : Text(
                  '투표하기',
                  style: CTextStyle.bold20,
                )
        ],
      ),
    );
  }
}

Widget ynJoinButton(bool isLeft, List<int>? joins, bool isFinished) {
  bool myChoice = false;

  List<int> joinList = joins ?? [];
  safePrint('오른쪽 했는디');
  safePrint(joins);
  if (joinList.length == 2) {
    if (isLeft) {
      if (joinList[0] != 0) {
        myChoice = true;
      }
    } else {
      if (joinList[1] != 0) {
        myChoice = true;
      }
    }
  }

  if(isFinished){
    return Container(
      width: 160*screenRatio,
      height: 46*screenRatio,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(36)),
        color: const Color(0xffF8408D).withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '종료 됨',
            style: CTextStyle.bold20.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }else{
    if (joinList.length == 2) {
      return Container(
        width: 160*screenRatio,
        height: 46*screenRatio,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(36)),
          color: myChoice ? Colors.white : CColor.brightGray,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (myChoice)
              SvgPicture.asset(
                CIconPath.check,
                color: const Color(0xffFF2E7E),
                width: 36,
              ),
            if (myChoice)
              SizedBox(
                width: 12*screenRatio,
              ),
            Text(
              myChoice ? '내 선택' : '선택 안 함',
              style: CTextStyle.bold20.copyWith(color: myChoice ? Colors.black : CColor.gray),
            )
          ],
        ),
      );
    } else {
      return Container(
        width: 160*screenRatio,
        height: 46*screenRatio,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(36)),
          color: isLeft ? const Color(0xff19E4D0) : const Color(0xff7080FC),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 20*screenRatio,
                height: 20*screenRatio,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(36)),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    isLeft ? 'A' : 'B',
                    style: CTextStyle.heavy10,
                  ),
                )),
            SizedBox(
              width: 12*screenRatio,
            ),
            joinList.length == 2
                ? //myChoice
            Text(
              myChoice ? '내 선택' : '선택 안 함',
              style: CTextStyle.bold20,
            )
                : Text(
              isLeft ? '산다' : '안 산다',
              style: CTextStyle.bold20,
            )
          ],
        ),
      );
    }
  }





}

Widget menuButton(int index, int data) {
  List<String> tagList = ['공유하기', '카드담기'];
  List<String> tagPath = [
    CIconPath.share30p,
    CIconPath.download30p,
    CIconPath.heartOff30pPn,
    CIconPath.comment30p
  ];

  String tag = '';
  String path = '';
  path = tagPath[index];
  switch (index) {
    case 0:
      tag = tagList[index];
      break;
    case 1:
      tag = tagList[index];
      break;
    case 2:
      tag = data.toString();
      break;
    case 3:
      tag = data.toString();
      break;
  }

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5*screenRatio),
    child: GestureDetector(

      onTap: (){
        if(index==0){

          String webBaseUrl = 'https://naemonemon.com/?pollId=';
          final key = en.Key.fromUtf8('dhrmeoduqntjwlwl');
          final iv = en.IV.fromLength(16);
          final encrypter = en.Encrypter(en.AES(key));
          String encrptText = encrypter.encrypt(pollController.pollData!.id.toString(), iv: iv).base64;
          String webPollUrl =  '$webBaseUrl$encrptText';


          Get.snackbar(
              '내모네몬',
              '주소가 복사 되었습니다.'
          );
          Clipboard.setData(ClipboardData(text: webPollUrl));
        }else{
          Get.find<PollDetailController>().seeDetail(APIConstants.naemonemonStore);
        }


      },

      child: SizedBox(
        width: 50*screenRatio,
        height: 50*screenRatio,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox( width: 30*screenRatio, height: 30*screenRatio,
                child:
                index==2?Image.asset(path, width: 30*screenRatio,   fit: BoxFit.fitWidth):
                SvgPicture.asset(
                  path,
                  width: 30*screenRatio,   fit: BoxFit.fitWidth, color: Colors.black,
                ),


              ),
              Text(
                tag,
                style: CTextStyle.bold10,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget commentBlind() {
  return SizedBox(
    width: 390*screenRatio,
    height: 208*screenRatio,
    child: Stack(alignment: Alignment.center,
      children: [
        SizedBox(  width:  390*screenRatio-40*screenRatio,height: 208*screenRatio-40,
          child: SvgPicture.asset(
            CIconPath.pollDetailBase04,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(45, 69, 45, 0),
          child: Text(
            '투표에 참여하시면 결과와 대글을 확인하실 수 있어요.',
            style: CTextStyle.bold19.copyWith(color: CColor.gray),
          ),
        )
      ],
    ),
  );
}

Widget commentList(List<Comment> commentList){

  List<Widget> commentWidgetList = [];
  for(int i=0; i<commentList.length; i++){

    Comment tempComment = commentList[i].copyWith(likeLength: commentList[i].likes.length);

    commentWidgetList.add(commentItem(tempComment));

  }
  return SizedBox(height:  Get.height,
    child: Padding(
      padding: EdgeInsets.only(top: 20*screenRatio),
      child: ListView(
        shrinkWrap: true,
        children: commentWidgetList,
      ),
    ),
  );

}

Widget commentItem(Comment commentData) {
  return Padding(
    padding: EdgeInsets.fromLTRB(30*screenRatio, 0, 30*screenRatio, 10*screenRatio),
    child: SizedBox(
      height: 79*screenRatio,
      child: Stack(
        children: [
          Container(height: 79*screenRatio, width: 390*screenRatio-40*screenRatio,),

          Positioned(
              top: 0, left: 0,
              child: profileImageCircle(commentData.user.profileImage ?? '')),


          Positioned(left: 40*screenRatio, top: 7*screenRatio, child: Text(commentData.user.nickName ?? '')),

          Positioned(left: 10*screenRatio, top: 40*screenRatio, child: Text(commentData.comment)),

          Positioned (
            right: 0*screenRatio,
            top: 17*screenRatio,
            child: Text(
              timeCalculator(
                commentData.createdAt,
              ),
              style: CTextStyle.regular12.copyWith( color: CColor.gray),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(right: 3*screenRatio),
                  child: SizedBox( width: 20*screenRatio,height: 20*screenRatio,
                    child: GestureDetector(
                        onTap: (){
                          Get.find<PollDetailController>().seeDetail(APIConstants.naemonemonStore);
                        },
                        child: Image.asset(CIconPath.heartOff30pPn,width: 20*screenRatio, fit: BoxFit.fitWidth,))




                  ),
                ),
                 SizedBox(height: 2*screenRatio),
                Text(
                  commentData.likeLength.toString(),
                  style: CTextStyle.bold10,
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget isFinishedWidget() {
  return Positioned(
      top: 59,
      left: Get.width / 2 - 45,
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: 90,
          height: 26,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(width: 1, color: Colors.black),
            color: Colors.black.withOpacity(0.8),
          ),
          child: Center(
              child: Text(
            '종료 됨',
            style: CTextStyle.bold16.copyWith(color: Colors.white, height: 1),
          )),
        ),
      ));
}

Widget commentNavigator(Poll pollData) {

  return GetBuilder<PollController>(builder: (pollController) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 390*screenRatio,
          height: 208*screenRatio,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            color: CColor.brightGray,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (pollData.comments.isEmpty) Container(
                        width: (390*screenRatio - 50*screenRatio) / 2,
                        height: (390*screenRatio - 50*screenRatio) / 2,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              '아직 댓글이 없어요. 첫 댓글의 주인공이 되어 보세요!',
                              style: CTextStyle.light14.copyWith(height: 28 / 14, decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ) else GestureDetector(
                      onTap: (){
                        Get.to(CommentScreen(commentDataList:pollData.comments,));
                      },
                      child: Container(
                        width: (390*screenRatio - 50*screenRatio) / 2,
                        height: (390*screenRatio - 50*screenRatio) / 2,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                '인기 댓글',
                                style: CTextStyle.heavy16,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                                      border: Border.all(width: 2, color: Colors.white),

                                      image: DecorationImage(
                                        image: NetworkImage(pollData.comments[0].user.profileImage ?? ''
                                        ),
                                        fit: BoxFit.cover,
                                      ),

                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    pollData.comments[0].user.nickName ?? '',
                                    style: CTextStyle.bold12.copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  pollData.comments[0].comment ?? '',
                                  style: CTextStyle.light12.copyWith(color: Colors.black, height: 14 / 12),
                                  maxLines: 3,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(62, 0, 62, 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Get.find<PollDetailController>().seeDetail(APIConstants.naemonemonStore);
                                      },
                                      child: SvgPicture.asset(
                                        CIconPath.heartOff30p,
                                        width: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      pollData.comments[0].likes.length.toString(),
                                      style: CTextStyle.bold12.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                    ),

                if (mostVotes(pollData.numberOfVotes) == null)
                  Container(
                    width: (390*screenRatio - 50*screenRatio) / 2,
                    height: (390*screenRatio - 50*screenRatio) / 2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          '아직 투표가 없어요. 첫 투표로 당신의\n센스를 보여주세요!',
                          style: CTextStyle.light14.copyWith(
                            height: 28 / 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      Get.to(ResultScreen(pollData:pollData,));
                    },
                    child: Container(
                      width: (390*screenRatio - 50*screenRatio) / 2,
                      height: (390*screenRatio - 50*screenRatio) / 2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '최다 투표',
                            style: CTextStyle.heavy16,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(25)),
                            child: Container(
                              width: 72,
                              height: 72,

                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage( pollData.items.length == 1
                                      ? pollData.items[0].image ?? ''
                                      : pollData.items[mostVotes(pollData.numberOfVotes)!].image ?? '',),
                                  fit: BoxFit.cover,
                                ),
                              ),

                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                CIconPath.crown,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                pollData.numberOfVotes[mostVotes(pollData.numberOfVotes)!].toString(),
                                style: CTextStyle.bold12.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        if (commentBlindChecker(pollData.isAlreadyVoted, pollData.finalChoice)) commentBlind()
      ],
    );
  });
}

Widget profileImageCircle(String imageUrl) {
  return Container(
      width: 34*screenRatio,
      height: 34*screenRatio,
      decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), borderRadius: const BorderRadius.all(Radius.circular(34))),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          width: 30*screenRatio,
          height: 30*screenRatio,

          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ));
}
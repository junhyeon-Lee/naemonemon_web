import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';
import 'package:shovving_web/util/calculator.dart';
import 'package:shovving_web/util/dio/api_constants.dart';
import 'package:shovving_web/util/indicator/indicator.dart';
import 'package:shovving_web/util/safe_print.dart';
import 'pollDetail_calculator.dart';
import 'poll_detail_controller.dart';
import 'poll_detail_widget.dart';

class PollDetailScreen extends StatelessWidget {
  const PollDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<PollDetailController>(
        init: PollDetailController(),
        builder: (pollDetailController) {

          pollDetailController.setPollData(pollController.pollData!);
          Poll pollData = pollDetailController.pollData!;

          List<String> itemsImageList = getItemImage(pollData);
          List<List<String>> fullImageList = getFullImage(pollData);
          List<int> splitPoint = getSplitPoint(pollData, fullImageList);
          int imageListLength = getFullImageLength(pollData, fullImageList);
          List<int> joinData = getJoinData(pollData);


          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                            width: Get.width - 88 - 88,
                            child: Center(
                                child: SvgPicture.asset(
                              CIconPath.naemonemonLogoWithText,
                              width: 100,
                            ))),
                        const SizedBox(height: 10),
                        // if (pollData.finalChoice != null)
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       isFinishedWidget(),
                        //     ],
                        //   ),


                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: 390 * screenRatio,
                              height:  pollData.items.length==2?578 * screenRatio:550 * screenRatio,
                              color: Colors.white,
                            ),

                            // if (pollData.finalChoice != null) isFinishedWidget(),
                            Positioned(
                                child: Container(
                                    width: 390 * screenRatio,
                                    height: 390 * screenRatio,
                                    decoration: BoxDecoration(
                                      color: CColor.brightGray,
                                    ),
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                                      child: PageView.builder(
                                          controller: pollDetailController.imageListPageController,
                                          itemCount: imageListLength,
                                          onPageChanged: (page) {
                                            pollDetailController.selectItem(imageListCalculator(page, splitPoint)[0]);
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                                decoration: BoxDecoration(
                                              color: CColor.gray,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    fullImageList[imageListCalculator(index, splitPoint)[0]][imageListCalculator(index, splitPoint)[1]]),
                                                fit: BoxFit.cover,
                                              ),
                                            ));
                                          }),
                                    ))),

                            ///제너럴 위젯
                            if(pollData.items.length>2)
                            Positioned(
                              top: 390 * screenRatio - 22 * screenRatio,
                              left: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      if (pollData.finalChoice != null)
                                        if (pollData.finalChoice?[pollDetailController.selectedItemIndex] == 1)
                                          Container(
                                            width: 86 * screenRatio,
                                            height: 28 * screenRatio,
                                            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(36))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                                  child: Container(
                                                    width: 16 * screenRatio,
                                                    height: 16 * screenRatio,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(pollData.profileImage ?? ''),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),

                                                  ),
                                                ),
                                                SizedBox(width: 4 * screenRatio),
                                                Text(pollData.finalChoice == null ? '종료됨' : '최종 선택', style: CTextStyle.regular12),
                                              ],
                                            ),
                                          ),
                                      if (pollData.finalChoice != null)
                                        if (pollData.finalChoice?[pollDetailController.selectedItemIndex] == 1)
                                          SizedBox(
                                            height: 6 * screenRatio,
                                          ),
                                      if (votesRanking(pollData.numberOfVotes, pollDetailController.selectedItemIndex) != null)
                                        Container(
                                          width: 86 * screenRatio,
                                          height: 28 * screenRatio,
                                          decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(36))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  CIconPath.crown,
                                                  width: 16 * screenRatio,
                                                ),
                                                SizedBox(width: 4 * screenRatio),
                                                Text(
                                                  '투표 ${votesRanking(pollData.numberOfVotes, pollDetailController.selectedItemIndex)}위',
                                                  style: CTextStyle.regular12.copyWith(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 6 * screenRatio,
                                      ),
                                      Container(
                                        width: 86 * screenRatio,
                                        height: 28 * screenRatio,
                                        decoration: const BoxDecoration(color: Color(0xffF8A940), borderRadius: BorderRadius.all(Radius.circular(36))),
                                        child: Center(
                                          child: Text(
                                            '${pollData.numberOfVotes[pollDetailController.selectedItemIndex]} 표',
                                            style: CTextStyle.regular12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6 * screenRatio,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10 * screenRatio),
                                  SizedBox(
                                      width: 88 * screenRatio,
                                      height: 126 * screenRatio,
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          SvgPicture.asset(
                                            CIconPath.pollDetailBase02,
                                            width: 88 * screenRatio,
                                            fit: BoxFit.fitWidth,
                                            color: Colors.white,
                                          ),
                                          Positioned(
                                              top: 6 * screenRatio,
                                              child: SvgPicture.asset(
                                                CIconPath.pollDetailBase03,
                                              )),
                                          Positioned(
                                            bottom: 4 * screenRatio,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                                              child: SizedBox(
                                                height: 100 * screenRatio,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        width: 80 * screenRatio,
                                                        height: 80 * screenRatio,
                                                        decoration: BoxDecoration(
                                                          color: CColor.gray,
                                                          image: DecorationImage(
                                                            image: NetworkImage(pollData.items[pollDetailController.selectedItemIndex].image ?? ''),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )),
                                                    Container(
                                                      width: 80 * screenRatio,
                                                      height: 20 * screenRatio,
                                                      color: const Color(0xffF8A940),
                                                      child: Center(
                                                        child: Text(
                                                          pollDetailController.alphabetList[pollDetailController.selectedItemIndex],
                                                          style: CTextStyle.heavy12,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  SizedBox(width: 10 * screenRatio),
                                  GestureDetector(
                                    onTap: () {
                                      pollDetailController.selectItem(pollDetailController.secondItem(pollData.items.length));
                                      pollDetailController.imageListPageController
                                          .jumpToPage(imageListCalculatorReverse([pollDetailController.selectedItemIndex, 0], splitPoint));
                                    },
                                    child: Container(
                                        width: 88 * screenRatio,
                                        height: 108 * screenRatio,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 80 * screenRatio,
                                            height: 100 * screenRatio,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      width: 80 * screenRatio,
                                                      height: 80 * screenRatio,
                                                      decoration: BoxDecoration(
                                                        color: CColor.gray,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              pollData.items[pollDetailController.secondItem(pollData.items.length)].image ?? ''),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  Container(
                                                    width: 80 * screenRatio,
                                                    height: 20 * screenRatio,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                      color: CColor.brightGray,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        //'B',
                                                        pollDetailController.alphabetList[pollDetailController.secondItem(pollData.items.length)],
                                                        style: CTextStyle.heavy12,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10 * screenRatio,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pollDetailController.selectItem(pollDetailController.thirdItem(pollData.items.length));
                                      pollDetailController.imageListPageController
                                          .jumpToPage(imageListCalculatorReverse([pollDetailController.selectedItemIndex, 0], splitPoint));
                                    },
                                    child: Container(
                                        width: 88 * screenRatio,
                                        height: 108 * screenRatio,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 80 * screenRatio,
                                            height: 100 * screenRatio,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      width: 80 * screenRatio,
                                                      height: 80 * screenRatio,
                                                      decoration: BoxDecoration(
                                                        color: CColor.gray,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              pollData.items[pollDetailController.thirdItem(pollData.items.length)].image ?? ''),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  Container(
                                                    width: 80 * screenRatio,
                                                    height: 20 * screenRatio,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                      color: CColor.brightGray,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        //'B',
                                                        pollDetailController.alphabetList[pollDetailController.thirdItem(pollData.items.length)],
                                                        style: CTextStyle.heavy12,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            ///투표하기 위젯
                            if(pollData.items.length>2)
                            Positioned(
                              top: 390 * screenRatio - 22 * screenRatio + 126 * screenRatio + 10 * screenRatio,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20 * screenRatio),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 178 * screenRatio,
                                      child: pollData.items[pollDetailController.selectedItemIndex].title == 'poll item'
                                          ? Center(
                                              child: Text(
                                                '직접 추가 한 이미지 입니다.',
                                                style: CTextStyle.heavy14.copyWith(height: 18 / 14, color: CColor.gray),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  pollDetailController.seeDetail(pollData.items[pollDetailController.selectedItemIndex].url);
                                                  //pollDetailController.seeDetailUrl(pollData.items[pollDetailController.selectedItemIndex].url);
                                                },
                                                child: Text(
                                                  pollData.items[pollDetailController.selectedItemIndex].title ??
                                                      pollData.items[pollDetailController.selectedItemIndex].url,
                                                  style: CTextStyle.heavy14.copyWith(height: 18 / 14, decoration: TextDecoration.underline),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 13 * screenRatio,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (pollData.finalChoice == null) {
                                          if (pollData.join == null) {
                                            pollController.joinPoll();
                                          } else {
                                            if (pollData.join![pollDetailController.selectedItemIndex] == 0) {
                                              pollController.joinPoll();
                                            } else {
                                              safePrint('이미 투표한 아이템 입니다.');
                                            }
                                          }
                                        }
                                      },
                                      child: pollData.join == null
                                          ? joinButton(false, pollDetailController.selectedItemIndex, pollData.finalChoice != null)
                                          : joinButton(pollData.join![pollDetailController.selectedItemIndex] == 1,
                                              pollDetailController.selectedItemIndex, pollData.finalChoice != null),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            if(pollData.items.length==1)
                              Positioned(
                                top: 390*screenRatio + 20*screenRatio,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        pollDetailController.seeDetail(pollData.items[0].url);
                                      },
                                      child: SizedBox(
                                          width: 300*screenRatio,
                                          child: Text(pollData.items[0].title??pollData.items[0].url,

                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: CTextStyle.heavy16,

                                          )),
                                    ),
                                    SizedBox(height: 20*screenRatio,),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (pollData.finalChoice == null) {
                                                pollDetailController.selectItem(0);
                                                if (pollData.join == null) {
                                                  pollController.joinPoll();
                                                } else {
                                                  if (pollData.join![0] == 0) {
                                                    pollController.joinPoll();
                                                  } else {
                                                    safePrint('이미 투표한 아이템 입니다.');
                                                  }
                                                }
                                              }
                                            },

                                            child: ynJoinButton(true, pollData.join, pollData.finalChoice!=null)),
                                        SizedBox(width: 30*screenRatio,),
                                        GestureDetector(
                                            onTap: () {
                                              pollDetailController.selectItem(1);
                                              if (pollData.finalChoice == null) {
                                                if (pollData.join == null) {
                                                  pollController.joinPoll();
                                                } else {
                                                  if (pollData.join![1] == 0) {
                                                    pollController.joinPoll();
                                                  } else {
                                                    safePrint('이미 투표한 아이템 입니다.');
                                                  }
                                                }
                                              }
                                            },
                                            child: ynJoinButton(false, pollData.join, pollData.finalChoice!=null))

                                      ],
                                    ),
                                    SizedBox(height: 14*screenRatio,),
                                    pollData.join==null?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 390*screenRatio - 40*screenRatio,
                                        height: 20*screenRatio,
                                        color: const Color(0xffFFE7F0),
                                      ),
                                    ):
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 390*screenRatio - 40*screenRatio,
                                        height: 20*screenRatio,
                                        decoration: BoxDecoration(
                                          color: pollData.numberOfVotes.reduce((a, b) => a + b) == 0 ? const Color(0xffFFE7F0) : CColor.brightGray,
                                        ),
                                        child: pollData.numberOfVotes.reduce((a, b) => a + b) == 0
                                            ? Container()
                                            : Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: (390*screenRatio - 40*screenRatio) / pollData.numberOfVotes.reduce((a, b) => a + b) * pollData.numberOfVotes[0],
                                                  height: 20*screenRatio,
                                                  color: const Color(0xff19E4D0),
                                                ),
                                                Container(
                                                  width: (390*screenRatio - 40*screenRatio) / pollData.numberOfVotes.reduce((a, b) => a + b) * pollData.numberOfVotes[1],
                                                  height: 20*screenRatio,
                                                  color: const Color(0xff7080FC),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${pollData.numberOfVotes[0].toString()} (${100 - (pollData.numberOfVotes[1] / pollData.numberOfVotes.reduce((a, b) => a + b) * 100).toInt()}%)',
                                                    style: CTextStyle.bold12.copyWith(color: Colors.black),
                                                  ),
                                                  Text(
                                                    '${pollData.numberOfVotes[1].toString()} (${(pollData.numberOfVotes[1] / pollData.numberOfVotes.reduce((a, b) => a + b) * 100).toInt()}%)',
                                                    style: CTextStyle.bold12.copyWith(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            if(pollData.items.length==2)
                              Positioned(
                                top: 390*screenRatio-100 * screenRatio,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        pollDetailController.selectedItemIndex==0?
                                        GestureDetector(
                                          onTap: () {
                                            pollDetailController.selectItem(0);
                                            pollDetailController.imageListPageController
                                                .jumpToPage(imageListCalculatorReverse([0, 0], splitPoint));
                                          },
                                          child: SizedBox(
                                              width: 88 * screenRatio,
                                              height: 126 * screenRatio,
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [

                                                  if(pollDetailController.selectedItemIndex==0)
                                                  SvgPicture.asset(
                                                    CIconPath.pollDetailBase02,
                                                    width: 88 * screenRatio,
                                                    fit: BoxFit.fitWidth,
                                                    color: Colors.white,
                                                  ),
                                                  if(pollDetailController.selectedItemIndex==0)
                                                  Positioned(
                                                      top: 6 * screenRatio,
                                                      child: SvgPicture.asset(
                                                        CIconPath.pollDetailBase03,
                                                        color: const Color(0xffC1A7FB),
                                                      )),

                                                  Positioned(
                                                    bottom: 4 * screenRatio,
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                      child: SizedBox(
                                                        height: 100 * screenRatio,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                width: 80 * screenRatio,
                                                                height: 80 * screenRatio,
                                                                decoration: BoxDecoration(
                                                                  color: CColor.gray,
                                                                  image: DecorationImage(
                                                                    image: NetworkImage(pollData.items[0].image ?? ''),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                )),
                                                            Container(
                                                              width: 80 * screenRatio,
                                                              height: 20 * screenRatio,
                                                              color: const Color(0xffC1A7FB),
                                                              child: Center(
                                                                child: Text(
                                                                  pollDetailController.alphabetList[0],
                                                                  style: CTextStyle.heavy12,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ):
                                        GestureDetector(
                                          onTap: () {
                                            pollDetailController.selectItem(0);
                                            pollDetailController.imageListPageController
                                                .jumpToPage(imageListCalculatorReverse([0, 0], splitPoint));
                                          },
                                          child: Container(
                                              width: 88 * screenRatio,
                                              height: 108 * screenRatio,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80 * screenRatio,
                                                  height: 100 * screenRatio,
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: 80 * screenRatio,
                                                            height: 80 * screenRatio,
                                                            decoration: BoxDecoration(
                                                              color: CColor.gray,
                                                              image: DecorationImage(
                                                                image: NetworkImage(
                                                                    pollData.items[0].image ?? ''),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            )),
                                                        Container(
                                                          width: 80 * screenRatio,
                                                          height: 20 * screenRatio,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                            color: CColor.brightGray,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              //'B',
                                                              pollDetailController.alphabetList[0],
                                                              style: CTextStyle.heavy12,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),

                                        SizedBox(width: 174*screenRatio,),

                                        pollDetailController.selectedItemIndex==1?
                                        GestureDetector(
                                          onTap: () {
                                            pollDetailController.selectItem(1);
                                            pollDetailController.imageListPageController
                                                .jumpToPage(imageListCalculatorReverse([1, 0], splitPoint));
                                          },
                                          child: SizedBox(
                                              width: 88 * screenRatio,
                                              height: 126 * screenRatio,
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  if(pollDetailController.selectedItemIndex==1)
                                                  SvgPicture.asset(
                                                    CIconPath.pollDetailBase02,
                                                    width: 88 * screenRatio,
                                                    fit: BoxFit.fitWidth,
                                                    color: Colors.white,
                                                  ),
                                                  if(pollDetailController.selectedItemIndex==1)
                                                  Positioned(
                                                      top: 6 * screenRatio,
                                                      child: SvgPicture.asset(
                                                        CIconPath.pollDetailBase03,
                                                        color: const Color(0xff71C587),
                                                      )),
                                                  Positioned(
                                                    bottom: 4 * screenRatio,
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                      child: SizedBox(
                                                        height: 100 * screenRatio,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                width: 80 * screenRatio,
                                                                height: 80 * screenRatio,
                                                                decoration: BoxDecoration(
                                                                  color: CColor.gray,
                                                                  image: DecorationImage(
                                                                    image: NetworkImage(pollData.items[1].image ?? ''),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                )),
                                                            Container(
                                                              width: 80 * screenRatio,
                                                              height: 20 * screenRatio,
                                                              color: const Color(0xff71C587),
                                                              child: Center(
                                                                child: Text(
                                                                  pollDetailController.alphabetList[1],
                                                                  style: CTextStyle.heavy12,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ):
                                        GestureDetector(
                                          onTap: () {
                                            pollDetailController.selectItem(1);
                                            pollDetailController.imageListPageController
                                                .jumpToPage(imageListCalculatorReverse([1, 0], splitPoint));
                                          },
                                          child: Container(
                                              width: 88 * screenRatio,
                                              height: 108 * screenRatio,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80 * screenRatio,
                                                  height: 100 * screenRatio,
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: 80 * screenRatio,
                                                            height: 80 * screenRatio,
                                                            decoration: BoxDecoration(
                                                              color: CColor.gray,
                                                              image: DecorationImage(
                                                                image: NetworkImage(
                                                                    pollData.items[1].image ?? ''),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            )),
                                                        Container(
                                                          width: 80 * screenRatio,
                                                          height: 20 * screenRatio,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                            color: CColor.brightGray,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              //'B',
                                                              pollDetailController.alphabetList[1],
                                                              style: CTextStyle.heavy12,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        )

                                        ,
                                      ],
                                    ),

                                    SizedBox(
                                      height: 20*screenRatio,
                                    ),

                                    SizedBox(width: 390*screenRatio,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20*screenRatio),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 160*screenRatio,
                                              child: pollData.items[0].title == 'poll item'
                                                  ? Text(
                                                '직접 추가 한 이미지 입니다.',
                                                style: CTextStyle.heavy14.copyWith( color: CColor.gray),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                                  : GestureDetector(
                                                onTap: (){
                                                  pollDetailController.seeDetail(pollData.items[0].url);
                                                  //pollDetailController.seeDetailUrl(pollData.items[0].url);
                                                },
                                                child: Text(
                                                  pollData.items[0].title ?? pollData.items[0].url,
                                                  style: CTextStyle.heavy14.copyWith( decoration: TextDecoration.underline),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 160*screenRatio,

                                              child: pollData.items[1].title == 'poll item'
                                                  ? Text(
                                                '직접 추가 한 이미지 입니다.',
                                                style: CTextStyle.heavy14.copyWith(height: 18 / 14, color: CColor.gray),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                                  : GestureDetector(
                                                onTap: (){
                                                  pollDetailController.seeDetail(pollData.items[1].url);
                                                },
                                                child: Text(
                                                  pollData.items[1].title ?? pollData.items[1].url,
                                                  style: CTextStyle.heavy14.copyWith(decoration: TextDecoration.underline),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20 * screenRatio,
                                    ),

                                    Stack(alignment: Alignment.center,
                                      children: [
                                        SizedBox(width:390*screenRatio-40*screenRatio,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                  onTap:(){
                                                    if (pollData.finalChoice == null) {
                                                      pollDetailController.selectItem(0);
                                                      if (pollData.join == null) {
                                                        pollController.joinPoll();
                                                      } else {
                                                        if (pollData.join![0] == 0) {
                                                          pollController.joinPoll();
                                                        } else {
                                                          safePrint('이미 투표한 아이템 입니다.');
                                                        }
                                                      }
                                                    }
                                        },
                                                  child: vsJoinButton(true, pollData.join, true)),
                                              GestureDetector(
                                                  onTap:(){
                                                    if (pollData.finalChoice == null) {
                                                      pollDetailController.selectItem(1);
                                                      if (pollData.join == null) {
                                                        pollController.joinPoll();
                                                      } else {
                                                        if (pollData.join![1] == 0) {
                                                          pollController.joinPoll();
                                                        } else {
                                                          safePrint('이미 투표한 아이템 입니다.');
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: vsJoinButton(false, pollData.join, false)),
                                            ],
                                          ),

                                        ),

                                        SvgPicture.asset(CIconPath.pollDetailVSText)
                                      ],
                                    ),




                                    SizedBox(
                                      height: 10 * screenRatio,
                                    ),

                                    pollData.join==null?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 390*screenRatio - 40*screenRatio,
                                        height: 20*screenRatio,
                                        color: const Color(0xffFFE7F0),
                                      ),
                                    ):
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 390*screenRatio - 40*screenRatio,
                                        height: 20*screenRatio,
                                        decoration: BoxDecoration(
                                          color: pollData.numberOfVotes.reduce((a, b) => a + b) == 0 ? const Color(0xffFFE7F0) : CColor.brightGray,
                                        ),
                                        child: pollData.numberOfVotes.reduce((a, b) => a + b) == 0
                                            ? Container()
                                            : Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: (390*screenRatio - 40*screenRatio) / pollData.numberOfVotes.reduce((a, b) => a + b) * pollData.numberOfVotes[0],
                                                  height: 20*screenRatio,
                                                  color: const Color(0xff19E4D0),
                                                ),
                                                Container(
                                                  width: (390*screenRatio - 40*screenRatio) / pollData.numberOfVotes.reduce((a, b) => a + b) * pollData.numberOfVotes[1],
                                                  height: 20*screenRatio,
                                                  color: const Color(0xff7080FC),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${pollData.numberOfVotes[0].toString()} (${100 - (pollData.numberOfVotes[1] / pollData.numberOfVotes.reduce((a, b) => a + b) * 100).toInt()}%)',
                                                    style: CTextStyle.bold12.copyWith(color: Colors.black),
                                                  ),
                                                  Text(
                                                    '${pollData.numberOfVotes[1].toString()} (${(pollData.numberOfVotes[1] / pollData.numberOfVotes.reduce((a, b) => a + b) * 100).toInt()}%)',
                                                    style: CTextStyle.bold12.copyWith(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                          ],
                        ),


                        SizedBox(
                          width: 390 * screenRatio,
                          height: 70 * screenRatio,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              menuButton(0, 0),
                              menuButton(1, 0),
                              menuButton(2, 0),
                              menuButton(3, 0),
                            ],
                          ),
                        ),
                        pollComment(pollData),

                        commentNavigator(pollData),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                              onTap:(){
                                Get.find<PollDetailController>().seeDetail(APIConstants.naemonemonStore);
                              },
                              child: Image.asset(CIconPath.addPro)),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
              if(indicatorController.isLoading)
              myIndicator()
            ],
          );
        });
  }
}

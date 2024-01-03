import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/api_model/cart/cart.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/modules/poll/poll_detail/poll_detail_controller.dart';
import 'package:shovving_web/modules/poll/poll_detail/poll_detail_widget.dart';
import 'package:shovving_web/ui_helper/common_ui_helper.dart';
import 'package:shovving_web/ui_helper/common_widget/common_appbar.dart';
import 'package:shovving_web/util/safe_print.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key, required this.pollData}) : super(key: key);

  final Poll pollData;

  @override
  Widget build(BuildContext context) {
    List<int> finalChoice = [];
    double percent = 0;
    if (pollData.finalChoice != null) {
      finalChoice = pollData.finalChoice!;

      if (pollData.items.length > 2) {
        int myChoice = 0;
        int correct = 0;
        for (int i = 0; i < pollData.join!.length; i++) {
          if (pollData.join![i] == 1) {
            myChoice++;
            if (pollData.finalChoice![i] == 1) {
              correct++;
            }
          }
        }

        percent = 100 * correct / myChoice;
      }

      ///퍼센트를 여기서 계산하고자 합니다.
    }

    List<int> tempNov = pollData.numberOfVotes;
    List<int> tempId = [];
    List<Cart> sortItemData = [];

    for (int i = 0; i < pollData.items.length; i++) {
      sortItemData.add(pollData.items[i]);
      tempId.add(pollData.items[i].id!);
    }

    for (int i = 0; i < pollData.items.length; i++) {
      sortItemData[i] = sortItemData[i].copyWith(numberOfVote: tempNov[i]);
    }

    if (pollData.items.length == 1) {
      Cart tempData = sortItemData[0].copyWith(id: -1, numberOfVote: tempNov[1]);
      sortItemData.add(tempData);
      tempId.add(-1);
    }

    quickSort(sortItemData, 0, sortItemData.length - 1);

    for (int i = 0; i < sortItemData.length; i++) {
      safePrint('리스트 ${sortItemData[i].numberOfVote},  ${sortItemData[i].id}');
    }

    return Scaffold(
      appBar: CommonAppbar(
        title: '결과',
      ),
      body: Column(
        children: [
          SizedBox(
            width: 390 * screenRatio,
            height: Get.height - 56 * screenRatio,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (pollData.finalChoice != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        width: 390 * screenRatio,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(36)),
                          color: CColor.lightGray,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                profileImageCircle(pollData.user?.profileImage ?? ''),
                                const SizedBox(width: 6),
                                Text(
                                  '${pollData.user?.nickName}',
                                  style: CTextStyle.bold14.copyWith(height: 20 / 14, color: Colors.black),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '님의 최종 선택은?',
                                  style: CTextStyle.bold14.copyWith(height: 20 / 14, color: CColor.gray),
                                ),
                              ],
                            ),
                            if (pollData.items.length > 2)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(33, 12, 33, 20),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: pollData.items.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 88 / 108,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Stack(
                                        children: [
                                          Container(
                                              width: 88,
                                              height: 108,
                                              decoration: BoxDecoration(
                                                  color:
                                                      finalChoice[index] == 1 && pollData.join![index] == 1 ? const Color(0xffFF2E7E) : Colors.white,
                                                  borderRadius: const BorderRadius.all(Radius.circular(16))),
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80,
                                                  height: 100,
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 80,
                                                          height: 80,

                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: NetworkImage(pollData.items[index].image ?? '',
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 80,
                                                          height: 20,
                                                          color: CColor.brightGray,
                                                          child: Center(
                                                            child: Text(
                                                              // 'c',
                                                              alphabetList[index],
                                                              style: CTextStyle.heavy12,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          if (finalChoice[index] == 1 && pollData.join![index] == 1)
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                width: 14,
                                                height: 14,
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(14)), color: Color(0xffFF2E7E)),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    CIconPath.check,
                                                    width: 7,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (finalChoice[index] == 0)
                                            Container(
                                              width: 88,
                                              height: 108,
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.8), borderRadius: const BorderRadius.all(Radius.circular(12))),
                                            )
                                        ],
                                      );
                                    }),
                              ),
                            if (pollData.items.length == 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(13)),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                              child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(pollData.items[0].image ?? ''),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                          Container(
                                            width: 114,
                                            height: 114,
                                            color: listEquals(pollData.join, finalChoice) ? Colors.transparent : Colors.black.withOpacity(0.8),
                                            child: Center(
                                                child: Text(
                                              listEquals(pollData.join, finalChoice) ? '산다!' : '안 산다!',
                                              style: CTextStyle.heavy24.copyWith(fontSize: 26, color: Color(0xffFF2E7E)),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (pollData.items.length == 2)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(13)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                pollData.finalChoice![0] == 1 ? pollData.items[0].image ?? '' : pollData.items[1].image ?? '',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: pollData.items.length > 2
                                  ? [
                                      Text(
                                        '나의 선택 중, ',
                                        style: CTextStyle.light20.copyWith(height: 40 / 20, color: Colors.black),
                                      ),
                                      Text(
                                        '${percent.ceil()}%',
                                        style: CTextStyle.light20.copyWith(height: 40 / 20, color: const Color(0xffC1A7FB)),
                                      ),
                                      Text(
                                        ' 적중!',
                                        style: CTextStyle.light20.copyWith(height: 40 / 20, color: Colors.black),
                                      ),
                                    ]
                                  : pollData.items.length == 1
                                      ? [
                                          if (listEquals(pollData.join, finalChoice))
                                            Text(
                                              '최종 선택',
                                              style: CTextStyle.light20.copyWith(height: 40 / 20, color: const Color(0xffC1A7FB)),
                                            ),
                                          if (listEquals(pollData.join, finalChoice))
                                            Text(
                                              ' 적중!',
                                              style: CTextStyle.light20.copyWith(height: 40 / 20, color: Colors.black),
                                            ),
                                          if (listEquals(pollData.join, finalChoice) == false)
                                            Text(
                                              ' 예상 실패...',
                                              style: CTextStyle.light20.copyWith(height: 40 / 20, color: Colors.black),
                                            ),
                                        ]
                                      : [
                                          //pollData.finalChoice![0]==1
                                          if (listEquals(pollData.join, finalChoice))
                                            Text(
                                              '최종 선택',
                                              style: CTextStyle.light20.copyWith(height: 40 / 20, color: const Color(0xffC1A7FB)),
                                            ),
                                          if (listEquals(pollData.join, finalChoice))
                                            Text(
                                              ' 적중!',
                                              style: CTextStyle.light20.copyWith(height: 40 / 20, color: Colors.black),
                                            ),
                                          if (listEquals(pollData.join, finalChoice) == false)
                                            Text(
                                              ' 예상 실패...',
                                              style: CTextStyle.light20.copyWith(height: 40 / 20, color: Colors.black),
                                            ),
                                        ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Container(
                      width: 390 * screenRatio,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(36)),
                        color: CColor.lightGray,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                              child: Text(
                                '가장 인기 있는 아이템은?',
                                style: CTextStyle.light20.copyWith(height: 22 / 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height: 118.0 * sortItemData.length,
                              width: 390 * screenRatio - 40,
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortItemData.length,
                                  itemBuilder: (BuildContext ctx, int idx) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 10, 32, 0),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          SizedBox(
                                            width: 390 * screenRatio - 40 - 52,
                                            height: 108,
                                          ),
                                          Positioned(
                                            left: 0,
                                            child: Container(
                                                width: 88,
                                                height: 108,
                                                decoration:
                                                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 80,
                                                    height: 100,
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: NetworkImage(
                                                                  sortItemData[idx].id == -1 ? CIconPath.noBuy : sortItemData[idx].image ?? '',
                                                                ),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 80,
                                                            height: 20,
                                                            color: CColor.brightGray,
                                                            child: Center(
                                                              child: Text(
                                                                // 'c',
                                                                alphabetList[tempId.indexOf(sortItemData[idx].id!)],
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
                                          Positioned(
                                            left: 88 + 6 + 36 + 6,
                                            top: 23,
                                            child: SizedBox(
                                              width: 390 * screenRatio - 228,
                                              child: GestureDetector(
                                                onTap: (){
                                                  Get.find<PollDetailController>().seeDetail(sortItemData[idx].url);
                                                },
                                                child: Text(
                                                  sortItemData[idx].title ?? sortItemData[idx].url,
                                                  style: CTextStyle.bold12
                                                      .copyWith(height: 15 / 12, decoration: TextDecoration.underline, color: Colors.black),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              left: 94,
                                              top: 0,
                                              child: SizedBox(
                                                height: 95,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    if (idx == 0)
                                                      SvgPicture.asset(
                                                        CIconPath.crown,
                                                        width: 20,
                                                      ),
                                                    const SizedBox(height: 2),
                                                    idx == 0
                                                        ? Text(
                                                            '1st',
                                                            style: CTextStyle.heavy16.copyWith(fontSize: 20, color: CColor.lavender),
                                                          )
                                                        : idx == 1
                                                            ? Text(
                                                                '2nd',
                                                                style: CTextStyle.heavy16,
                                                              )
                                                            : idx == 2
                                                                ? Text(
                                                                    '3rd',
                                                                    style: CTextStyle.heavy16,
                                                                  )
                                                                : Text('${idx + 1}th', style: CTextStyle.heavy16),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      width: 36,
                                                      height: 36,
                                                      decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white),
                                                      child: Center(
                                                          child: SvgPicture.asset(
                                                        CIconPath.download26p,
                                                        width: 24,
                                                        color: Colors.black,
                                                      )),
                                                    )
                                                  ],
                                                ),
                                              )),
                                          Positioned(
                                              top: 59,
                                              left: 88 + 6 + 36 + 6,
                                              child: Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                                  pollData.items.length == 1
                                                      ? Container(
                                                          height: 36,
                                                          width: (390 * screenRatio - 228) /
                                                              sortItemData[0].numberOfVote! *
                                                              sortItemData[idx].numberOfVote!,
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                            color: idx == 0 && tempId.indexOf(sortItemData[idx].id!) == 0
                                                                ? const Color(0xff7080FC)
                                                                : idx == 0 && tempId.indexOf(sortItemData[idx].id!) == 1
                                                                    ? const Color(0xff19E4D0)
                                                                    : CColor.subLightGray,
                                                          ),
                                                        )
                                                      : pollData.items.length == 2
                                                          ? Container(
                                                              height: 36,
                                                              width: (390 * screenRatio - 228) /
                                                                  sortItemData[0].numberOfVote! *
                                                                  sortItemData[idx].numberOfVote!,
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                                color: idx == 0 && tempId.indexOf(sortItemData[idx].id!) == 0
                                                                    ? CColor.grassGreen
                                                                    : idx == 0 && tempId.indexOf(sortItemData[idx].id!) == 1
                                                                        ? CColor.lavender
                                                                        : CColor.subLightGray,
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 36,
                                                              width: (390 * screenRatio - 228) /
                                                                  sortItemData[0].numberOfVote! *
                                                                  sortItemData[idx].numberOfVote!,
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                                color: idx == 0 ? const Color(0xffF8A940) : CColor.subLightGray,
                                                              ),
                                                            ),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(sortItemData[idx].numberOfVote.toString()),
                                                    ],
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

List<String> alphabetList = List.generate(26, (index) {
  String alphabet = String.fromCharCode(65 + index);
  return alphabet;
});

void quickSort(List<Cart> arr, int low, int high) {
  if (low < high) {
    int partitionIndex = partition(arr, low, high);

    quickSort(arr, low, partitionIndex - 1);
    quickSort(arr, partitionIndex + 1, high);
  }
}

int partition(List<Cart> arr, int low, int high) {
  int pivot = arr[high].numberOfVote!;
  int i = low - 1;

  for (int j = low; j < high; j++) {
    if (arr[j].numberOfVote! >= pivot) {
      i++;
      swap(arr, i, j);
    }
  }

  swap(arr, i + 1, high);

  return i + 1;
}

void swap(List<Cart> arr, int i, int j) {
  Cart temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

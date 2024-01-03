import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shovving_web/local_repository.dart';
import 'package:shovving_web/main.dart';
import 'package:shovving_web/model/api_model/cart/cart.dart';
import 'package:shovving_web/model/api_model/poll/api_poll.dart';
import 'package:shovving_web/model/local_model/poll/poll.dart';
import 'package:shovving_web/model/local_model/poll_vote_data.dart';
import 'package:shovving_web/modules/poll/poll_detail/poll_detail_controller.dart';
import 'package:shovving_web/util/dio/dio_api.dart';
import 'package:shovving_web/util/safe_print.dart';
import 'package:http/http.dart' as http;
import '../../util/dio/api_constants.dart';

class PollRepository{
  static final PollRepository _repository = PollRepository._intrnal();
  factory PollRepository() => _repository;
  PollRepository._intrnal();

  Dio dio = HttpService().to();

  Future<Poll?> getPollById(int id) async {
    safePrint('@@@=>try get poll by id');

    final deviceInfoPlugin = DeviceInfoPlugin();
      final webInfo = await deviceInfoPlugin.webBrowserInfo;
     String? deviceToken = webInfo.userAgent?.replaceAll('/', '').replaceAll(' ', '').replaceAll(',', '-');
    try {
      final response = await dio.get('${APIConstants.pollWebGet}$id&$deviceToken');
      if (response.statusCode == 201 || response.statusCode == 200) {

        ApiPoll getApiPoll = ApiPoll.fromJson(response.data);

        List<String> novString = getApiPoll.numberOfVotes.split(',');
        List<int> novList = novString.map((string) => int.parse(string)).toList();

        List<int>? finalChoiceList;

        if(getApiPoll.finalChoice!=null&&getApiPoll.finalChoice!=''){
          List<String> finalChoiceString = getApiPoll.finalChoice!.split(',');
          finalChoiceList = finalChoiceString.map((string) => int.parse(string)).toList();
        }
        int likeLength = 0;
        if(getApiPoll.likes==null){
          likeLength =0;
        }else{
          likeLength=   getApiPoll.likes!.length;
        }

        ///아이템 순서 배치

        List<String> itemsIdStringList = getApiPoll.itemIds.split(',');
        itemsIdStringList.remove('');
        List<int> itemsIdList = [];
        for(int i=0; i<itemsIdStringList.length; i++){
          itemsIdList.add(int.parse(itemsIdStringList[i]));
        }

        List<Cart> tempItemList = [];

        for(int i=0; i<itemsIdList.length;i++){

          for(int j=0; j<getApiPoll.items.length; j++){
            if(itemsIdList[i] == getApiPoll.items[j].id){
              tempItemList.add(getApiPoll.items[j]);
            }
          }

        }



        final deviceInfoPlugin = DeviceInfoPlugin();
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        String? deviceToken = webInfo.userAgent?.replaceAll('/', '').replaceAll(' ', '').replaceAll(',', '-');


        LocalRepository localRepository = LocalRepository();

        List<int>? join = await localRepository.getPollVoteData(getApiPoll.id, deviceToken!);
        safePrint(join);

        Poll pollByID = Poll(
            id: getApiPoll.id,
            userId: getApiPoll.userId,
            pollComment: getApiPoll.pollComment,
            itemIds: getApiPoll.itemIds,
            numberOfVotes: novList,
            itemComment: getApiPoll.itemComment.split(','),
            isDeleted: getApiPoll.isDeleted,
            state: getApiPoll.state,
            profileImage: getApiPoll.profileImage,
            colorIndex: getApiPoll.colorIndex,
            createAt: getApiPoll.createdAt,
            updateAt: getApiPoll.updatedAt,
            items: tempItemList,
            finalChoice: finalChoiceList,
            finalComment: getApiPoll.finalComment,
            like: false,
            likeLength: likeLength,
            comments: getApiPoll.comments ?? [],
            isAlreadyVoted: getApiPoll.isAlreadyVoted,
            user: getApiPoll.user,
            votedUserDeviceToken: getApiPoll.votedUserDeviceToken??'',
            join: join
        );
        return pollByID;

      }else{
        return null;
      }
    } catch (e) {
      safePrint('error in get poll by id : $e');
    }
    return null;

  }

  Future<bool> joinPolls(List<int> join, int id, pollId) async {
    safePrint('@@@=>try join poll by id');

    final deviceInfoPlugin = DeviceInfoPlugin();
    final webInfo = await deviceInfoPlugin.webBrowserInfo;
    String? deviceToken = webInfo.userAgent?.replaceAll('/', '').replaceAll(' ', '').replaceAll(',', '-');

    try {
      final response = await dio.patch('${APIConstants.joinPoll}$id',
      data: {
        "joinData" : join.join(','),
        "votedUserDeviceToken": deviceToken
      }
      );

      if (response.statusCode == 201 || response.statusCode == 200) {

        safePrint('투표하기는 성공');

        LocalRepository localRepository = LocalRepository();
        await localRepository.setPollVoteData(pollId, deviceToken!, join);


        ///그리고 폴 데이터에 새로운 조인 업데이트 까지

        List<int>? tempJoin = await localRepository.getPollVoteData(pollId, deviceToken!);

        List<int> tempNov = [];

        for(int i=0; i<pollController.pollData!.numberOfVotes.length; i++){
          tempNov.add(pollController.pollData!.numberOfVotes[i]+tempJoin![i]);
        }

        ///nov 업데이트 해야합니다.



        pollController.pollData =pollController.pollData?.copyWith(join: tempJoin, numberOfVotes: tempNov,isAlreadyVoted: true);

        Get.find<PollDetailController>().setPollData(pollController.pollData!);

        pollController.update();
        Get.find<PollDetailController>().update();

        return true;
      }
    } catch (e) {
      safePrint('error in join poll by id : $e');
    }
    return false;
  }

}

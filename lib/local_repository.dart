import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shovving_web/model/local_model/poll_vote_data.dart';

class LocalRepository {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  setPollVoteData(int pollId, String deviceToken, List<int> join) async {

    var pref = await _pref;
    String? getData = pref.getString(pollId.toString());

    if(getData!=null){
      PollVoteData voteData = PollVoteData.fromJson(jsonDecode(getData));

      List<int> tempJoin = [];
      for(int i=0; i<join.length; i++){
        tempJoin.add(join[i]+voteData.join[i]);
      }

      PollVoteData tempData = PollVoteData(pollId: pollId, deviceToken: deviceToken, join: tempJoin,);
      await pref.setString(pollId.toString(), jsonEncode(tempData));
    }else{
      PollVoteData tempData = PollVoteData(pollId: pollId, deviceToken: deviceToken, join: join,);
      await pref.setString(pollId.toString(), jsonEncode(tempData));
    }
  }

  Future<List<int>?> getPollVoteData(int pollId, String deviceToken) async {
    var pref = await _pref;
    String? getData = pref.getString(pollId.toString());

    if(getData == null){
      return null;
    }else{
      PollVoteData voteData = PollVoteData.fromJson(jsonDecode(getData));
      return voteData.join;
    }
  }


}

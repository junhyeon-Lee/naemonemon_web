import 'package:freezed_annotation/freezed_annotation.dart';
part 'poll_vote_data.freezed.dart';
part 'poll_vote_data.g.dart';

@freezed
class PollVoteData with _$PollVoteData {
  factory PollVoteData({
    required int pollId,
    required String deviceToken,
    required List<int> join,
  }) = _PollVoteData;

  factory PollVoteData.fromJson(Map<String, dynamic> json) =>
      _$PollVoteDataFromJson(json);
}

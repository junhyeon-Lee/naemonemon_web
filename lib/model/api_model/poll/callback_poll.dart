import 'package:freezed_annotation/freezed_annotation.dart';
part 'callback_poll.freezed.dart';
part 'callback_poll.g.dart';

@freezed
class CallBackPoll with _$CallBackPoll {
  factory CallBackPoll({
    required int id,
    required int userId,
    required String pollComment,
    required String itemIds,
    required String numberOfVotes,
    required String itemComment,
    String? finalChoice,
    String? finalComment,
    required int isDeleted,
    required String state,
    required String profileImage,
    required int colorIndex,
    required String createdAt,
    String? updatedAt,
  }
      ) = _CallBackPoll;

  factory CallBackPoll.fromJson(Map<String, dynamic> json) => _$CallBackPollFromJson(json);
}


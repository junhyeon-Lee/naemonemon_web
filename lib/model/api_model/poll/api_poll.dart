import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shovving_web/model/api_model/cart/cart.dart';
import 'package:shovving_web/model/api_model/social/comment.dart';
import 'package:shovving_web/model/api_model/social/like.dart';
import 'package:shovving_web/model/api_model/users/poll_users_info.dart';
part 'api_poll.freezed.dart';
part 'api_poll.g.dart';

@freezed
class ApiPoll with _$ApiPoll {
  factory ApiPoll({
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
    required List<Cart> items,
    String? votedUserDeviceToken,
    required bool isAlreadyVoted,
    List<Like>? likes,
    List<Comment>? comments,
    PollUsersInfo? user


  }
  ) = _ApiPoll;

  factory ApiPoll.fromJson(Map<String, dynamic> json) => _$ApiPollFromJson(json);
}


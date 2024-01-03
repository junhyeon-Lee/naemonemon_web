// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_vote_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PollVoteData _$$_PollVoteDataFromJson(Map<String, dynamic> json) =>
    _$_PollVoteData(
      pollId: json['pollId'] as int,
      deviceToken: json['deviceToken'] as String,
      join: (json['join'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$$_PollVoteDataToJson(_$_PollVoteData instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'deviceToken': instance.deviceToken,
      'join': instance.join,
    };

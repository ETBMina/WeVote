// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      isPublic: json['isPublic'] as bool,
      isSecretVote: json['isSecretVote'] as bool,
      title: json['title'] as String,
      description: json['description'] as String,
      createdByEmail: json['createdByEmail'] as String,
      choices: Map<String, int>.from(json['choices'] as Map),
      isAddingChoicesAllowed: json['isAddingChoicesAllowed'] as bool,
      noOfChoicesToSelect: json['noOfChoicesToSelect'] as int,
      isOrderMaters: json['isOrderMaters'] as bool,
      rankingWeights: (json['rankingWeights'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      createdDateTime: DateTime.parse(json['createdDateTime'] as String),
      expirationDateTime: DateTime.parse(json['expirationDateTime'] as String),
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'isPublic': instance.isPublic,
      'isSecretVote': instance.isSecretVote,
      'title': instance.title,
      'description': instance.description,
      'createdByEmail': instance.createdByEmail,
      'choices': instance.choices,
      'isAddingChoicesAllowed': instance.isAddingChoicesAllowed,
      'noOfChoicesToSelect': instance.noOfChoicesToSelect,
      'isOrderMaters': instance.isOrderMaters,
      'rankingWeights': instance.rankingWeights,
      'createdDateTime': instance.createdDateTime.toIso8601String(),
      'expirationDateTime': instance.expirationDateTime.toIso8601String(),
    };

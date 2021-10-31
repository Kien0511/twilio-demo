import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:test_twilio/common/extensions/string_extensions.dart';
import 'package:test_twilio/model/reaction_attribute.dart';

@Entity(tableName: "message_table", primaryKeys: ["sid", "uuid"])
class MessageDataItem {
  String? sid;
  String? conversationSid;
  String? participantSid;
  int? type;
  String? author;
  int? dateCreated;
  String? body;
  int? index;
  String? attributes;
  int? direction;
  int? sendStatus;
  String? uuid;
  String? mediaSid;
  String? mediaFileName;
  String? mediaType;
  int? mediaSize;
  String? mediaUri;
  int? mediaDownloadId;
  int? mediaDownloadedBytes;
  int? mediaDownloadState = 0;
  bool? mediaUploading = false;
  int? mediaUploadedBytes;
  String? mediaUploadUri;
  int? errorCode = 0;

  @ignore
  MessageDataItem.fromMap(Map<String, dynamic> data) {
    sid = data["sid"]?.toString();
    conversationSid = data["conversationSid"]?.toString();
    participantSid = data["participantSid"]?.toString();
    type = data["type"]?.toString().toInt();
    author = data["author"]?.toString();
    dateCreated = data["dateCreated"]?.toString().toInt();
    body = data["body"]?.toString();
    index = data["index"]?.toString().toInt();
    attributes = data["attributes"]?.toString();
    direction = data["direction"]?.toString().toInt();
    sendStatus = data["sendStatus"]?.toString().toInt();
    uuid = data["uuid"]?.toString();
    mediaSid = data["mediaSid"]?.toString();
    mediaFileName = data["mediaFileName"]?.toString();
    mediaType = data["mediaType"]?.toString();
    mediaSize = data["mediaSize"]?.toString().toInt();
    mediaUri = data["mediaUri"]?.toString();
    mediaDownloadId = data["mediaDownloadId"]?.toString().toInt();
    mediaDownloadedBytes = data["mediaDownloadedBytes"]?.toString().toInt();
    mediaDownloadState = data["mediaDownloadState"]?.toString().toInt();
    mediaUploading = data["mediaUploading"]?.toString().toBool();
    mediaUploadedBytes = data["mediaUploadedBytes"]?.toString().toInt();
    mediaUploadUri = data["mediaUploadUri"]?.toString();
    errorCode = data["errorCode"]?.toString().toInt();
  }

  @ignore
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data["sid"] = sid;
    data["conversationSid"] = conversationSid;
    data["participantSid"] = participantSid;
    data["type"] = type;
    data["author"] = author;
    data["dateCreated"] = dateCreated;
    data["body"] = body;
    data["index"] = index;
    data["attributes"] = attributes;
    data["direction"] = direction;
    data["sendStatus"] = sendStatus;
    data["uuid"] = uuid;
    data["mediaSid"] = mediaSid;
    data["mediaFileName"] = mediaFileName;
    data["mediaType"] = mediaType;
    data["mediaSize"] = mediaSize;
    data["mediaUri"] = mediaUri;
    data["mediaDownloadId"] = mediaDownloadId;
    data["mediaDownloadedBytes"] = mediaDownloadedBytes;
    data["mediaDownloadState"] = mediaDownloadState;
    data["mediaUploading"] = mediaUploading;
    data["mediaUploadedBytes"] = mediaUploadedBytes;
    data["mediaUploadUri"] = mediaUploadUri;
    data["errorCode"] = errorCode;
    return data;
  }

  ReactionAttribute? toReactionAttribute() {
    try {
      return ReactionAttribute.fromJson(Map<String, dynamic>.from(jsonDecode(attributes!)));
    } catch (e) {
      return null;
    }
  }
}
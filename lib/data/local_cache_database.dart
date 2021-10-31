import 'dart:async';

import 'package:floor/floor.dart';
import 'package:test_twilio/data/dao/conversations_dao.dart';
import 'package:test_twilio/data/dao/messages_dao.dart';
import 'package:test_twilio/data/dao/participants_dao.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/data/entity/message_data_item.dart';
import 'package:test_twilio/data/entity/participant_data_item.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'local_cache_database.g.dart';

@Database(version: 1, entities: [ConversationDataItem, MessageDataItem, ParticipantDataItem])
abstract class LocalCacheDatabase extends FloorDatabase {
  ConversationsDao get conversationsDao;
  MessagesDao get messagesDao;
  ParticipantsDao get participantsDao;
}
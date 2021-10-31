import 'package:test_twilio/data/dao/conversations_dao.dart';
import 'package:test_twilio/data/dao/messages_dao.dart';
import 'package:test_twilio/data/dao/participants_dao.dart';
import 'package:test_twilio/data/local_cache_database.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  DatabaseHelper._internal();

  factory DatabaseHelper() => _databaseHelper;

  ConversationsDao? conversationsDao;
  MessagesDao? messagesDao;
  ParticipantsDao? participantsDao;

  Future<void> initDataBase() async {
    final data = await $FloorLocalCacheDatabase.databaseBuilder('app_database.db').build();
    conversationsDao = data.conversationsDao;
    messagesDao = data.messagesDao;
    participantsDao = data.participantsDao;
  }
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_cache_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorLocalCacheDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocalCacheDatabaseBuilder databaseBuilder(String name) =>
      _$LocalCacheDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocalCacheDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$LocalCacheDatabaseBuilder(null);
}

class _$LocalCacheDatabaseBuilder {
  _$LocalCacheDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$LocalCacheDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$LocalCacheDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<LocalCacheDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$LocalCacheDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$LocalCacheDatabase extends LocalCacheDatabase {
  _$LocalCacheDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ConversationsDao? _conversationsDaoInstance;

  MessagesDao? _messagesDaoInstance;

  ParticipantsDao? _participantsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversation_table` (`sid` TEXT, `friendlyName` TEXT, `attributes` TEXT, `uniqueName` TEXT, `dateUpdated` INTEGER, `dateCreated` INTEGER, `lastMessageDate` INTEGER, `lastMessageText` TEXT, `lastMessageSendStatus` INTEGER, `createdBy` TEXT, `participantsCount` INTEGER, `messagesCount` INTEGER, `unreadMessagesCount` INTEGER, `participatingStatus` INTEGER, `notificationLevel` INTEGER, PRIMARY KEY (`sid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `message_table` (`sid` TEXT, `conversationSid` TEXT, `participantSid` TEXT, `type` INTEGER, `author` TEXT, `dateCreated` INTEGER, `body` TEXT, `index` INTEGER, `attributes` TEXT, `direction` INTEGER, `sendStatus` INTEGER, `uuid` TEXT, `mediaSid` TEXT, `mediaFileName` TEXT, `mediaType` TEXT, `mediaSize` INTEGER, `mediaUri` TEXT, `mediaDownloadId` INTEGER, `mediaDownloadedBytes` INTEGER, `mediaDownloadState` INTEGER, `mediaUploading` INTEGER, `mediaUploadedBytes` INTEGER, `mediaUploadUri` TEXT, `errorCode` INTEGER, PRIMARY KEY (`sid`, `uuid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `participant_table` (`sid` TEXT, `identity` TEXT, `conversationSid` TEXT, `friendlyName` TEXT, `isOnline` INTEGER, `lastReadMessageIndex` INTEGER, `lastReadTimestamp` TEXT, `typing` INTEGER, PRIMARY KEY (`sid`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ConversationsDao get conversationsDao {
    return _conversationsDaoInstance ??=
        _$ConversationsDao(database, changeListener);
  }

  @override
  MessagesDao get messagesDao {
    return _messagesDaoInstance ??= _$MessagesDao(database, changeListener);
  }

  @override
  ParticipantsDao get participantsDao {
    return _participantsDaoInstance ??=
        _$ParticipantsDao(database, changeListener);
  }
}

class _$ConversationsDao extends ConversationsDao {
  _$ConversationsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _conversationDataItemInsertionAdapter = InsertionAdapter(
            database,
            'conversation_table',
            (ConversationDataItem item) => <String, Object?>{
                  'sid': item.sid,
                  'friendlyName': item.friendlyName,
                  'attributes': item.attributes,
                  'uniqueName': item.uniqueName,
                  'dateUpdated': item.dateUpdated,
                  'dateCreated': item.dateCreated,
                  'lastMessageDate': item.lastMessageDate,
                  'lastMessageText': item.lastMessageText,
                  'lastMessageSendStatus': item.lastMessageSendStatus,
                  'createdBy': item.createdBy,
                  'participantsCount': item.participantsCount,
                  'messagesCount': item.messagesCount,
                  'unreadMessagesCount': item.unreadMessagesCount,
                  'participatingStatus': item.participatingStatus,
                  'notificationLevel': item.notificationLevel
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ConversationDataItem>
      _conversationDataItemInsertionAdapter;

  @override
  Future<List<ConversationDataItem>> getUserConversations() async {
    return _queryAdapter.queryList(
        'SELECT * FROM conversation_table WHERE participatingStatus = 1 ORDER BY lastMessageDate DESC',
        mapper: (Map<String, Object?> row) => ConversationDataItem.fromMap(Map<String, dynamic>.from(row)));
  }

  @override
  Future<ConversationDataItem?> getConversation(String sid) async {
    return _queryAdapter.query(
        'SELECT * FROM conversation_table WHERE sid = ?1',
        mapper: (Map<String, Object?> row) => ConversationDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [sid]);
  }

  @override
  Future<void> update(
      String sid, int status, int level, String friendlyName) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE conversation_table SET participatingStatus = ?2, notificationLevel = ?3, friendlyName = ?4 WHERE sid = ?1',
        arguments: [sid, status, level, friendlyName]);
  }

  @override
  Future<void> updateParticipantCount(String sid, int participantsCount) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE conversation_table SET participantsCount = ?2 WHERE sid = ?1',
        arguments: [sid, participantsCount]);
  }

  @override
  Future<void> updateMessagesCount(String sid, int messagesCount) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE conversation_table SET messagesCount = ?2 WHERE sid = ?1',
        arguments: [sid, messagesCount]);
  }

  @override
  Future<void> updateUnreadMessagesCount(
      String sid, int unreadMessagesCount) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE conversation_table SET unreadMessagesCount = ?2 WHERE sid = ?1',
        arguments: [sid, unreadMessagesCount]);
  }

  @override
  Future<void> updateLastMessage(String sid, String lastMessageText,
      int lastMessageSendStatus, int lastMessageDate) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE conversation_table SET lastMessageText = ?2, lastMessageSendStatus = ?3, lastMessageDate = ?4 WHERE sid = ?1',
        arguments: [
          sid,
          lastMessageText,
          lastMessageSendStatus,
          lastMessageDate
        ]);
  }

  @override
  Future<void> delete(String sid) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM conversation_table WHERE sid = ?1',
        arguments: [sid]);
  }

  @override
  Future<void> deleteUserConversationsNotIn(List<String> sids) async {
    const offset = 1;
    final _sqliteVariablesForSids =
        Iterable<String>.generate(sids.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM conversation_table WHERE participatingStatus = 1 AND sid NOT IN (' +
            _sqliteVariablesForSids +
            ')',
        arguments: [...sids]);
  }

  @override
  Future<void> insertConversationsList(
      List<ConversationDataItem> conversationDataItemList) async {
    await _conversationDataItemInsertionAdapter.insertList(
        conversationDataItemList, OnConflictStrategy.replace);
  }

  @override
  Future<void> insert(ConversationDataItem conversationDataItem) async {
    await _conversationDataItemInsertionAdapter.insert(
        conversationDataItem, OnConflictStrategy.ignore);
  }
}

class _$MessagesDao extends MessagesDao {
  _$MessagesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _messageDataItemInsertionAdapter = InsertionAdapter(
            database,
            'message_table',
            (MessageDataItem item) => <String, Object?>{
                  'sid': item.sid,
                  'conversationSid': item.conversationSid,
                  'participantSid': item.participantSid,
                  'type': item.type,
                  'author': item.author,
                  'dateCreated': item.dateCreated,
                  'body': item.body,
                  'index': item.index,
                  'attributes': item.attributes,
                  'direction': item.direction,
                  'sendStatus': item.sendStatus,
                  'uuid': item.uuid,
                  'mediaSid': item.mediaSid,
                  'mediaFileName': item.mediaFileName,
                  'mediaType': item.mediaType,
                  'mediaSize': item.mediaSize,
                  'mediaUri': item.mediaUri,
                  'mediaDownloadId': item.mediaDownloadId,
                  'mediaDownloadedBytes': item.mediaDownloadedBytes,
                  'mediaDownloadState': item.mediaDownloadState,
                  'mediaUploading': item.mediaUploading == null
                      ? null
                      : (item.mediaUploading! ? 1 : 0),
                  'mediaUploadedBytes': item.mediaUploadedBytes,
                  'mediaUploadUri': item.mediaUploadUri,
                  'errorCode': item.errorCode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MessageDataItem> _messageDataItemInsertionAdapter;

  @override
  Future<List<MessageDataItem>> getMessagesSorted(
      String conversationSid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM message_table WHERE conversationSid = ?1 ORDER BY CASE WHEN `index` < 0 THEN dateCreated ELSE `index` END ASC',
        mapper: (Map<String, Object?> row) => MessageDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [conversationSid]);
  }

  @override
  Future<MessageDataItem?> getLastMessage(String conversationSid) async {
    return _queryAdapter.query(
        'SELECT * FROM message_table WHERE conversationSid = ?1 ORDER BY CASE WHEN `index` < 0 THEN dateCreated ELSE `index` END DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => MessageDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [conversationSid]);
  }

  @override
  Future<MessageDataItem?> getMessageBySid(String sid) async {
    return _queryAdapter.query('SELECT * FROM message_table WHERE sid = ?1',
        mapper: (Map<String, Object?> row) => MessageDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [sid]);
  }

  @override
  Future<MessageDataItem?> getMessageByUuid(String uuid) async {
    return _queryAdapter.query('SELECT * FROM message_table WHERE uuid = ?1',
        mapper: (Map<String, Object?> row) => MessageDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [uuid]);
  }

  @override
  Future<void> updateMessageStatus(
      String uuid, int sendStatus, int errorCode) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET sendStatus = ?2, errorCode = ?3 WHERE uuid = ?1',
        arguments: [uuid, sendStatus, errorCode]);
  }

  @override
  Future<void> updateByUuid(
      String sid, String uuid, int sendStatus, int index, int mediaSize) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET sid = ?1, sendStatus = ?3, `index` = ?4, mediaSize = ?5 WHERE uuid = ?2',
        arguments: [sid, uuid, sendStatus, index, mediaSize]);
  }

  @override
  Future<void> deleteMessage(String sid) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM message_table WHERE sid = ?1',
        arguments: [sid]);
  }

  @override
  Future<void> deleteMessageByUuid(String uuid) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM message_table WHERE uuid = ?1',
        arguments: [uuid]);
  }

  @override
  Future<void> updateMediaDownloadState(
      String messageSid, int downloadState) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET mediaDownloadState = ?2 WHERE sid = ?1',
        arguments: [messageSid, downloadState]);
  }

  @override
  Future<void> updateMediaDownloadedBytes(
      String messageSid, int downloadedBytes) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET mediaDownloadedBytes = ?2 WHERE sid = ?1',
        arguments: [messageSid, downloadedBytes]);
  }

  @override
  Future<void> updateMediaDownloadLocation(
      String messageSid, String location) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET mediaUri = ?2 WHERE sid = ?1',
        arguments: [messageSid, location]);
  }

  @override
  Future<void> updateMediaDownloadId(String messageSid, int downloadId) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET mediaDownloadId = ?2 WHERE sid = ?1',
        arguments: [messageSid, downloadId]);
  }

  @override
  Future<void> updateMediaUploadStatus(String uuid, bool downloading) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET mediaUploading = ?2 WHERE uuid = ?1',
        arguments: [uuid, downloading ? 1 : 0]);
  }

  @override
  Future<void> updateMediaUploadedBytes(
      String uuid, int downloadedBytes) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE message_table SET mediaUploadedBytes = ?2 WHERE uuid = ?1',
        arguments: [uuid, downloadedBytes]);
  }

  @override
  Future<void> insert(List<MessageDataItem> messages) async {
    await _messageDataItemInsertionAdapter.insertList(
        messages, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertOrReplace(MessageDataItem message) async {
    await _messageDataItemInsertionAdapter.insert(
        message, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateByUuidOrInsert(MessageDataItem message) async {
    if (database is sqflite.Transaction) {
      await super.updateByUuidOrInsert(message);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$LocalCacheDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.messagesDao.updateByUuidOrInsert(message);
      });
    }
  }
}

class _$ParticipantsDao extends ParticipantsDao {
  _$ParticipantsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _participantDataItemInsertionAdapter = InsertionAdapter(
            database,
            'participant_table',
            (ParticipantDataItem item) => <String, Object?>{
                  'sid': item.sid,
                  'identity': item.identity,
                  'conversationSid': item.conversationSid,
                  'friendlyName': item.friendlyName,
                  'isOnline':
                      item.isOnline == null ? null : (item.isOnline! ? 1 : 0),
                  'lastReadMessageIndex': item.lastReadMessageIndex,
                  'lastReadTimestamp': item.lastReadTimestamp,
                  'typing': item.typing == null ? null : (item.typing! ? 1 : 0)
                }),
        _participantDataItemDeletionAdapter = DeletionAdapter(
            database,
            'participant_table',
            ['sid'],
            (ParticipantDataItem item) => <String, Object?>{
                  'sid': item.sid,
                  'identity': item.identity,
                  'conversationSid': item.conversationSid,
                  'friendlyName': item.friendlyName,
                  'isOnline':
                      item.isOnline == null ? null : (item.isOnline! ? 1 : 0),
                  'lastReadMessageIndex': item.lastReadMessageIndex,
                  'lastReadTimestamp': item.lastReadTimestamp,
                  'typing': item.typing == null ? null : (item.typing! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ParticipantDataItem>
      _participantDataItemInsertionAdapter;

  final DeletionAdapter<ParticipantDataItem>
      _participantDataItemDeletionAdapter;

  @override
  Future<List<ParticipantDataItem>> getAllParticipants(
      String conversationSid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM participant_table WHERE conversationSid = ?1 ORDER BY friendlyName',
        mapper: (Map<String, Object?> row) => ParticipantDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [conversationSid]);
  }

  @override
  Future<List<ParticipantDataItem>> getTypingParticipants(
      String conversationSid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM participant_table WHERE conversationSid = ?1 AND typing',
        mapper: (Map<String, Object?> row) => ParticipantDataItem.fromMap(Map<String, dynamic>.from(row)),
        arguments: [conversationSid]);
  }

  @override
  Future<void> insertOrReplace(ParticipantDataItem participant) async {
    await _participantDataItemInsertionAdapter.insert(
        participant, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteParticipant(ParticipantDataItem participant) async {
    await _participantDataItemDeletionAdapter.delete(participant);
  }
}

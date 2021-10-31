import 'package:floor/floor.dart';
import 'package:test_twilio/data/entity/message_data_item.dart';

@dao
abstract class MessagesDao {
  @Query("SELECT * FROM message_table WHERE conversationSid = :conversationSid ORDER BY CASE WHEN `index` < 0 THEN dateCreated ELSE `index` END ASC")
  Future<List<MessageDataItem>> getMessagesSorted(String conversationSid);

  @Query("SELECT * FROM message_table WHERE conversationSid = :conversationSid ORDER BY CASE WHEN `index` < 0 THEN dateCreated ELSE `index` END DESC LIMIT 1")
  Future<MessageDataItem?> getLastMessage(String conversationSid);

  @Query("SELECT * FROM message_table WHERE sid = :sid")
  Future<MessageDataItem?> getMessageBySid(String sid);

  @Query("SELECT * FROM message_table WHERE uuid = :uuid")
  Future<MessageDataItem?> getMessageByUuid(String uuid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(List<MessageDataItem> messages);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrReplace(MessageDataItem message);

  @Query("UPDATE message_table SET sendStatus = :sendStatus, errorCode = :errorCode WHERE uuid = :uuid")
  Future<void> updateMessageStatus(String uuid, int sendStatus, int errorCode);

  @Query("UPDATE message_table SET sid = :sid, sendStatus = :sendStatus, `index` = :index, mediaSize = :mediaSize WHERE uuid = :uuid")
  Future<void> updateByUuid(String sid, String uuid, int sendStatus, int index, int mediaSize);

  @transaction
  Future<void> updateByUuidOrInsert(MessageDataItem message) async {
    if (message.uuid!.isNotEmpty && await getMessageByUuid(message.uuid!) != null) {
      await updateByUuid(message.sid!, message.uuid!, message.sendStatus!, message.index!, message.mediaSize ?? 0);
    } else {
      await insertOrReplace(message);
    }
  }

  @Query("DELETE FROM message_table WHERE sid = :sid")
  Future<void> deleteMessage(String sid);

  @Query("DELETE FROM message_table WHERE uuid = :uuid")
  Future<void> deleteMessageByUuid(String uuid);

  @Query("UPDATE message_table SET mediaDownloadState = :downloadState WHERE sid = :messageSid")
  Future<void> updateMediaDownloadState(String messageSid, int downloadState);

  @Query("UPDATE message_table SET mediaDownloadedBytes = :downloadedBytes WHERE sid = :messageSid")
  Future<void> updateMediaDownloadedBytes(String messageSid, int downloadedBytes);

  @Query("UPDATE message_table SET mediaUri = :location WHERE sid = :messageSid")
  Future<void> updateMediaDownloadLocation(String messageSid, String location);

  @Query("UPDATE message_table SET mediaDownloadId = :downloadId WHERE sid = :messageSid")
  Future<void> updateMediaDownloadId(String messageSid, int downloadId);

  @Query("UPDATE message_table SET mediaUploading = :downloading WHERE uuid = :uuid")
  Future<void> updateMediaUploadStatus(String uuid, bool downloading);

  @Query("UPDATE message_table SET mediaUploadedBytes = :downloadedBytes WHERE uuid = :uuid")
  Future<void> updateMediaUploadedBytes(String uuid, int downloadedBytes);
}
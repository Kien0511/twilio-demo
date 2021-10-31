import 'package:floor/floor.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';

@dao
abstract class ConversationsDao {
  @Query("SELECT * FROM conversation_table WHERE participatingStatus = 1 ORDER BY lastMessageDate DESC")
  Future<List<ConversationDataItem>> getUserConversations();

  @Query("SELECT * FROM conversation_table WHERE sid = :sid")
  Future<ConversationDataItem?> getConversation(String sid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertConversationsList(List<ConversationDataItem> conversationDataItemList);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insert(ConversationDataItem conversationDataItem);

  @Query("UPDATE conversation_table SET participatingStatus = :status, notificationLevel = :level, friendlyName = :friendlyName WHERE sid = :sid")
  Future<void> update(String sid, int status, int level, String friendlyName);

  @Query("UPDATE conversation_table SET participantsCount = :participantsCount WHERE sid = :sid")
  Future<void> updateParticipantCount(String sid, int participantsCount);

  @Query("UPDATE conversation_table SET messagesCount = :messagesCount WHERE sid = :sid")
  Future<void> updateMessagesCount(String sid, int messagesCount);

  @Query("UPDATE conversation_table SET unreadMessagesCount = :unreadMessagesCount WHERE sid = :sid")
  Future<void> updateUnreadMessagesCount(String sid, int unreadMessagesCount);

  @Query("UPDATE conversation_table SET lastMessageText = :lastMessageText, lastMessageSendStatus = :lastMessageSendStatus, lastMessageDate = :lastMessageDate WHERE sid = :sid")
  Future<void> updateLastMessage(String sid, String lastMessageText, int lastMessageSendStatus, int lastMessageDate);

  @Query("DELETE FROM conversation_table WHERE sid = :sid")
  Future<void> delete(String sid);

  @Query("DELETE FROM conversation_table WHERE participatingStatus = 1 AND sid NOT IN (:sids)")
  Future<void> deleteUserConversationsNotIn(List<String> sids);

  Future<void> deleteGoneUserConversations(List<ConversationDataItem> newConversations) async {
    deleteUserConversationsNotIn(newConversations.map((e) => e.sid!).toList());
  }
}
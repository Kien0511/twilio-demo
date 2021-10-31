import 'package:floor/floor.dart';
import 'package:test_twilio/data/entity/participant_data_item.dart';

@dao
abstract class ParticipantsDao {
  @Query("SELECT * FROM participant_table WHERE conversationSid = :conversationSid ORDER BY friendlyName")
  Future<List<ParticipantDataItem>> getAllParticipants(String conversationSid);

  @Query("SELECT * FROM participant_table WHERE conversationSid = :conversationSid AND typing")
  Future<List<ParticipantDataItem>> getTypingParticipants(String conversationSid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrReplace(ParticipantDataItem participant);

  @delete
  Future<void> deleteParticipant(ParticipantDataItem participant);
}
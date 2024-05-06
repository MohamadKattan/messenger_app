
import 'package:messenger_test/utils/constants.dart';

class CallModel {
  String? callerId;
  String? callerName;
  String? voiceCaller;
  String? voiceReciver;
  String? toAccept;
  CallModel(
      {this.callerId,
      this.callerName,
      this.voiceCaller,
      this.voiceReciver,
      this.toAccept});

  CallModel.fromMap(Map<String, dynamic> map) {
    callerId = map[keyCallerId];
    callerName = map[keyCallerName];
    voiceCaller = map[keyVoiceCaller];
    voiceReciver = map[keyVoiceReciver];
    toAccept = map[keyToAccept];
  }
}

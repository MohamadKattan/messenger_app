import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:audioplayers/audioplayers.dart' as audiopp;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:messenger_test/controllers%20/one_chat_controller.dart';
import 'package:messenger_test/models/call_model.dart';
import 'package:messenger_test/routing/routing_name.dart';
import 'package:messenger_test/utils/constants.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class CallVoiceController extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();

  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer mPlayer = FlutterSoundPlayer();
  bool mPlayerIsInited = false;
  double mSpeed = 100.0;
  int tSampleRate = 44000;
  int tBlockSize = 4096;
  bool mEnableVoiceProcessing = false;
  StreamSubscription? _mRecordingDataSubscription;

  String userId = auth.currentUser?.uid ?? "null";
  String? receiverIdStream;
  bool _louding = false;
  bool get louding => _louding;

  bool _muted = false;
  bool get muted => _muted;

  bool _speaker = false;
  bool get speaker => _speaker;

  Timer? newtimer;

  int _secondTimeOfCALL = 0;
  int _minTimeOfCALL = 0;
  int _houerTimeOfCALL = 0;
  int count = 30;
  String? _resutlTimeOfCall;
  String? get resutlTimeOfCall => _resutlTimeOfCall;

  bool _iAmCalling = false;
  bool get iAmCalling => _iAmCalling;

  String? _callStatusOfReciver;
  String? get callStatusOfReciver => _callStatusOfReciver;

  StreamSubscription<DocumentSnapshot>? callStatusReciverStream;
  StreamSubscription<DatabaseEvent>? notifyNewCallStream;

  CallModel? _callModel;
  CallModel? get callModel => _callModel;

  bool _isAccpted = false;
  bool get isAccpted => _isAccpted;

  void _listingLoudingStatus(bool state) {
    _louding = state;
    notifyListeners();
  }

  Future _updateCallStatusOnUserTable(String id, String status) async {
    try {
      await firestore
          .collection(usersTable)
          .doc(id)
          .update({keyCallStatus: status});
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future _setDataOfCallToCallTable(String reciverId) async {
    Map<String, dynamic> data = {
      keyCallerId: userId,
      keyCallerName: currentName,
      keyVoiceCaller: '',
      keyVoiceReciver: '',
      keyToAccept: "wait"
    };
    try {
      await database.ref(callTable).child(reciverId).set(data);
      // await firestore.collection(callTable).doc(reciverId).set(data);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future _deleteDataOfCallTable(String id) async {
    if (id != 'null') {
      try {
        database.ref(callTable).child(id).remove();
        // await firestore.collection(callTable).doc(userId).delete();
      } catch (e) {
        debugPrint('_deleteDataOfCallTable :: $e');
        rethrow;
      }
    }
  }

  String displayName(String? receiverName) {
    String name = 'null';
    if (_iAmCalling) {
      name = receiverName ?? "***";
    } else {
      name = _callModel?.callerName ?? '***';
    }
    return name;
  }

  void _listingToTimeOfCall() {
    newtimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondTimeOfCALL++;
      if (_secondTimeOfCALL >= 60) {
        _minTimeOfCALL++;
        _secondTimeOfCALL = 0;
      }

      if (_minTimeOfCALL >= 60) {
        _minTimeOfCALL = 0;
        _houerTimeOfCALL++;
      }
      _resutlTimeOfCall =
          "0$_houerTimeOfCALL:${_minTimeOfCALL > 9 ? _minTimeOfCALL : '0$_minTimeOfCALL'}:${_secondTimeOfCALL > 9 ? _secondTimeOfCALL : '0$_secondTimeOfCALL'}";
      _listingLoudingStatus(true);
    });
  }

  void listingToMutedMic() {
    _muted = !muted;
    if (_muted) {
      mRecorder?.pauseRecorder();
      if (_mRecordingDataSubscription != null) {
        _mRecordingDataSubscription!.pause();
      }
    } else {
      if (_mRecordingDataSubscription != null) {
        _mRecordingDataSubscription!.resume();
      }
      mRecorder?.resumeRecorder();
    }

    _listingLoudingStatus(true);
  }

  void listingToSpeaker() {
    _speaker = !_speaker;
    _listingLoudingStatus(true);
  }

  Future<void> _listingIfIamCalling() async {
    _iAmCalling = !_iAmCalling;
    if (userId != "null") {
      _updateCallStatusOnUserTable(userId, "hasCall");
    }
  }

  Future<void> listingToAcceptCall() async {
    try {
      await firestore
          .collection(usersTable)
          .doc(userId)
          .get()
          .then((value) async {
        if (value.exists && value.data() != null) {
          String checkSttaus = value.data()?['call_status'];
          if (checkSttaus == 'ringing') {
            await firestore
                .collection(usersTable)
                .doc(userId)
                .update({keyCallStatus: "accepted"});
            _isAccpted = false;
            _listingToTimeOfCall();
            _listingLoudingStatus(true);
            await recordVoiceCall(mRecorder);
            startAudioStreaming(userId);
          } else {
            _callStatusOfReciver = 'call time out';
            _isAccpted = false;
            _listingLoudingStatus(true);
          }
        }
      });
    } catch (e) {
      debugPrint('listingToAcceptCall :: $e');
      rethrow;
    }
  }

  Future<void> listingToEndingCall() async {
    if (newtimer != null) {
      newtimer!.cancel();
    }

    if (userId != "null") {
      await _updateCallStatusOnUserTable(userId, "ended");
      await _updateCallStatusOnUserTable(userId, "waiting");
      await _deleteDataOfCallTable(userId);

      if (callStatusReciverStream != null) {
        callStatusReciverStream?.cancel();
      }

      if (receiverIdStream != null) {
        await _updateCallStatusOnUserTable(receiverIdStream!, "waiting");
        await _deleteDataOfCallTable(receiverIdStream!);
      }
      rest();
      stopAudioRecording();
      stopAudioStreaming();
      _listingLoudingStatus(true);
    }
  }

  void _timerWaitingAnswering(
      String receiverId, String? chatId, String? receiverName) {
    Timer? counter;
    counter = Timer.periodic(const Duration(seconds: 1), (timer) async {
      count--;
      if (count <= 0) {
        if (counter != null) {
          counter.cancel();
        }
        count = 40;
        if (_callStatusOfReciver == 'Ringing') {
          callStatusReciverStream?.cancel();
          await _updateCallStatusOnUserTable(userId, "waiting");
          await _updateCallStatusOnUserTable(receiverId, "waiting");
          if (receiverIdStream != null) {
            await _deleteDataOfCallTable(receiverIdStream!);
          }
          await OneChatController().addNewMsgToOneChat(
              newMsg: ' 📞 مكالمة فائتة',
              chatIdR: chatId ?? 'null',
              receiverIdR: receiverId,
              reciverNameR: receiverName ?? 'null');
          _callStatusOfReciver = 'No answer';
          _listingLoudingStatus(true);
          rest();
        } else {
          return;
        }
      }
    });
  }

  Future<void> listingToCallStatusOfReciver(String receiverId,
      BuildContext context, String? chatId, String? receiverName) async {
    try {
      receiverIdStream = receiverId;
      await _listingIfIamCalling();
      _timerWaitingAnswering(receiverId, chatId, receiverName);
      callStatusReciverStream = firestore
          .collection(usersTable)
          .doc(receiverId)
          .snapshots()
          .listen((snap) async {
        String checkStatus = snap.data()?['call_status'];
        switch (checkStatus) {
          case "waiting":
            await _updateCallStatusOnUserTable(receiverId, "ringing");
            await _setDataOfCallToCallTable(receiverId);
            break;
          case 'ringing':
            _callStatusOfReciver = 'Ringing';
            _listingLoudingStatus(true);
            break;
          case "accepted":
            _callStatusOfReciver = checkStatus;
            _listingToTimeOfCall();
            _listingLoudingStatus(true);
            await recordVoiceCall(mRecorder);
            startAudioStreaming(receiverId);
            break;
          case "ended":
            callStatusReciverStream?.cancel();
            _callStatusOfReciver = checkStatus;
            _resutlTimeOfCall = "00:00:00";
            _listingLoudingStatus(true);
            if (newtimer != null) {
              newtimer!.cancel();
            }
            _iAmCalling = !_iAmCalling;
            await _updateCallStatusOnUserTable(userId, "waiting");
            await stopAudioRecording();
            stopAudioStreaming();
            break;
          default:
            _callStatusOfReciver = null;
            _listingLoudingStatus(true);
            return;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      callStatusReciverStream?.cancel();
      rethrow;
    }
  }

  Future<void> notifyNewCall(BuildContext context) async {
    try {
      notifyNewCallStream =
          database.ref(callTable).child(userId).onValue.listen((snap) async {
        if (snap.snapshot.value != null) {
          final newVal = snap.snapshot.value;
          Map<Object?, Object?> dataMap = newVal as Map<Object?, Object?>;
          Map<String, dynamic> data = dataMap.map((key, value) {
            return MapEntry(key.toString(), value);
          });
          _callModel = CallModel.fromMap(data);
          if (_callModel?.toAccept == 'wait') {
            _isAccpted = true;
            await database
                .ref(callTable)
                .child(userId)
                .update({keyToAccept: "accepted"});
            if (!context.mounted) return;
            if (notifyNewCallStream != null) notifyNewCallStream?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context, rCallScreen, (route) => false);
          }
        } else {
          _callModel = null;
          _isAccpted = false;
          return;
        }
      });
    } catch (e) {
      debugPrint('notifyNewCall :: $e');
      rethrow;
    }
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await mRecorder?.openRecorder();
    await mPlayer.openPlayer();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> recordVoiceCall(FlutterSoundRecorder? recorder) async {
    StreamController<Food> recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) async {
      if (buffer is FoodData) {
        if (buffer.data != null) {
          await uploadAudioChunkToFirestore(buffer.data);
        }
      }
    });
    await mRecorder?.startRecorder(
        toStream: recordingDataController.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: tSampleRate,
        enableVoiceProcessing: mEnableVoiceProcessing);
  }

  Future<void> uploadAudioChunkToFirestore(Uint8List? data) async {
    _mRecordingDataSubscription?.pause();

    await Future.delayed(const Duration(seconds: 1));
    String base64Data = data != null ? base64Encode(data) : '';

    try {
      if (receiverIdStream != null) {
        await database
            .ref(callTable)
            .child(receiverIdStream!)
            .update({keyVoiceCaller: base64Data});
      } else {
        await database
            .ref(callTable)
            .child(userId)
            .update({keyVoiceReciver: base64Data});
      }
      _mRecordingDataSubscription?.resume();
    } catch (e) {
      debugPrint('error uploadAudioChunkToFirestore ::: $e');
    }
  }

  Future<void> stopAudioRecording() async {
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }

    if (mRecorder != null) {
      await mRecorder?.stopRecorder();
      // _mRecorder?.closeRecorder();
      // _mRecorder = null;
    }
  }

  void feedHim(Uint8List data) {
    var start = 0;
    var totalLength = data.length;
    while (totalLength > 0 && !mPlayer.isStopped) {
      var ln = totalLength > tBlockSize ? tBlockSize : totalLength;
      mPlayer.foodSink!.add(FoodData(data.sublist(start, start + ln)));
      totalLength -= ln;
      start += ln;
    }
  }

  void startAudioStreaming(String id) {
    String? audio;
    database.ref(callTable).child(id).onValue.listen((data) async {
      if (data.snapshot.exists && data.snapshot.value != null) {
        Map<Object?, Object?> newSnap =
            data.snapshot.value as Map<Object?, Object?>;
        Map<String, dynamic> res = newSnap.map((key, value) {
          return MapEntry(key.toString(), value);
        });
        _callModel = CallModel.fromMap(res);

        audio = iAmCalling
            ? _callModel?.voiceReciver ?? ''
            : _callModel?.voiceReciver ?? '';
        if (audio == null) return;
        Uint8List audioData = base64Decode(audio!);
        // final tempDir = await getTemporaryDirectory();
        // final tempFile = File('${tempDir.path}/temp_audio.pcm');
        // await tempFile.writeAsBytes(audioData);
        // await audioPlayer.setFilePath(tempFile.path);
        // audioPlayer.play();
        await mPlayer.startPlayerFromStream(
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: tSampleRate,
          bufferSize: 100000,
        );
        _listingLoudingStatus(true);
        var dataSound = audioData;
        feedHim(dataSound);
           //if (_mPlayer != null) {
      // We must not do stopPlayer() directely //await stopPlayer();
      mPlayer.foodSink!.add(FoodEvent(() async {
       
      }));
    //}
      }
    });
  }

  void stopAudioStreaming() {
    audioPlayer.stop();
    audioPlayer.dispose();
  }

  Future<void> rest() async {
    _isAccpted = false;
    _iAmCalling = false;
    _callStatusOfReciver = null;
    receiverIdStream = null;
    _muted = false;
    _resutlTimeOfCall = "00:00:00";
    _secondTimeOfCALL = 0;
    _minTimeOfCALL = 0;
    _houerTimeOfCALL = 0;
    count = 40;
    // await _mRecorder?.stopRecorder();
    // await _mRecordingDataSubscription?.cancel();
    await _updateCallStatusOnUserTable(userId, "waiting");
    await _deleteDataOfCallTable(userId);
  }
}

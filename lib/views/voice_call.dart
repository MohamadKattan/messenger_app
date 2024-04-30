// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:audio_recorder/audio_recorder.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: VoiceCallScreen(),
//     );
//   }
// }

// class VoiceCallScreen extends StatefulWidget {
//   @override
//   _VoiceCallScreenState createState() => _VoiceCallScreenState();
// }

// class _VoiceCallScreenState extends State<VoiceCallScreen> {
//   AudioPlayer? audioPlayer;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference callCollection;
//   StreamSubscription<DocumentSnapshot> callStream;
//   bool isCallActive = false;

//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     callCollection = firestore.collection('calls');
//     startCallListener();
//   }

//   void startCall() {
//     callCollection.add({'status': 'initiated'});
//     startAudioRecording();
//   }

//   void endCall() {
//     callCollection.add({'status': 'ended'});
//     stopAudioRecording();
//   }

//   void startCallListener() {
//     callStream = callCollection.snapshots().listen((snapshot) {
//       snapshot.docChanges.forEach((change) {
//         if (change.doc.data()['status'] == 'initiated') {
//           if (!isCallActive) {
//             isCallActive = true;
//             startAudioStreaming();
//           }
//         } else if (change.doc.data()['status'] == 'ended') {
//           if (isCallActive) {
//             isCallActive = false;
//             stopAudioStreaming();
//           }
//         }
//       });
//     });
//   }

//   void startAudioStreaming() {
//     callCollection.doc('audio_data').snapshots().listen((snapshot) {
//       if (snapshot.exists) {
//         List<int> audioBytes = snapshot.data()['audio_bytes'];
//         audioPlayer.setAudioSource(
//           AudioSource.fromBytes(
//             Uint8List.fromList(audioBytes),
//             tag: 'live_audio_stream',
//           ),
//         );
//         audioPlayer?.play();
//       }
//     });
//   }

//   void stopAudioStreaming() {
//     audioPlayer.stop();
//   }

//   void startAudioRecording() async {
//     if (await AudioRecorder.hasPermissions) {
//       await AudioRecorder.start();
//       AudioRecorder.onDataChunk.listen((chunk) {
//         uploadAudioChunk(chunk);
//       });
//     }
//   }

//   void stopAudioRecording() async {
//     await AudioRecorder.stop();
//   }

//   void uploadAudioChunk(Uint8List chunk) {
//     callCollection.doc('audio_data').set({'audio_bytes': chunk});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Voice Call')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: startCall,
//               child: Text('Start Call'),
//             ),
//             ElevatedButton(
//               onPressed: endCall,
//               child: Text('End Call'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     callStream.cancel();
//     audioPlayer.dispose();
//     super.dispose();
//   }
// }

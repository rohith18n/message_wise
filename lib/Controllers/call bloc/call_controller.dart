// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_wise/models/call_model.dart';
import 'package:message_wise/service/call/call_services.dart';
import 'package:uuid/uuid.dart';

class CallController {
  final CallRepository callRepository = CallRepository();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  final firestore = FirebaseFirestore.instance;

  Future<void> makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String receiverProfilePic,
    bool isGroupChat,
  ) async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    var name = userData.data()?['userName'];
    var profilePic = userData.data()?['photo'];

    String callId = const Uuid().v1();
    Call senderCallData = Call(
      callerId: auth.currentUser!.uid,
      callerName: name,
      callerPic: profilePic,
      receiverId: receiverUid,
      receiverName: receiverName,
      receiverPic: receiverProfilePic,
      callId: callId,
      hasDialled: true,
    );

    Call receiverCallData = Call(
      callerId: auth.currentUser!.uid,
      callerName: name,
      callerPic: profilePic,
      receiverId: receiverUid,
      receiverName: receiverName,
      receiverPic: receiverProfilePic,
      callId: callId,
      hasDialled: false,
    );

    if (isGroupChat) {
      // Handle group chat logic
      return;
    } else {
      callRepository.makeCall(senderCallData, context, receiverCallData);
    }
  }

  void endCall(String callerId, String receiverId, BuildContext context) {
    callRepository.endCall(callerId, receiverId, context);
  }
}

//
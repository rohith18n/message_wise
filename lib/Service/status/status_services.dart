import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:message_wise/Models/status_model.dart';
import 'package:message_wise/Service/posts/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreStatusMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadStatus(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error has occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('status', file, true);
      String statusId = const Uuid().v1(); // creates unique id based on time

      // Calculate the deletion timestamp (24 hours from now)
      final deletionTimestamp =
          DateTime.now().toUtc().add(const Duration(hours: 24));

      Status status = Status(
        description: description,
        uid: uid,
        username: username,
        statusId: statusId,
        datePublished: DateTime.now(),
        statusUrl: photoUrl,
        profImage: profImage,
        deletionTimestamp: deletionTimestamp, // Add this field
      );

      await _firestore.collection('status').doc(statusId).set(status.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete status
  Future<String> deleteStatus(String statusId) async {
    String res = "Some error has occurred";
    try {
      await _firestore.collection('status').doc(statusId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

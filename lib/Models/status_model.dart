import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String description;
  final String uid;
  final String username;
  final String statusId;
  final DateTime datePublished;
  final String statusUrl;
  final String profImage;
  final DateTime deletionTimestamp;

  const Status({
    required this.description,
    required this.uid,
    required this.username,
    required this.statusId,
    required this.datePublished,
    required this.statusUrl,
    required this.profImage,
    required this.deletionTimestamp,
  });

  static Status fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Status(
      description: snapshot["description"],
      uid: snapshot["uid"],
      statusId: snapshot["StatusId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      statusUrl: snapshot['StatusUrl'],
      profImage: snapshot['profImage'],
      deletionTimestamp: snapshot['deletionTimestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "statusId": statusId,
        "datePublished": datePublished,
        'statusUrl': statusUrl,
        'profImage': profImage,
        'deletionTimestamp': deletionTimestamp,
      };
}

//Users
import 'package:cloud_firestore/cloud_firestore.dart';

class UserMap {
  late String displayName;
  late String? email;
  late bool emailVerified;
  late bool isAnonymous;
  late String creationTime;
  late String id;

  UserMap({
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.isAnonymous,
    required this.creationTime,
    required this.id,
  });

  @override
  String toString() {
    return 'UserMap{displayName: $displayName, email: $email, emailVerified: $emailVerified, '
        'isAnonymous: $isAnonymous, creationTime: $creationTime, id: $id}';
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'creationTime': creationTime,
      'uid': id,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'creationTime': creationTime,
      'id': id,
    };
  }

  UserMap.fromMap(Map<String, dynamic> userMap)
      : displayName = userMap["displayName"],
        email = userMap["email"],
        emailVerified = userMap["emailVerified"],
        isAnonymous = userMap["isAnonymous"],
        creationTime = userMap["creationTime"],
        id = userMap["id"];

  UserMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        email = doc.data()!["email"],
        displayName = doc.data()!["displayName"],
        emailVerified = doc.data()!["emailVerified"],
        isAnonymous = doc.data()!["isAnonymous"],
        creationTime = doc.data()!["creationTime"];
}

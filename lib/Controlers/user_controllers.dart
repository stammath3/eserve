import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/models.dart';

//Users

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<UserMap> createUser(User dbuser) async {
  final usermap = UserMap(
      //displayName: dbuser.displayName,
      email: dbuser.email,
      emailVerified: dbuser.emailVerified,
      isAnonymous: dbuser.isAnonymous,
      creationTime: dbuser.metadata.creationTime.toString(),
      uid: dbuser.uid);

  var userRef = addUser(usermap);

  log(userRef.toString());
  return usermap;
}

Future<DocumentReference<Object?>> addUser(UserMap userData) async {
  var documentReference = await _db.collection("users").add(userData.toMap());
  return documentReference;
}

//   updateEmployee(User userData) async {
//   await _db.collection("users").doc("edw_thelei to doc id tou user").update(userData.toMap());
// }

Future<void> deleteUser(String documentId) async {
  await _db.collection("users").doc(documentId).delete();
}

Future<List<UserMap>> retrieveUsers() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("users").get();
  return snapshot.docs
      .map((docSnapshot) => UserMap.fromDocumentSnapshot(docSnapshot))
      .toList();
}

Future<List<UserMap>> getAllUsers() async {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  try {
    QuerySnapshot<Object?> querySnapshot = await usersCollection.get();
    if (querySnapshot != null) {
      log('not null');
      // Rest of your code...
    } else {
      log('Query snapshot is null.');
      return [];
    }

    List<UserMap> users = querySnapshot.docs
        .map((doc) => UserMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    log('usersssssssssssssssss');
    log(users.toString());
    return users;
  } catch (e) {
    print('Error fetching users: $e');
    return [];
  }
}

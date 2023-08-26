import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/user_model.dart';

//Users

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<UserMap> createUser(User dbuser, String? name) async {
  final usermap = UserMap(
    displayName: name ?? "",
    email: dbuser.email,
    emailVerified: dbuser.emailVerified,
    isAnonymous: dbuser.isAnonymous,
    creationTime: dbuser.metadata.creationTime.toString(),
    id: dbuser.uid,
  );

  var userRef = addUser(usermap);

  log(userRef.toString());
  return usermap;
}

Future<DocumentReference<Object?>> addUser(UserMap userData) async {
  var documentReference = await _db.collection("users").add(userData.toMap());
  return documentReference;
}

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
    log("Usersssssssssss");
    log(users.toString());
    return users;
  } catch (e) {
    log('Error fetching users: $e');
    return [];
  }
}

Future<UserMap?> getUserByDocID(String userID) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    if (userSnapshot.exists) {
      return UserMap.fromDocumentSnapshot(userSnapshot);
    } else {
      print('User with ID $userID not found.');
      return null; // Return null if user doesn't exist
    }
  } catch (e) {
    print('Error fetching user: $e');
    return null; // Return null in case of an error
  }
}

Future<UserMap?> getUserByID(String userID) async {
  try {
    QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: userID)
            .limit(1) // Limit to one document (optional)
            .get();

    if (userSnapshot.docs.isNotEmpty) {
      // Get the first document from the query results
      return UserMap.fromDocumentSnapshot(userSnapshot.docs[0]);
    } else {
      print('User with UID $userID not found.');
      return null; // Return null if user doesn't exist
    }
  } catch (e) {
    print('Error fetching user: $e');
    return null; // Return null in case of an error
  }
}

Future<void> updateUserProfile(
    String uid, String email, String displayName) async {
  try {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'email': email,
      'displayName': displayName,
    });

    print('User profile updated successfully');
  } catch (e) {
    print('Error updating user profile: $e');
    // Handle error appropriately
  }
}

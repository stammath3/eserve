import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_serve/View/login_view.dart';
import 'package:e_serve/View/stores_view.dart';
import 'package:e_serve/View/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

// collection id's
const String usersId = 'F9QjLSoF18meGuqhA9dI';
const String clientsId = 'OuVmsSqP8wi1UIKecHyN';
const String storesId = 'iEf4tTkEFAhNBDYogN3j';
const String ordersId = 'cRxdxvznLg6mRmWAvNEM';

// const String users_id = 'F9QjLSoF18meGuqhA9dI';
// const String clients_id = 'OuVmsSqP8wi1UIKecHyN';
// const String stores_id = 'iEf4tTkEFAhNBDYogN3j';

// // late String displayName;
// // late String email;
// // late String emailVerified;
// // late String isAnonymous;
// // late String creationTime;
// // late String uid;

// // Map<String, dynamic> userMap = {
// //   "id": uid,
// //   "email": email,
// //   "emailVerified": emailVerified,
// //   "isAnonymous": isAnonymous,
// //   "creationTime": creationTime,
// //   "createdOn": FieldValue.serverTimestamp()
// // };

// Future<UserMap> initAndCreateUser(User dbuser) async {
//   //late UserMap usermap;
//   final usermap = UserMap(
//       displayName: dbuser.displayName,
//       email: dbuser.email,
//       emailVerified: dbuser.emailVerified,
//       isAnonymous: dbuser.isAnonymous,
//       creationTime: dbuser.metadata.creationTime.toString(),
//       uid: dbuser.uid);
//   //var ref = addUser(usermap);
//   var userRef = addUser(usermap);
//   //var userRef =
//   //    await FirebaseFirestore.instance.collection("users").add(usermap.toMap());
//   log(userRef.toString());
//   return usermap;
// }

// class UserMap {
//   late String? displayName;
//   late String? email;
//   late bool emailVerified;
//   late bool isAnonymous;
//   late String creationTime;
//   late String uid;

//   UserMap({
//     required this.displayName,
//     required this.email,
//     required this.emailVerified,
//     required this.isAnonymous,
//     required this.creationTime,
//     required this.uid,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'displayName': displayName,
//       'email': email,
//       'emailVerified': emailVerified,
//       'isAnonymous': isAnonymous,
//       'creationTime': creationTime,
//       'uid': uid,
//     };
//   }

//   UserMap.fromMap(Map<String, dynamic> userMap)
//       : displayName = userMap["displayName"],
//         email = userMap["email"],
//         emailVerified = userMap["emailVerified"],
//         isAnonymous = userMap["isAnonymous"],
//         creationTime = userMap["creationTime"],
//         uid = userMap["uid"];

//   UserMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
//       : uid = doc.id,
//         email = doc.data()!["email"],
//         displayName = doc.data()!["displayName"],
//         emailVerified = doc.data()!["emailVerified"],
//         isAnonymous = doc.data()!["isAnonymous"],
//         creationTime = doc.data()!["creationTime"];
// }

// Future<DocumentReference<Object?>> addUser(UserMap userData) async {
//   var documentReference = await _db.collection("users").add(userData.toMap());
//   return documentReference;
// }

// //   updateEmployee(User userData) async {
// //   await _db.collection("users").doc("edw_thelei to doc id tou user").update(userData.toMap());
// // }

// Future<void> deleteUser(String documentId) async {
//   await _db.collection("users").doc(documentId).delete();
// }

// Future<List<UserMap>> retrieveUsers() async {
//   QuerySnapshot<Map<String, dynamic>> snapshot =
//       await _db.collection("users").get();
//   return snapshot.docs
//       .map((docSnapshot) => UserMap.fromDocumentSnapshot(docSnapshot))
//       .toList();
// }


import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';

class QuestionSet {
  String? id;
  String background;
  String ownerId;
  String questionSetName;
  String? questionSetType;
  int? numberOfQuestion;
  int timeLimit;
  String? username;
  String? user_avatar;

  QuestionSet(
      {this.id,
      required this.background,
      required this.ownerId,
      required this.questionSetName,
      required this.timeLimit,
      this.questionSetType,
      this.numberOfQuestion,
      this.user_avatar,
      this.username});

  factory QuestionSet.fromMap(Map<String, dynamic> map) {
    return QuestionSet(
        background: map['background'],
        user_avatar: map["user_avatar"],
        username: map["username"],
        ownerId: map['owner_id'],
        timeLimit: map['time_limit'],
        questionSetName: map['question_set_name'],
        questionSetType: map['question_set_type']);
  }

  Future<dynamic> addToFirestore() async {
    try {
      // Tham chiếu tới collection "question_set" trong Firestore
      CollectionReference questionSetCollection =
          FirebaseFirestore.instance.collection('question_set');
      CollectionReference roomCollection =
          FirebaseFirestore.instance.collection('rooms');
      DateTime now = DateTime.now(); // Lấy ngày giờ hiện tại

      String formattedDate = DateFormat('dd/MM/yyyy').format(now);

      // Thêm dữ liệu vào collection "question_set" và lưu lại documentID
      DocumentReference newQuestionSetDocRef = await questionSetCollection.add({
        'background': background,
        'owner_id': ownerId,
        'time_limit': timeLimit,
        'question_set_name': questionSetName,
        'question_set_type': questionSetType,
        'user_avatar': user_avatar,
        'username': username
        // Các trường dữ liệu khác nếu cần
      });

      // Lấy documentID của QuestionSet mới thêm vào
      String questionSetDocId = newQuestionSetDocRef.id;

      DocumentReference newRoomsDocRef = await roomCollection.add({
        "capacity": 1000,
        "date_created": formattedDate.toString(),
        "owner_id": FirebaseAuth.instance.currentUser?.uid.toString(),
        "participants": [],
        "question_set_id":
            questionSetDocId, // Sử dụng documentID của QuestionSet
        "room_name": "Chưa cần dùng đến, kkk"
      });
      String roomsDocId = newRoomsDocRef.id;

      return [roomsDocId, questionSetDocId];
    } catch (e) {
      print('Error adding data to Firestore: $e');
      return "";
    }
  }
}

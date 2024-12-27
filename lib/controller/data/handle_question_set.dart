import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/controller/handle_image/handle_image.dart';
import 'package:quiz_app/model/class/question_set.dart';
import 'package:quiz_app/view/theme/configs/handle_image.dart';

class HandleQuestionSet {
  Future<List<QuestionSet>> FetchDataQuestionSet(String currentUserID) async {
    final List<QuestionSet> list_qs = [];
    final questionSetDocs = await FirebaseFirestore.instance
        .collection('question_set')
        .where('owner_id', isEqualTo: currentUserID)
        .get();

    for (var element in questionSetDocs.docs) {
      int numberOfQuestions = await getQuestionCount(element.id);

      // String file_name = "${currentUserID}_${element.id}.jpg";
      // String background_image =
      //     await Handle_Images().get_image_question_set(file_name);

      list_qs.add(QuestionSet(
        id: element.id,
        background: element["background"],
        ownerId: element["owner_id"],
        questionSetName: element["question_set_name"],
        timeLimit: element["time_limit"],
        numberOfQuestion: numberOfQuestions,
      ));
    }

    return list_qs;
  }

  Future<List<Map<String, dynamic>>> getTopics() async {
    
    CollectionReference topics =
        FirebaseFirestore.instance.collection('topics');

    
    QuerySnapshot querySnapshot = await topics.get();

    
    List<Map<String, dynamic>> topicsList = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    return topicsList;
  }

  Future<Map<String, dynamic>?> getQuestionSet(String documentID) async {
    DocumentSnapshot questionSetSnapshot = await FirebaseFirestore.instance
        .collection('question_set')
        .doc(documentID)
        .get();

    if (questionSetSnapshot.exists) {
      return questionSetSnapshot.data() as Map<String, dynamic>;
    } else {
      return null; 
    }
  }

  Stream<List<QuestionSet>> fetchDataQuestionSetStream(String currentUserID) {
    final questionSetController = StreamController<List<QuestionSet>>();

    FirebaseFirestore.instance
        .collection('question_set')
        .where('owner_id', isEqualTo: currentUserID)
        .snapshots()
        .listen((querySnapshot) async {
      List<QuestionSet> list_qs = [];

      for (var element in querySnapshot.docs) {
        int numberOfQuestions = await getQuestionCount(element.id);

        list_qs.add(QuestionSet(
          id: element.id,
          background: element["background"],
          ownerId: element["owner_id"],
          questionSetName: element["question_set_name"],
          timeLimit: element["time_limit"],
          numberOfQuestion: numberOfQuestions,
        ));
      }

      questionSetController.add(list_qs);
    }, onError: (error) {
      // Xử lý lỗi nếu có
      questionSetController.addError(error);
    });

    return questionSetController.stream;
  }

  Future<int> getQuestionCount(String questionSetId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('question_set_id', isEqualTo: questionSetId)
        .get();
    return querySnapshot.docs.length;
  }

  Future<QuestionSet> fetchQuestionSetByRoomID(String question_set_id) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('question_set')
        .doc(question_set_id)
        .get();
    return QuestionSet.fromMap(snap.data() as Map<String, dynamic>);
  }
}

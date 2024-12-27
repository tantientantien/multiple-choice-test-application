import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ResultClass {
  String questionSetId;
  double score;

  int numberOfQuestions;
  int numberOfCorrectAnswers;
  List<String> selectedOptions;
  List<String> correctAnswer;
  List<String> questions;
  String timeSubmit;
  String owner_id;
  String? username;
  String joiner_id;

  ResultClass(
      {required this.questionSetId,
      required this.joiner_id,
      required this.score,
      required this.numberOfQuestions,
      required this.numberOfCorrectAnswers,
      required this.selectedOptions,
      required this.correctAnswer,
      required this.timeSubmit,
      required this.questions,
      required this.owner_id,
      this.username});

  Future<dynamic> addToFirestore() async {
    try {
      CollectionReference resultCollection =
          FirebaseFirestore.instance.collection('results');
      DocumentReference newResultDocRef = await resultCollection.add({
        'question_set_id': questionSetId,
        'score': score,
        'number_of_questions': numberOfQuestions,
        'number_of_correct_answers': numberOfCorrectAnswers,
        'selected_options': selectedOptions,
        'correctAnswer': correctAnswer,
        'questions': questions,
        'owner_id': owner_id,
        "time_submit": timeSubmit,
        "joiner_id": joiner_id,
        "joiner_username": username
      });
      String questionDocId = newResultDocRef.id;
      return questionDocId;
    } catch (e) {
      print('Error adding data to Firestore: $e');
      return null;
    }
  }
}

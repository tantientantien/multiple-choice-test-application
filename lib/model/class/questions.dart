import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final bool ismultiselect;
  final String questionType;
  String? mediaLink;
  String questionSetID;
  String ownerID;
  String? questionDocID;

  QuizQuestion(
      {required this.question,
      required this.options,
      required this.correctAnswer,
      required this.ismultiselect,
      required this.questionType,
      this.mediaLink,
      required this.questionSetID,
      required this.ownerID,
      this.questionDocID});

  Future<dynamic> addToFirestore() async {
    try {
      CollectionReference questionSetCollection =
          FirebaseFirestore.instance.collection('questions');
      DocumentReference newQuestionSetDocRef = await questionSetCollection.add({
        'answer': options,
        'correct_answer': correctAnswer,
        'is_multiselect': ismultiselect,
        'media_link': mediaLink,
        'owner_id': ownerID,
        'question': question,
        'question_set_id': questionSetID,
        'question_type': questionType,
      });
      String questionDocId = newQuestionSetDocRef.id;
      return questionDocId;
    } catch (e) {
      print('Error adding data to Firestore: $e');
      return null;
    }
  }

  Future<dynamic> updateQuestionInFirestore(String documentID) async {
    try {
      CollectionReference questionCollection =
          FirebaseFirestore.instance.collection('questions');
      await questionCollection.doc(documentID).update({
        'answer': options,
        'correct_answer': correctAnswer,
        'is_multiselect': ismultiselect,
        'media_link': mediaLink,
        'owner_id': ownerID,
        'question': question,
        'question_set_id': questionSetID,
        'question_type': questionType,
      });
      return 'Cập nhật thành công tài liệu có ID: $documentID';
    } catch (e) {
      print('Lỗi khi cập nhật tài liệu: $e');
      return null;
    }
  }
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizQuestion>> getQuestions(String questionSetId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('questions')
          .where('question_set_id', isEqualTo: questionSetId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return QuizQuestion(
            ownerID: data["owner_id"],
            questionSetID: data["question_set_id"],
            question: data['question'],
            options: List<String>.from(data['answer']),
            correctAnswer: data['correct_answer'],
            ismultiselect: data['is_multiselect'],
            questionType: data['question_type'],
            mediaLink: data['media_link'],
            questionDocID: doc.id);
      }).toList();
    } catch (e) {
      print('Error getting questions: $e');
      return [];
    }
  }

  Future<String> getUsernameFromQuestionSet(String documentID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('question_set')
              .doc(documentID)
              .get();

      if (docSnapshot.exists) {
        return docSnapshot.get('username');
      } else {
        return " ";
      }
    } catch (e) {
      print('Error getting username from question_set: $e');
      return " ";
    }
  }

  Future<String> getQuestionSetNameFromQuestionSet(String documentID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('question_set')
              .doc(documentID)
              .get();

      if (docSnapshot.exists) {
        return docSnapshot.get('question_set_name');
      } else {
        return " ";
      }
    } catch (e) {
      print('Error getting username from question_set: $e');
      return " ";
    }
  }

  Future<Map<String, dynamic>?> getDocumentDataFromQuestionSet(
      String documentID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('question_set')
              .doc(documentID)
              .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting document from question_set: $e');
      return null;
    }
  }

  Stream<List<QuizQuestion>> streamQuestions(String questionSetId) {
    StreamController<List<QuizQuestion>> controller =
        StreamController<List<QuizQuestion>>();

    var collection = _firestore.collection('questions');

    var subscription = collection
        .where('question_set_id', isEqualTo: questionSetId)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<QuizQuestion> questions = snapshot.docs.map((doc) {
        final data = doc.data();
        return QuizQuestion(
          ownerID: data["owner_id"],
          questionSetID: data["question_set_id"],
          question: data['question'],
          options: List<String>.from(data['answer']),
          correctAnswer: data['correct_answer'],
          ismultiselect: data['is_multiselect'],
          questionType: data['question_type'],
          mediaLink: data['media_link'],
          questionDocID: doc.id,
        );
      }).toList();

      controller.add(questions);
    }, onError: (error) {
      controller.addError(error);
    });

    return controller.stream;
  }

  Future<int> countDocumentsInResultsCollection(String questionSetId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('results')
              .where('question_set_id', isEqualTo: questionSetId)
              .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error counting documents in "results" collection: $e');
      return -1;
    }
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getResults(
      String questionSetId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('results')
              .where('question_set_id', isEqualTo: questionSetId)
              .get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error getting results: $e');
      return [];
    }
  }

  Future<void> deleteQuestionSet(String documentID) async {
    try {
      await FirebaseFirestore.instance
          .collection('question_set')
          .doc(documentID)
          .delete();
      print('Document deleted successfully!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> deleteRoom(String documentID) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(documentID)
          .delete();
      print('Document deleted successfully!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<String?> getRoomDocumentId(String questionSetId) async {
    try {
      CollectionReference roomsCollection =
          FirebaseFirestore.instance.collection('rooms');

      QuerySnapshot querySnapshot = await roomsCollection
          .where('question_set_id', isEqualTo: questionSetId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting room document ID: $e');
      return null;
    }
  }

  Future<dynamic> deleteFromFirestore(String documentID) async {
    try {
      CollectionReference questionCollection =
          FirebaseFirestore.instance.collection('questions');
      await questionCollection.doc(documentID).delete();
      return 'Xóa thành công tài liệu có ID: $documentID';
    } catch (e) {
      print('Lỗi khi xóa tài liệu: $e');
      return null;
    }
  }

  Future<List<dynamic>> getQuestionsBySetId(String questionSetId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('questions')
              .where('question_set_id', isEqualTo: questionSetId)
              .get();

      List<String> questions =
          querySnapshot.docs.map((doc) => doc['question'] as String).toList();

      return questions;
    } catch (e) {
      print('Error getting questions: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>>
      getDocumentsByJoinerIdStream(String joinerId) {
    try {
      return FirebaseFirestore.instance
          .collection('results')
          .where('joiner_id', isEqualTo: joinerId)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.toList());
    } catch (e) {
      print('Error getting documents by joiner_id: $e');
      return Stream.value([]); // Trả về một Stream rỗng trong trường hợp lỗi
    }
  }
}

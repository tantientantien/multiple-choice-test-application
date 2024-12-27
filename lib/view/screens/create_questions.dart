import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconoir_flutter/font_size.dart';
import 'package:iconoir_flutter/iconoir.dart';
import 'package:quiz_app/controller/handle_image/handle_image.dart';
import 'package:quiz_app/model/class/question_set.dart';
import 'package:quiz_app/model/class/questions.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:quiz_app/view/theme/configs/font_size.dart';
import 'package:quiz_app/view/theme/configs/handle_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/view/widgets/stateful_widgets/video.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  String? _selectedImagePath;
  String? _fireStoragePath;
  final TextEditingController _quizName = TextEditingController();
  final TextEditingController _timeLimit = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _quizName.dispose();
    _timeLimit.dispose();
  }

  String getQuestionType(Choice x) {
    if (x == Choice.text) {
      return "text";
    } else if (x == Choice.video) {
      return "video";
    } else {
      return "image";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors().main_black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Create quiz',
            style: TextStyle(
              fontFamily: "poppins_bold",
              fontSize: 25,
              color: AppColors().main_green,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: ListView(
            children: [
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, elevation: 0.0),
                  onPressed: () async {
                    String? image = await HandleImage().pickMedia(false);
                    setState(() {
                      if (image == null) {
                        _selectedImagePath = null;
                      } else {
                        _selectedImagePath = image;
                      }
                    });
                    String? urlFireStorage = await HandleImage()
                        .uploadImageToFirebase(image!, "question_set_image");
                    setState(() {
                      _fireStoragePath = urlFireStorage;
                    });
                  },
                  child: (_selectedImagePath != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            height: 240,
                            child: Image.file(
                              File(_selectedImagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            height: 240,
                            child: Image.asset(
                              "assets/images/background/default.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Quiz name',
                        style: TextStyle(
                            color: AppColors().main_black,
                            fontSize: 15,
                            fontFamily: "poppins_bold"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _quizName,
                        decoration: InputDecoration(
                          hintText: "Enter quiz name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Time limit (minute)',
                        style: TextStyle(
                            color: AppColors().main_black,
                            fontSize: 15,
                            fontFamily: "poppins_bold"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _timeLimit,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter time limit",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        backgroundColor: AppColors().main_green,
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, right: 45, left: 45)),
                    onPressed: () async {
                      QuestionSet questionSet = QuestionSet(
                          background: _fireStoragePath!,
                          ownerId: FirebaseAuth.instance.currentUser!.uid,
                          questionSetName: _quizName.text,
                          questionSetType: "public",
                          timeLimit: int.parse(_timeLimit.text),
                          user_avatar:
                              FirebaseAuth.instance.currentUser?.photoURL,
                          username: FirebaseAuth.instance.currentUser?.email);
                      dynamic resultProcess =
                          await questionSet.addToFirestore();
                      if (resultProcess != "") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CreateQuestionsPage(
                                    quizName: _quizName.text,
                                    question_set_id: resultProcess[1],
                                    roomCode: resultProcess[0],
                                  )),
                        );
                      } else {
                        AlertDialog(
                          title: const Text("Notification"),
                          content: const Text("Can not add the quiz set."),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Exit"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //       builder: (context) => CreateQuestionsPage(
                      //             quizName: _quizName.text,
                      //             question_set_id: "CC",
                      //             roomCode: "DKMM",
                      //           )),
                      // );
                    },
                    child: Text(
                      "Save and add questions",
                      style: TextStyle(
                          fontFamily: "poppins_bold",
                          fontSize: AppFontSize().h3),
                    )),
              )
            ],
          ),
        ));
  }
}

enum Choice { text, image, video }

class CreateQuestionsPage extends StatefulWidget {
  final String quizName;
  final String question_set_id;
  final String roomCode;

  String? selectedImagePath;
  String? questionType;
  String? question;
  bool? is_multi_choice;
  String? questionID;
  List<String>? selected_options;
  String? selected_option_single_choice;
  bool? isUpdate;

  CreateQuestionsPage(
      {required this.quizName,
      required this.question_set_id,
      required this.roomCode,
      this.selectedImagePath,
      this.questionType,
      this.is_multi_choice,
      this.selected_options,
      this.selected_option_single_choice,
      this.question,
      this.isUpdate,
      this.questionID});

  @override
  State<CreateQuestionsPage> createState() => _CreateQuestionsPageState();
}

class _CreateQuestionsPageState extends State<CreateQuestionsPage> {
  Choice? _selectedChoice;

  String? _selectedMulltichoice;

  List<String> selectedOptions = [];

  int selectedOptionsLength = 0;

  String? selectedOptionSingleChoice;

  List<dynamic> correctAnswers = [];

  int currentQuestionIndex = 1;

  final TextEditingController _question = TextEditingController();

  final TextEditingController _answer = TextEditingController();

  late List<bool> checkedOptions = List.filled(selectedOptions.length, false);

  List<dynamic> selectedOptionMultiChoice = [];

  String? _selectedImagePath;

  String _fireStoragePath = "";

  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      _question.text = widget.question!;
    }
    if (widget.is_multi_choice == true) {
      _selectedMulltichoice = "multichoice";
    }
    if (widget.questionType == "video") {
      _selectedChoice = Choice.video;
    } else if (widget.questionType == "image") {
      _selectedChoice = Choice.image;
    } else {
      _selectedChoice = Choice.text;
    }

    if (widget.selectedImagePath != null) {
      _fireStoragePath = widget.selectedImagePath!;
    }

    if (widget.selected_options != null) {
      selectedOptions = widget.selected_options!;
    }

    if (widget.selected_option_single_choice != null) {
      selectedOptionSingleChoice = widget.selected_option_single_choice;
    }
  }

  String GetQuestionType(Choice choice) {
    if (choice == Choice.text) {
      return "text";
    } else if (choice == Choice.image) {
      return "image";
    } else {
      return "video";
    }
  }

  @override
  void dispose() {
    _answer.dispose();
    _question.dispose();
    super.dispose();
  }

  Widget WidgetAddQuestions(Choice? selectedChoice) {
    if (selectedChoice == Choice.text) {
      return Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text('Multichoice',
                    style: TextStyle(
                        color: AppColors().main_black,
                        fontSize: 18,
                        fontFamily: "poppins_bold")),
                Radio<String>(
                  toggleable: true,
                  activeColor: AppColors().main_purple,
                  value: 'multichoice',
                  groupValue: _selectedMulltichoice,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMulltichoice = value;
                    });
                    print(_selectedMulltichoice);
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Question?',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _question,
                      decoration: InputDecoration(
                        hintText: "Enter question",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Answer',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _answer,
                      decoration: InputDecoration(
                        hintText: "Enter answer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              primary: AppColors().main_purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontFamily: 'poppins_bold',
                                  fontSize: AppFontSize().h4),
                            ),
                            onPressed: () async {
                              setState(() {
                                selectedOptions.add(_answer.text);
                                checkedOptions =
                                    List.filled(selectedOptions.length, false);
                                _answer.text = "";
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 10),
              child: (selectedOptions.isNotEmpty)
                  ? (_selectedMulltichoice == null)
                      ? Column(
                          children: selectedOptions.map<Widget>((option) {
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors().main_grey,
                                  width: 2,
                                ),
                              ),
                              child: RadioListTile<String>(
                                title: Text(
                                  option.toString(),
                                  style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: 18,
                                  ),
                                ),
                                activeColor: Colors.purple,
                                value: option.toString(),
                                groupValue: selectedOptionSingleChoice,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOptionSingleChoice = newValue;
                                  });
                                  print(selectedOptionSingleChoice);
                                },
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: selectedOptions
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            final int index = entry.key;
                            final String option = entry.value;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors().main_grey,
                                  width: 2,
                                ),
                              ),
                              child: CheckboxListTile(
                                title: Text(
                                  option.toString(),
                                  style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: 18,
                                  ),
                                ),
                                activeColor: AppColors().main_purple,
                                value: checkedOptions[index],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkedOptions[index] = newValue ?? false;
                                  });
                                  if (selectedOptionMultiChoice
                                      .contains(selectedOptions[index])) {
                                    selectedOptionMultiChoice
                                        .remove(selectedOptions[index]);
                                  } else {
                                    selectedOptionMultiChoice
                                        .add(selectedOptions[index]);
                                  }
                                  print(selectedOptionMultiChoice);
                                },
                              ),
                            );
                          }).toList(),
                        )
                  : const Text("No options available"),
            ),
            selectedOptions.isNotEmpty
                ? Container(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedMulltichoice == null) {
                              selectedOptions
                                  .remove(selectedOptionSingleChoice);
                            } else if (_selectedMulltichoice == "multichoice") {
                              for (int i = selectedOptionMultiChoice.length - 1;
                                  i >= 0;
                                  i--) {
                                selectedOptions
                                    .remove(selectedOptionMultiChoice[i]);
                                selectedOptionMultiChoice.removeAt(i);
                              }
                            }
                          });
                          print(selectedOptionMultiChoice);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Remove",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "poppins_bold",
                                color: AppColors().main_black),
                          ),
                        )),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      backgroundColor: AppColors().main_purple,
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, right: 45, left: 45)),
                  onPressed: () async {
                    if (widget.isUpdate != true) {
                      QuizQuestion _quizQuestion = QuizQuestion(
                          question: _question.text,
                          options: selectedOptions,
                          correctAnswer:
                              (_selectedMulltichoice == "multichoice")
                                  ? selectedOptionMultiChoice.toString()
                                  : selectedOptionSingleChoice!,
                          ismultiselect:
                              (_selectedMulltichoice == "multichoice")
                                  ? true
                                  : false,
                          questionType: "text",
                          questionSetID: widget.question_set_id,
                          ownerID: FirebaseAuth.instance.currentUser!.uid);
                      dynamic resultProcess =
                          await _quizQuestion.addToFirestore();

                      if (resultProcess != null) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content: Text(
                                  "Added question to the ${widget.quizName} question set.\nCode: ${widget.roomCode}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content:
                                  const Text("Can not add to the quiz set"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else if (widget.isUpdate == true) {
                      QuizQuestion _quizQuestion = QuizQuestion(
                          question: _question.text,
                          options: selectedOptions,
                          correctAnswer:
                              (_selectedMulltichoice == "multichoice")
                                  ? selectedOptionMultiChoice.toString()
                                  : selectedOptionSingleChoice!,
                          ismultiselect:
                              (_selectedMulltichoice == "multichoice")
                                  ? true
                                  : false,
                          questionType: GetQuestionType(_selectedChoice!),
                          questionSetID: widget.question_set_id,
                          ownerID: FirebaseAuth.instance.currentUser!.uid);
                      dynamic resultProcess =
                          await _quizQuestion.updateQuestionInFirestore(
                        widget.questionID!,
                      );

                      if (resultProcess != null) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content: Text(
                                  "Updated question to the ${widget.quizName} question set.\nCode: ${widget.roomCode}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content:
                                  const Text("Can not add to the quiz set"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                    _question.text = "";
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontFamily: "poppins_bold", fontSize: AppFontSize().h3),
                  )),
            )
          ],
        ),
      );
    } else if (selectedChoice == Choice.image) {
      return Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text('Multichoice',
                    style: TextStyle(
                        color: AppColors().main_black,
                        fontSize: 18,
                        fontFamily: "poppins_bold")),
                Radio<String>(
                  toggleable: true,
                  activeColor: AppColors().main_purple,
                  value: 'multichoice',
                  groupValue: _selectedMulltichoice,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMulltichoice = value;
                    });
                    print(_selectedMulltichoice);
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Question?',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _question,
                      decoration: InputDecoration(
                        hintText: "Enter question",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Image',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        onPressed: () async {
                          String? image = await HandleImage().pickMedia(false);
                          setState(() {
                            if (image == "no image") {
                              _selectedImagePath = null;
                            } else {
                              _selectedImagePath = image;
                            }
                          });
                          String? urlFireStorage = await HandleImage()
                              .uploadImageToFirebase(image!, "question_images");
                          setState(() {
                            _fireStoragePath = urlFireStorage!;
                          });
                        },
                        child: (_selectedImagePath != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: double.infinity,
                                  height: 240,
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: double.infinity,
                                  height: 240,
                                  child: Image.asset(
                                    "assets/images/background/default.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Answer',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _answer,
                      decoration: InputDecoration(
                        hintText: "Enter answer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              primary: AppColors().main_purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontFamily: 'poppins_bold',
                                  fontSize: AppFontSize().h4),
                            ),
                            onPressed: () async {
                              setState(() {
                                selectedOptions.add(_answer.text);
                                checkedOptions =
                                    List.filled(selectedOptions.length, false);
                                _answer.text = "";
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 10),
              child: (selectedOptions.isNotEmpty)
                  ? (_selectedMulltichoice == null)
                      ? Column(
                          children: selectedOptions.map<Widget>((option) {
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors().main_grey,
                                  width: 2,
                                ),
                              ),
                              child: RadioListTile<String>(
                                title: Text(
                                  option.toString(),
                                  style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: 18,
                                  ),
                                ),
                                activeColor: Colors.purple,
                                value: option.toString(),
                                groupValue: selectedOptionSingleChoice,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOptionSingleChoice = newValue;
                                  });
                                  print(selectedOptionSingleChoice);
                                },
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: selectedOptions
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            final int index = entry.key;
                            final String option = entry.value;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors().main_grey,
                                  width: 2,
                                ),
                              ),
                              child: CheckboxListTile(
                                title: Text(
                                  option.toString(),
                                  style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: 18,
                                  ),
                                ),
                                activeColor: AppColors().main_purple,
                                value: checkedOptions[index],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkedOptions[index] = newValue ?? false;
                                  });
                                  if (selectedOptionMultiChoice
                                      .contains(selectedOptions[index])) {
                                    selectedOptionMultiChoice
                                        .remove(selectedOptions[index]);
                                  } else {
                                    selectedOptionMultiChoice
                                        .add(selectedOptions[index]);
                                  }
                                  print(selectedOptionMultiChoice);
                                },
                              ),
                            );
                          }).toList(),
                        )
                  : const Text("No options available"),
            ),
            selectedOptions.isNotEmpty
                ? Container(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedMulltichoice == null) {
                              selectedOptions
                                  .remove(selectedOptionSingleChoice);
                            } else if (_selectedMulltichoice == "multichoice") {
                              for (int i = selectedOptionMultiChoice.length - 1;
                                  i >= 0;
                                  i--) {
                                selectedOptions
                                    .remove(selectedOptionMultiChoice[i]);
                                selectedOptionMultiChoice.removeAt(i);
                              }
                            }
                          });
                          print(selectedOptionMultiChoice);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Remove",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "poppins_bold",
                                color: AppColors().main_black),
                          ),
                        )),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      backgroundColor: AppColors().main_purple,
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, right: 45, left: 45)),
                  onPressed: () async {
                    if (widget.isUpdate != true) {
                      QuizQuestion _quizQuestion = QuizQuestion(
                          question: _question.text,
                          options: selectedOptions,
                          correctAnswer:
                              (_selectedMulltichoice == "multichoice")
                                  ? selectedOptionMultiChoice.toString()
                                  : selectedOptionSingleChoice!,
                          ismultiselect:
                              (_selectedMulltichoice == "multichoice")
                                  ? true
                                  : false,
                          mediaLink: _fireStoragePath,
                          questionType: "image",
                          questionSetID: widget.question_set_id,
                          ownerID: FirebaseAuth.instance.currentUser!.uid);
                      dynamic resultProcess =
                          await _quizQuestion.addToFirestore();

                      if (resultProcess != null) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content: Text(
                                  "Added question to the ${widget.quizName} question set.\nCode: ${widget.roomCode}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content:
                                  const Text("Can not add to the quiz set"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else if (widget.isUpdate == true) {
                      QuizQuestion _quizQuestion = QuizQuestion(
                          question: _question.text,
                          options: selectedOptions,
                          correctAnswer:
                              (_selectedMulltichoice == "multichoice")
                                  ? selectedOptionMultiChoice.toString()
                                  : selectedOptionSingleChoice!,
                          ismultiselect:
                              (_selectedMulltichoice == "multichoice")
                                  ? true
                                  : false,
                          mediaLink: _fireStoragePath,
                          questionType: GetQuestionType(_selectedChoice!),
                          questionSetID: widget.question_set_id,
                          ownerID: FirebaseAuth.instance.currentUser!.uid);
                      dynamic resultProcess =
                          await _quizQuestion.updateQuestionInFirestore(
                        widget.questionID!,
                      );

                      if (resultProcess != null) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content: Text(
                                  "Updated question to the ${widget.quizName} question set.\nCode: ${widget.roomCode}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content:
                                  const Text("Can not add to the quiz set"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                    _question.text = "";
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontFamily: "poppins_bold", fontSize: AppFontSize().h3),
                  )),
            )
          ],
        ),
      );
    } else if (selectedChoice == Choice.video) {
      return Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text('Multichoice',
                    style: TextStyle(
                        color: AppColors().main_black,
                        fontSize: 18,
                        fontFamily: "poppins_bold")),
                Radio<String>(
                  toggleable: true,
                  activeColor: AppColors().main_purple,
                  value: 'multichoice',
                  groupValue: _selectedMulltichoice,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMulltichoice = value;
                    });
                    print(_selectedMulltichoice);
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Question?',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _question,
                      decoration: InputDecoration(
                        hintText: "Enter question",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Video',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        onPressed: () async {
                          String? image = await HandleImage().pickMedia(true);
                          setState(() {
                            if (image == "no image") {
                              _selectedImagePath = null;
                            } else {
                              _selectedImagePath = image;
                            }
                          });
                          String? urlFireStorage = await HandleImage()
                              .uploadImageToFirebase(image!, "question_video");
                          setState(() {
                            _fireStoragePath = urlFireStorage!;
                          });
                        },
                        child: (_selectedImagePath != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                    width: double.infinity,
                                    height: 240,
                                    child: VideoPlayerPage(
                                        assetVideoPath:
                                            Uri.parse(_fireStoragePath))),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: double.infinity,
                                  height: 240,
                                  child: Image.asset(
                                    "assets/images/background/default2.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Answer',
                      style: TextStyle(
                          color: AppColors().main_black,
                          fontSize: 18,
                          fontFamily: "poppins_bold"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _answer,
                      decoration: InputDecoration(
                        hintText: "Enter answer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              primary: AppColors().main_purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontFamily: 'poppins_bold',
                                  fontSize: AppFontSize().h4),
                            ),
                            onPressed: () async {
                              setState(() {
                                selectedOptions.add(_answer.text);
                                checkedOptions =
                                    List.filled(selectedOptions.length, false);
                                _answer.text = "";
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 10),
              child: (selectedOptions.isNotEmpty)
                  ? (_selectedMulltichoice == null)
                      ? Column(
                          children: selectedOptions.map<Widget>((option) {
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors().main_grey,
                                  width: 2,
                                ),
                              ),
                              child: RadioListTile<String>(
                                title: Text(
                                  option.toString(),
                                  style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: 18,
                                  ),
                                ),
                                activeColor: Colors.purple,
                                value: option.toString(),
                                groupValue: selectedOptionSingleChoice,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOptionSingleChoice = newValue;
                                  });
                                  print(selectedOptionSingleChoice);
                                },
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: selectedOptions
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            final int index = entry.key;
                            final String option = entry.value;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors().main_grey,
                                  width: 2,
                                ),
                              ),
                              child: CheckboxListTile(
                                title: Text(
                                  option.toString(),
                                  style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: 18,
                                  ),
                                ),
                                activeColor: AppColors().main_purple,
                                value: checkedOptions[index],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkedOptions[index] = newValue ?? false;
                                  });
                                  if (selectedOptionMultiChoice
                                      .contains(selectedOptions[index])) {
                                    selectedOptionMultiChoice
                                        .remove(selectedOptions[index]);
                                  } else {
                                    selectedOptionMultiChoice
                                        .add(selectedOptions[index]);
                                  }
                                  print(selectedOptionMultiChoice);
                                },
                              ),
                            );
                          }).toList(),
                        )
                  : const Text("No options available"),
            ),
            selectedOptions.isNotEmpty
                ? Container(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedMulltichoice == null) {
                              selectedOptions
                                  .remove(selectedOptionSingleChoice);
                            } else if (_selectedMulltichoice == "multichoice") {
                              for (int i = selectedOptionMultiChoice.length - 1;
                                  i >= 0;
                                  i--) {
                                selectedOptions
                                    .remove(selectedOptionMultiChoice[i]);
                                selectedOptionMultiChoice.removeAt(i);
                              }
                            }
                          });
                          print(selectedOptionMultiChoice);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Remove",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "poppins_bold",
                                color: AppColors().main_black),
                          ),
                        )),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      backgroundColor: AppColors().main_purple,
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, right: 45, left: 45)),
                  onPressed: () async {
                    if (widget.isUpdate != true) {
                      QuizQuestion _quizQuestion = QuizQuestion(
                          question: _question.text,
                          options: selectedOptions,
                          correctAnswer:
                              (_selectedMulltichoice == "multichoice")
                                  ? selectedOptionMultiChoice.toString()
                                  : selectedOptionSingleChoice!,
                          ismultiselect:
                              (_selectedMulltichoice == "multichoice")
                                  ? true
                                  : false,
                          mediaLink: _fireStoragePath,
                          questionType: "video",
                          questionSetID: widget.question_set_id,
                          ownerID: FirebaseAuth.instance.currentUser!.uid);
                      dynamic resultProcess =
                          await _quizQuestion.addToFirestore();

                      if (resultProcess != null) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content: Text(
                                  "Added question to the ${widget.quizName} question set.\nCode: ${widget.roomCode}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content:
                                  const Text("Can not add to the quiz set"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else if (widget.isUpdate == true) {
                      QuizQuestion _quizQuestion = QuizQuestion(
                          question: _question.text,
                          options: selectedOptions,
                          correctAnswer:
                              (_selectedMulltichoice == "multichoice")
                                  ? selectedOptionMultiChoice.toString()
                                  : selectedOptionSingleChoice!,
                          ismultiselect:
                              (_selectedMulltichoice == "multichoice")
                                  ? true
                                  : false,
                          mediaLink: _fireStoragePath,
                          questionType: GetQuestionType(_selectedChoice!),
                          questionSetID: widget.question_set_id,
                          ownerID: FirebaseAuth.instance.currentUser!.uid);
                      dynamic resultProcess =
                          await _quizQuestion.updateQuestionInFirestore(
                        widget.questionID!,
                      );

                      if (resultProcess != null) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content: Text(
                                  "Updated question to the ${widget.quizName} question set.\nCode: ${widget.roomCode}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Notification",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black)),
                              content:
                                  const Text("Can not add to the quiz set"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                        color: AppColors().main_black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                    _question.text = "";
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontFamily: "poppins_bold", fontSize: AppFontSize().h3),
                  )),
            )
          ],
        ),
      );
    } else if (selectedChoice == null) {
      return Text("You have to select a type question");
    } else {
      return Text("error");
    }
  }

  void _showExitConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Your answers are not saved"),
          content: const Text(
              "Are you sure you want to exit without saving your answers?"),
          actions: <Widget>[
            TextButton(
              child: Text("Stay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Exit"),
              onPressed: () async {
                await FirebaseService()
                    .deleteQuestionSet(widget.question_set_id);
                await FirebaseService().deleteRoom(widget.roomCode);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors().main_black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          (widget.isUpdate == true)
              ? Container(
                  margin: EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Notification",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: "poppins_bold",
                                    color: AppColors().main_black)),
                            content: const Text(
                                "Are you sure you want to delete this question?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "poppins_bold",
                                      color: AppColors().main_black),
                                ),
                                onPressed: () async {
                                  await FirebaseService()
                                      .deleteFromFirestore(widget.questionID!);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ))
              : Container()
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: DropdownButton<Choice>(
                iconSize: 40,
                iconEnabledColor: AppColors().main_black,
                hint: Text(
                  'Select question type',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "poppins_bold",
                    color: AppColors().main_black,
                  ),
                ),
                value: _selectedChoice,
                isExpanded: true,
                onChanged: (Choice? value) {
                  if (value != null) {
                    setState(() {
                      _selectedChoice = value;
                    });
                  }
                },
                items: <DropdownMenuItem<Choice>>[
                  DropdownMenuItem<Choice>(
                    value: Choice.text,
                    child: Text(
                      'Text',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "poppins_bold",
                        color: AppColors().main_black,
                      ),
                    ),
                  ),
                  DropdownMenuItem<Choice>(
                    value: Choice.image,
                    child: Text(
                      'Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "poppins_bold",
                        color: AppColors().main_black,
                      ),
                    ),
                  ),
                  DropdownMenuItem<Choice>(
                    value: Choice.video,
                    child: Text(
                      'Video',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "poppins_bold",
                        color: AppColors().main_black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WidgetAddQuestions(_selectedChoice)
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/data/handle_question_set.dart';
import 'package:quiz_app/controller/data/handle_rooms.dart';
import 'package:quiz_app/controller/provider/timer_provider.dart';
import 'package:quiz_app/model/class/question_set.dart';
import 'package:quiz_app/model/class/questions.dart';
import 'package:quiz_app/model/class/result.dart';
import 'package:quiz_app/model/class/rooms.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:quiz_app/view/theme/configs/font_size.dart';
import 'package:quiz_app/view/theme/configs/handle_image.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as icon;
import 'package:quiz_app/view/widgets/stateful_widgets/video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iconsax/iconsax.dart' as iconsax;
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import "../../controller/route/route.dart" as route;
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AnswerQuestionPage extends StatelessWidget {
  String room_id;
  String? questionID;

  AnswerQuestionPage({required this.room_id});

  Future<QuestionSet> fetchDataQuestionSet() async {
    Rooms room = await HandleRooms().fetchAllRoomInfo(room_id.trim());
    questionID = room.questionSetId.trim();
    QuestionSet question_set = await HandleQuestionSet()
        .fetchQuestionSetByRoomID(room.questionSetId.trim());
    return question_set;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors().main_black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            'AQ',
            style: TextStyle(
                fontFamily: "poppins_bold", color: AppColors().main_black),
          ),
        ),
        body: FutureBuilder(
            future: fetchDataQuestionSet(),
            builder: (context, snap) {
              QuestionSet? question_set = snap.data;
              return Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(200, 300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: AppColors().purple_white,
                            elevation: 5.0),
                        onPressed: () async {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: HandleImage().AutoRenderImageDefault(
                                      question_set!.background)),
                            ),
                            Container(
                                margin: const EdgeInsets.all(16),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          question_set.questionSetName,
                                          style: TextStyle(
                                            fontFamily: 'poppins_bold',
                                            fontSize: AppFontSize().h3,
                                            color: AppColors().main_purple,
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 3, 15, 3),
                                            decoration: BoxDecoration(
                                                color: AppColors().main_purple,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: FutureBuilder<int>(
                                              future: HandleQuestionSet()
                                                  .getQuestionCount(
                                                      questionID!),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'poppins_bold',
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                    'Error: ${snapshot.error}',
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'poppins_bold',
                                                    ),
                                                  );
                                                } else {
                                                  return Text(
                                                    '${snapshot.data}Q',
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'poppins_bold',
                                                    ),
                                                  );
                                                }
                                              },
                                            )),
                                      ],
                                    ),
                                    Text(
                                      "Time limit: ${question_set.timeLimit}m",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Text(
                                      "Author: ${question_set.username!}",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors().main_purple,
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 45, left: 45)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Test(
                                    question_set_id: questionID!,
                                    timeLimit: question_set.timeLimit),
                              ),
                            );
                          },
                          child: Text(
                            "Start",
                            style: TextStyle(
                                fontFamily: "poppins_bold",
                                fontSize: AppFontSize().h3),
                          )),
                    )
                  ],
                ),
              );
            }));
  }
}

class Test extends StatefulWidget {
  final String question_set_id;
  final int timeLimit;

  Test({required this.question_set_id, required this.timeLimit});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  FirebaseService _firebaseService = FirebaseService();

  List<QuizQuestion> _questions = [];

  int currentQuestionIndex = 0;

  List<dynamic> selectedOptions = [];

  List<dynamic> correctAnswers = [];

  int minute = 15;
  int second = 00;

  void goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < _questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void getCorrectAnswer() {
    setState(() {
      correctAnswers[currentQuestionIndex] =
          _questions[currentQuestionIndex].correctAnswer;
    });
  }

  void goToPreviousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  void _loadQuestions() async {
    final questionSetId = widget.question_set_id;
    final questions = await _firebaseService.getQuestions(questionSetId);
    setState(() {
      _questions = questions;
      selectedOptions = List<dynamic>.filled(_questions.length, null);
      correctAnswers = List<dynamic>.filled(_questions.length, null);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _showExitConfirmationDialog(BuildContext context) {
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
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget QuestionType(String type) {
    switch (type) {
      case "text":
        return Container(
            width: double.infinity,
            height: 240,
            margin: const EdgeInsets.only(top: 16),
            child: Center(
              child: Text(
                _questions[currentQuestionIndex].question,
                style: TextStyle(color: AppColors().main_white, fontSize: 18),
              ),
            ));
      case "image":
        return CarouselSlider(
          options: CarouselOptions(height: 240, enableInfiniteScroll: false),
          items: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 16),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  _questions[currentQuestionIndex].question,
                  style: TextStyle(color: AppColors().main_white, fontSize: 18),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  _questions[currentQuestionIndex].mediaLink!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        );
      case "video":
        return CarouselSlider(
          options: CarouselOptions(height: 240.0, enableInfiniteScroll: false),
          items: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  _questions[currentQuestionIndex].question,
                  style: TextStyle(color: AppColors().main_white, fontSize: 18),
                ),
              ),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: VideoPlayerPage(
                    assetVideoPath:
                        Uri.parse(_questions[currentQuestionIndex].mediaLink!)))
          ],
        );
      default:
        return Container(
          child: Text(
            'Unsupported question type: $type',
            style: TextStyle(color: AppColors().main_white, fontSize: 18),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().black_1,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: AppColors().black_1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      _showExitConfirmationDialog(context);
                    },
                    icon: icon.NavArrowLeft(
                      width: 30,
                      color: AppColors().main_white,
                    )),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 30),
                    children: <TextSpan>[
                      TextSpan(
                          text: "${currentQuestionIndex + 1}/",
                          style: TextStyle(
                              fontFamily: "poppins_bold",
                              color: AppColors().main_purple)),
                      TextSpan(text: '${_questions.length}'),
                    ],
                  ),
                ),
                CountdownTimer(
                    timeLimit: widget.timeLimit,
                    event: () {
                      getCorrectAnswer();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Result(
                            selectedOptions: selectedOptions,
                            correctAnswers: correctAnswers,
                            questionSetID: widget.question_set_id,
                          ),
                        ),
                      );
                    })
              ],
            )),
        body: (_questions.length != 0)
            ? Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: QuestionType(
                            _questions[currentQuestionIndex].questionType)),
                    Expanded(
                      flex: 2,
                      child: ListView(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _questions[currentQuestionIndex]
                                    .options
                                    .map((option) {
                                  bool isSelected =
                                      selectedOptions.contains(option);
                                  if (selectedOptions[currentQuestionIndex]
                                      is List) {
                                    isSelected =
                                        selectedOptions[currentQuestionIndex]
                                            .contains(option);
                                  }
                                  return Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: AppColors().main_grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: _questions[currentQuestionIndex]
                                              .ismultiselect
                                          ? CheckboxListTile(
                                              title: Text(
                                                option,
                                                style: TextStyle(
                                                  color: AppColors().main_white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              activeColor:
                                                  AppColors().main_purple,
                                              value: isSelected,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  if (newValue != null) {
                                                    if (_questions[
                                                            currentQuestionIndex]
                                                        .ismultiselect) {
                                                      if (newValue) {
                                                        if (selectedOptions[
                                                                currentQuestionIndex] ==
                                                            null) {
                                                          selectedOptions[
                                                              currentQuestionIndex] = [
                                                            option
                                                          ];
                                                        } else {
                                                          selectedOptions[
                                                                  currentQuestionIndex]
                                                              .add(option);
                                                        }
                                                      } else {
                                                        if (selectedOptions[
                                                                currentQuestionIndex] !=
                                                            null) {
                                                          selectedOptions[
                                                                  currentQuestionIndex]
                                                              .remove(option);
                                                        }
                                                      }
                                                    } else {
                                                      selectedOptions[
                                                              currentQuestionIndex] =
                                                          option;
                                                    }
                                                  }
                                                });
                                                printSelectedOption();
                                              },
                                            )
                                          : RadioListTile<String>(
                                              title: Text(
                                                option,
                                                style: TextStyle(
                                                  color: AppColors().main_white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              activeColor: Colors.purple,
                                              value: option,
                                              groupValue: selectedOptions[
                                                  currentQuestionIndex],
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedOptions[
                                                          currentQuestionIndex] =
                                                      newValue;
                                                });
                                                printSelectedOption();
                                              },
                                            ));
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (currentQuestionIndex + 1 == _questions.length)
                        ? Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      goToPreviousQuestion();
                                    },
                                    child: Text(
                                      "Previous",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors().main_white,
                                          fontFamily: "poppins_bold"),
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 3, bottom: 3, left: 25, right: 25),
                                  decoration: BoxDecoration(
                                      color: AppColors().main_purple,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: Colors.transparent),
                                      onPressed: () {
                                        getCorrectAnswer();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Result(
                                                selectedOptions:
                                                    selectedOptions,
                                                correctAnswers: correctAnswers,
                                                questionSetID:
                                                    widget.question_set_id),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors().main_white,
                                            fontFamily: "poppins_bold"),
                                      )),
                                )
                              ],
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      goToPreviousQuestion();
                                    },
                                    child: Text(
                                      "Previous",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors().main_white,
                                          fontFamily: "poppins_bold"),
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 3, bottom: 3, left: 25, right: 25),
                                  decoration: BoxDecoration(
                                      color: AppColors().main_purple,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: Colors.transparent),
                                      onPressed: () {
                                        getCorrectAnswer();
                                        goToNextQuestion();
                                      },
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors().main_white,
                                            fontFamily: "poppins_bold"),
                                      )),
                                )
                              ],
                            ),
                          )
                  ],
                ))
            : Center(
                child: Text(
                  "This quiz doesn't have any question",
                  style: TextStyle(
                      fontFamily: "poppins_bold",
                      color: AppColors().main_white,
                      fontSize: 18),
                ),
              ));
  }

  void printSelectedOption() {
    print("Selected Options: $selectedOptions");
    print("Correct Answers: $correctAnswers");
  }
}

class Result extends StatefulWidget {
  final List<dynamic> selectedOptions;
  final List<dynamic> correctAnswers;
  final String questionSetID;

  bool? review;

  Result(
      {this.review,
      required this.selectedOptions,
      required this.correctAnswers,
      required this.questionSetID});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List<dynamic> MarkInformation(
      List<dynamic> selectedOptions, List<dynamic> correctAnswers) {
    print(selectedOptions);
    print(correctAnswers);
    int mark = 0;
    List<bool> compareResult = [];
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] is List ||
          selectedOptions[i].toString().contains('[') ||
          selectedOptions[i].toString().contains(']')) {
        if (selectedOptions[i] is List) {
          String cleanString =
              correctAnswers[i].replaceAll(RegExp(r'[\[\]\s]'), '');
          List<String> correctAnswerIsList = cleanString.split(',');

          bool isCorrect = ListEquality()
              .equals(selectedOptions[i]..sort(), correctAnswerIsList..sort());

          if (isCorrect && selectedOptions[i] != null) {
            mark++;
            compareResult.add(true);
          } else {
            compareResult.add(false);
          }
        } else {
          String cleanString_1 =
              correctAnswers[i].replaceAll(RegExp(r'[\[\]\s]'), '');
          List<String> correctAnswerIsList = cleanString_1.split(',');

          String cleanString_2 =
              selectedOptions[i].replaceAll(RegExp(r'[\[\]\s]'), '');
          List<String> selectedOptionIsList = cleanString_2.split(',');

          bool isCorrect = ListEquality().equals(
              selectedOptionIsList..sort(), correctAnswerIsList..sort());

          if (isCorrect && selectedOptions[i] != null) {
            mark++;
            compareResult.add(true);
          } else {
            compareResult.add(false);
          }
        }
      } else {
        bool isCorrect = selectedOptions[i].toString().trim() ==
            correctAnswers[i].toString().trim();
        if (isCorrect && selectedOptions[i] != null) {
          mark++;
          compareResult.add(true);
        } else {
          compareResult.add(false);
        }
      }
    }

    double score = (10 / selectedOptions.length) * mark;
    return [
      mark,
      double.parse(score.toStringAsFixed(1)),
      selectedOptions,
      correctAnswers,
      compareResult
    ];
  }

  List<dynamic> question = [];

  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> fetchedQuestions =
        await FirebaseService().getQuestionsBySetId(widget.questionSetID);

    setState(() {
      question = fetchedQuestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> result =
        MarkInformation(widget.selectedOptions, widget.correctAnswers);

    bool isPassed = (result[0] / widget.selectedOptions.length) >= 0.5;

    int currentIndex = -1;

    return Scaffold(
      backgroundColor: AppColors().black_1,
      appBar: AppBar(
        leading: (widget.review == true)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: AppColors().main_white,
                ),
              )
            : Container(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors().black_1,
        title: const Text(
          "Result",
          style: TextStyle(fontFamily: "poppins_bold"),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 48),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Your score",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors().main_grey_2,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: Text(
                "${result[1]}",
                style: const TextStyle(
                    fontSize: 40,
                    fontFamily: "poppins_bold",
                    color: Colors.amber),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                "You have passed",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors().main_grey_2,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: CircularPercentIndicator(
                animation: true,
                radius: 60.0,
                lineWidth: 15,
                percent: result[0] / widget.selectedOptions.length,
                center: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 30),
                    children: <TextSpan>[
                      TextSpan(
                          text: "${result[0]}/",
                          style: TextStyle(
                              fontFamily: "poppins_bold",
                              color: (isPassed)
                                  ? AppColors().main_green
                                  : AppColors().main_red)),
                      TextSpan(text: '${widget.selectedOptions.length}'),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                progressColor:
                    (isPassed) ? AppColors().main_green : AppColors().main_red,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Center(
                      child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Check your answer",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors().main_grey_2,
                      ),
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Center(
                        child: Text(
                          "ID",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "poppins_bold",
                              color: AppColors().main_purple),
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: Text(
                          "Chose",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "poppins_bold",
                              color: AppColors().main_purple),
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: Text(
                          "Correct",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "poppins_bold",
                              color: AppColors().main_purple),
                        ),
                      )),
                    ],
                  ),
                  ...result[2].map((selectedOption) {
                    currentIndex++;
                    bool is_wrong = !result[4][currentIndex];
                    return Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 41, 41, 41),
                                  width: 2))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Center(
                            child: Text(
                              "$currentIndex",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "poppins_regular",
                                  color: (is_wrong)
                                      ? AppColors().main_red
                                      : AppColors().main_white),
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(
                              "$selectedOption",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "poppins_regular",
                                  color: (is_wrong)
                                      ? AppColors().main_red
                                      : AppColors().main_white),
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(
                              "${result[3][currentIndex]}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "poppins_regular",
                                  color: (is_wrong)
                                      ? AppColors().main_red
                                      : AppColors().main_white),
                            ),
                          )),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: (widget.review == true)
              ? Text("")
              : Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 25),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          backgroundColor: AppColors().main_purple,
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 45, left: 45)),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Notification"),
                              content:
                                  const Text("Your answers will be saved."),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    DateTime now = DateTime.now();
                                    ResultClass resultClass = ResultClass(
                                        username: FirebaseAuth
                                            .instance.currentUser!.email,
                                        joiner_id: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        questionSetId: widget.questionSetID,
                                        score: result[1],
                                        timeSubmit:
                                            DateFormat('HH:mm, dd/MM/yyyy')
                                                .format(now),
                                        numberOfQuestions:
                                            widget.selectedOptions.length,
                                        numberOfCorrectAnswers: result[0],
                                        selectedOptions: widget.selectedOptions
                                            .map(
                                                (element) => element.toString())
                                            .toList(),
                                        correctAnswer: widget.correctAnswers
                                            .map(
                                                (element) => element.toString())
                                            .toList(),
                                        owner_id: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        questions: question
                                            .map(
                                                (element) => element.toString())
                                            .toList());

                                    resultClass.addToFirestore();
                                    Navigator.pushReplacementNamed(
                                        context, route.main_page);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Save and exit",
                        style: TextStyle(
                            fontFamily: "poppins_bold",
                            fontSize: AppFontSize().h3),
                      )),
                )),
    );
  }
}

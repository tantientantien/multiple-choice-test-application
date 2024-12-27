// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as icon;
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quiz_app/controller/data/handle_question_set.dart';
import 'package:quiz_app/controller/data/handle_rooms.dart';
import 'package:quiz_app/controller/provider/input_provider.dart';
import 'package:quiz_app/model/class/question_set.dart';
import 'package:quiz_app/model/class/questions.dart';
import 'package:quiz_app/view/screens/answer_question.dart';
import 'package:quiz_app/view/screens/create_questions.dart';
import 'package:quiz_app/view/screens/create_room_page.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:quiz_app/view/theme/configs/font_size.dart';
import 'package:iconsax/iconsax.dart' as iconsax;
import 'package:quiz_app/view/theme/configs/handle_image.dart';
import '../../controller/route/route.dart' as route;
import '../theme/configs/handle_string.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _room_id = TextEditingController();

  Future<List<QuestionSet>> question_set = HandleQuestionSet()
      .FetchDataQuestionSet(FirebaseAuth.instance.currentUser!.uid);

  bool hasLoadedData = false;

  int? questionCount;

  @override
  void dispose() {
    _room_id.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background/sub_bgr_1.png"),
                  fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(children: [
                  Expanded(
                    child: ListView(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Let's Quize!",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: AppColors().main_white,
                                fontFamily: 'poppins_bold',
                                fontSize: AppFontSize().h1),
                          ),
                          IconButton(
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  question_set = HandleQuestionSet()
                                      .FetchDataQuestionSet(FirebaseAuth
                                          .instance.currentUser!.uid);
                                });
                              },
                              icon: icon.ReloadWindow(
                                width: 100,
                                color: AppColors().main_white,
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors().purple_white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Enter a quiz code \n',
                                                style: TextStyle(
                                                    fontFamily: 'poppins_bold',
                                                    fontSize: AppFontSize().h2,
                                                    color:
                                                        AppColors().main_black,
                                                    decoration:
                                                        TextDecoration.none)),
                                            TextSpan(
                                                text: 'to join a room',
                                                style: TextStyle(
                                                    fontSize: AppFontSize().h4,
                                                    color:
                                                        AppColors().main_grey,
                                                    fontFamily:
                                                        'poppins_regular',
                                                    decoration:
                                                        TextDecoration.none)),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          iconSize: 30,
                                          onPressed: () async {
                                            String s = await FirebaseStorage
                                                .instance
                                                .ref()
                                                .child(
                                                    'question_set_image/default.jpg')
                                                .getDownloadURL();
                                            print(s.toString());
                                          },
                                          icon: icon.ScanQrCode(
                                            color: AppColors().main_black,
                                            width: 100,
                                          ))
                                    ],
                                  )),
                              TextField(
                                controller: _room_id,
                                style: TextStyle(fontSize: AppFontSize().h4),
                                decoration: InputDecoration(
                                  errorStyle:
                                      TextStyle(fontSize: AppFontSize().h5),
                                  errorText:
                                      context.watch<InputProvider>().error_text,
                                  hintText: "Ex: ie6Hqj9DLgLnLrrTz48Q",
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: Text(
                                        "Enter",
                                        style: TextStyle(
                                            fontFamily: 'poppins_bold',
                                            fontSize: AppFontSize().h4),
                                      ),
                                      onPressed: () async {
                                        bool isExist = await HandleRooms()
                                            .IsRoomExist(_room_id);
                                        bool isNotOverParticipant =
                                            await HandleRooms()
                                                .IsNotOverParticipant(_room_id);
                                        if (_room_id.text.isEmpty) {
                                          context
                                              .read<InputProvider>()
                                              .setErrorText(
                                                  "Please, enter room code!.");
                                        } else if (!isExist) {
                                          context
                                              .read<InputProvider>()
                                              .setErrorText(
                                                  "Room does not exist");
                                        } else if (!isNotOverParticipant) {
                                          context
                                              .read<InputProvider>()
                                              .setErrorText(
                                                  "This room already has enough members.");
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AnswerQuestionPage(
                                                      room_id: _room_id.text),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Your Quiz',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: AppFontSize().h3,
                                      fontFamily: 'poppins_bold',
                                      color: AppColors().main_white),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      iconsax.Iconsax.arrow_right_34,
                                      color: AppColors().main_white,
                                      weight: 50,
                                    ))
                              ],
                            ),
                          ),
                          Container(
                              height: 230,
                              child: FutureBuilder(
                                future: question_set,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 10,
                                      color: AppColors().main_purple,
                                    ));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else if (!snapshot.hasData) {
                                    return Center(
                                      child: Text(
                                        'No data',
                                        style: TextStyle(
                                            color: AppColors().main_black),
                                      ),
                                    );
                                  } else {
                                    final List<QuestionSet> questionSetData =
                                        snapshot.data!;

                                    return (questionSetData.isEmpty)
                                        ? Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: AppColors().main_white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "The quizzes you create will appear here.",
                                                  style: TextStyle(
                                                      color: AppColors()
                                                          .main_black,
                                                      fontFamily:
                                                          "poppins_bold",
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: questionSetData.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    right: 30),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      minimumSize:
                                                          const Size(200, 300),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                      backgroundColor:
                                                          AppColors()
                                                              .purple_white,
                                                      elevation: 0.0),
                                                  onPressed: () async {
                                                    print(questionSetData[index]
                                                        .questionSetName);
                                                    String? quizCode =
                                                        await FirebaseService()
                                                            .getRoomDocumentId(
                                                                questionSetData[
                                                                        index]
                                                                    .id!);
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => QuizDetailPage(
                                                            questionSetId:
                                                                questionSetData[
                                                                        index]
                                                                    .id,
                                                            quizBanner:
                                                                questionSetData[
                                                                        index]
                                                                    .background,
                                                            quizCode: quizCode!,
                                                            quizName:
                                                                questionSetData[
                                                                        index]
                                                                    .questionSetName)));
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 300,
                                                        height: 150,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Colors.grey),
                                                        child: ClipRRect(
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15)),
                                                            child: HandleImage()
                                                                .AutoRenderImageDefault(
                                                                    questionSetData[
                                                                            index]
                                                                        .background)),
                                                      ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                            bottom: 10,
                                                          ),
                                                          width: 270,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    HandleString()
                                                                        .SplitString(
                                                                      questionSetData[
                                                                              index]
                                                                          .questionSetName,
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'poppins_bold',
                                                                      fontSize:
                                                                          AppFontSize()
                                                                              .h4,
                                                                      color: AppColors()
                                                                          .main_black,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            15,
                                                                            3,
                                                                            15,
                                                                            3),
                                                                    decoration: BoxDecoration(
                                                                        color: AppColors()
                                                                            .main_purple,
                                                                        borderRadius:
                                                                            BorderRadius.circular(50)),
                                                                    child: Text(
                                                                      "${questionSetData[index].numberOfQuestion.toString()}Q",
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'poppins_bold',
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: AppColors()
                                                                        .main_grey,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  child: Image
                                                                      .network(
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .photoURL
                                                                        .toString(),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                  }
                                },
                              )),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 25),
                            child: FutureBuilder(
                              future: HandleQuestionSet().getTopics(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        'Đã xảy ra lỗi: ${snapshot.error}'),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text('Không có dữ liệu'),
                                  );
                                }
                                return Column(
                                  children:
                                      snapshot.data!.reversed.map((topicData) {
                                    return Container(
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${topicData["topic_name"]}",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize:
                                                            AppFontSize().h3,
                                                        fontFamily:
                                                            'poppins_bold',
                                                        color: AppColors()
                                                            .main_white),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        iconsax.Iconsax
                                                            .arrow_right_34,
                                                        color: AppColors()
                                                            .main_white,
                                                        weight: 50,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            ...topicData["question_set_id"]
                                                .map((questionSetID) {
                                              return FutureBuilder<
                                                  Map<String, dynamic>?>(
                                                future: HandleQuestionSet()
                                                    .getQuestionSet(
                                                        questionSetID),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            Map<String,
                                                                dynamic>?>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'),
                                                    );
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      snapshot.data == null) {
                                                    return const Center(
                                                      child: Text(
                                                          'Document not found'),
                                                    );
                                                  }

                                                  Map<String, dynamic>?
                                                      questionSetData =
                                                      snapshot.data;
                                                  return Container(
                                                    width: double.infinity,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: ListView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      children: [
                                                        Container(
                                                          width: 200,
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) => Test(
                                                                          question_set_id:
                                                                              "${questionSetID}",
                                                                          timeLimit:
                                                                              questionSetData["time_limit"])),
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16)),
                                                                  backgroundColor:
                                                                      AppColors()
                                                                          .main_white,
                                                                  elevation:
                                                                      0.0),
                                                              child: Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("${questionSetData!["question_set_name"]}", style: TextStyle(fontFamily: "poppins_bold", fontSize: 18, color: AppColors().main_black)),
                                                                              FutureBuilder<int>(
                                                                                future: HandleQuestionSet().getQuestionCount(questionSetID),
                                                                                builder: (context, snapshot) {
                                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                    return const Text(
                                                                                      'Loading...',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17,
                                                                                        color: Colors.white,
                                                                                        fontFamily: 'poppins_bold',
                                                                                      ),
                                                                                    );
                                                                                  } else if (snapshot.hasError) {
                                                                                    return Text(
                                                                                      'Error: ${snapshot.error}',
                                                                                      style: const TextStyle(
                                                                                        fontSize: 17,
                                                                                        color: Colors.white,
                                                                                        fontFamily: 'poppins_bold',
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return Text(
                                                                                      '${snapshot.data}Q',
                                                                                      style: TextStyle(
                                                                                        fontSize: 15,
                                                                                        color: AppColors().main_purple,
                                                                                        fontFamily: 'poppins_bold',
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Image
                                                                        .network(
                                                                      "${questionSetData["background"]}",
                                                                      scale: 7,
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            })
                                          ],
                                        ));
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  )
                ]),
              ),
            )));
  }
}

class QuizDetailPage extends StatelessWidget {
  String quizName;
  String quizCode;
  String quizBanner;
  String? questionSetId;

  QuizDetailPage(
      {required this.quizName,
      required this.quizCode,
      required this.quizBanner,
      this.questionSetId});

  Future<List<QuizQuestion>> DetailQuestion(questionSetId) async {
    List<QuizQuestion> _questions =
        await FirebaseService().getQuestions(questionSetId!);
    return _questions;
  }

  Stream<List<QuizQuestion>> StreamDetailQuestion(String questionSetId) {
    return FirebaseService().streamQuestions(questionSetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors().main_black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          quizName,
          style: TextStyle(
            fontFamily: "poppins_bold",
            color: AppColors().main_black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(children: [
          Container(
            child: CarouselSlider(
              options:
                  CarouselOptions(height: 240, enableInfiniteScroll: false),
              items: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                        width: double.infinity,
                        height: 240,
                        child:
                            HandleImage().AutoRenderImageDefault(quizBanner)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Scan here',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    QrImageView(
                      data: quizCode,
                      size: 150,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'to get code',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18),
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Quiz code: ",
                          style: TextStyle(
                            fontFamily: "poppins_bold",
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: quizCode,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  color: AppColors().main_grey,
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: quizCode));
                    final snackBar =
                        SnackBar(content: const Text('Copied to clipboard'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<QuizQuestion>>(
              stream: StreamDetailQuestion(questionSetId!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<QuizQuestion>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 10,
                    color: AppColors().main_purple,
                  ));
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        QuizQuestion question = snapshot.data![index];
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Question ${index + 1}:",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "poppins_bold",
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateQuestionsPage(
                                                      questionID: question
                                                          .questionDocID,
                                                      selected_option_single_choice:
                                                          question
                                                              .correctAnswer,
                                                      selected_options:
                                                          question.options,
                                                      selectedImagePath:
                                                          question.mediaLink,
                                                      questionType:
                                                          question.questionType,
                                                      is_multi_choice: question
                                                          .ismultiselect,
                                                      isUpdate: true,
                                                      question:
                                                          question.question,
                                                      quizName:
                                                          "Update: ${quizName}",
                                                      question_set_id:
                                                          questionSetId!,
                                                      roomCode: quizCode)),
                                        );
                                      },
                                      icon: const Icon(Icons.edit_note))
                                ],
                              ),
                              Text("${question.question}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    backgroundColor: AppColors().main_purple,
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, right: 45, left: 45)),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CreateQuestionsPage(
                            quizName: quizName,
                            question_set_id: questionSetId!,
                            roomCode: quizCode)),
                  );
                },
                child: Text(
                  "Add question",
                  style: TextStyle(
                      fontFamily: "poppins_bold", fontSize: AppFontSize().h3),
                )),
          ),
        ]),
      ),
    );
  }
}

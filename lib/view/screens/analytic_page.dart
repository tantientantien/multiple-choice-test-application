import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/controller/data/handle_question_set.dart';
import 'package:quiz_app/model/class/question_set.dart';
import 'package:quiz_app/model/class/questions.dart';
import 'package:quiz_app/view/screens/answer_question.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:quiz_app/view/theme/configs/font_size.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quiz_app/view/theme/configs/handle_image.dart';
import 'package:quiz_app/view/theme/configs/handle_string.dart';

class StatisticsPage extends StatelessWidget {
  Future<List<QuestionSet>> question_set = HandleQuestionSet()
      .FetchDataQuestionSet(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 16,
            top: 25,
          ),
          child: Text("Statistics",
              style: TextStyle(
                  fontSize: AppFontSize().h3,
                  fontFamily: 'poppins_bold',
                  color: AppColors().main_black)),
        ),
        Container(
          height: 350,
          width: double.infinity,
          child: FutureBuilder(
              future: question_set,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                  return const Center(
                    child: Text('No data'),
                  );
                } else {
                  final List<QuestionSet> questionSetData = snapshot.data!;
                  return (questionSetData.isEmpty)
                      ? Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                "The statistics of data for each of your quizzes will appear here.",
                                style: TextStyle(
                                    color: AppColors().main_black,
                                    fontFamily: "poppins_bold",
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis
                              .horizontal, // Thay đổi từ Axis.vertical thành Axis.horizontal
                          itemCount: questionSetData.length,
                          itemBuilder: (context, index) {
                            final questionSet = questionSetData[index];
                            // Return your widget here using the questionSet data
                            return Container(
                                height: 200,
                                margin: const EdgeInsets.only(
                                    top: 25, left: 16, right: 16, bottom: 25),
                                width:
                                    280, // Đảm bảo Container có chiều rộng cố định
                                decoration: BoxDecoration(
                                  color: AppColors().main_white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(0),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0.0),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StatisticsDetail(
                                                    questionSetId:
                                                        questionSetData[index]
                                                            .id!)),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: HandleImage()
                                                .AutoRenderImageDefault(
                                              questionSet.background,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 16, right: 16, top: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${questionSetData[index].questionSetName}",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'poppins_bold',
                                                          fontSize:
                                                              AppFontSize().h3,
                                                          color: AppColors()
                                                              .main_orange,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                15, 3, 15, 3),
                                                        decoration: BoxDecoration(
                                                            color: AppColors()
                                                                .main_orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child:
                                                            FutureBuilder<int>(
                                                          future: HandleQuestionSet()
                                                              .getQuestionCount(
                                                                  questionSetData[
                                                                          index]
                                                                      .id!),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const Text(
                                                                'Loading...',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'poppins_bold',
                                                                ),
                                                              );
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                'Error: ${snapshot.error}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'poppins_bold',
                                                                ),
                                                              );
                                                            } else {
                                                              return Text(
                                                                '${snapshot.data}Q',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'poppins_bold',
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ]),
                                              ],
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 16),
                                          child: Row(
                                            children: [
                                              iconoir.EyeAlt(),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              FutureBuilder<int>(
                                                future: FirebaseService()
                                                    .countDocumentsInResultsCollection(
                                                        questionSetData[index]
                                                            .id!),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<int>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else {
                                                    int documentCount =
                                                        snapshot.data ?? 0;
                                                    return Text(
                                                      '$documentCount',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )));
                          },
                        );
                }
              }),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 16,
            top: 25,
          ),
          child: Text("Joined",
              style: TextStyle(
                  fontSize: AppFontSize().h3,
                  fontFamily: 'poppins_bold',
                  color: AppColors().main_black)),
        ),
        StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
          stream: FirebaseService().getDocumentsByJoinerIdStream(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>>
                  snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data'),
              );
            } else {
              final List<DocumentSnapshot<Map<String, dynamic>>> documents =
                  snapshot.data!;
              return Column(
                children: documents.map((document) {
                  return FutureBuilder<String>(
                    //future này chỉ phục vụ duy nhất một tác vụ là lấy username của người tạo ra  câu hỏi, những giá trị khác trong  return không liên quan đến các thông tin khác
                    future: FirebaseService().getUsernameFromQuestionSet(
                        document["question_set_id"]),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          alignment: Alignment.center,
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final username = snapshot.data ?? "";
                        return Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 25, top: 25),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.5),
                              //     spreadRadius: 5,
                              //     blurRadius: 7,
                              //     offset: Offset(0, 3),
                              //   ),
                              // ],
                              border: Border.all(
                                  color: AppColors().main_grey, width: 3),
                              color: AppColors().main_white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String>(
                                    //future này chỉ phục vụ duy nhất một tác vụ là lấy question_set_name, những giá trị khác trong  return không liên quan đến các thông tin khác
                                    future: FirebaseService()
                                        .getQuestionSetNameFromQuestionSet(
                                            document["question_set_id"]),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          width: double.infinity,
                                          height: 150,
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Container(
                                          width: double.infinity,
                                          height: 150,
                                          alignment: Alignment.center,
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        final questionSetName =
                                            snapshot.data ?? "";
                                        return Text(
                                          questionSetName,
                                          style: TextStyle(
                                              fontFamily: "poppins_bold",
                                              color: AppColors().main_orange,
                                              fontSize: 25),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    "Score: ${document["score"].toString()}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors().main_grey_2),
                                  ),
                                  Text(
                                    "Time Submit: ${document["time_submit"].toString()}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors().main_grey_2),
                                  ),
                                  Text(
                                    "Author: ${username}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors().main_grey_2),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Result(
                                                  review: true,
                                                  selectedOptions: document[
                                                      "selected_options"],
                                                  correctAnswers:
                                                      document["correctAnswer"],
                                                  questionSetID: document[
                                                      "question_set_id"]),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Detail >>",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "poppins_bold",
                                              color: AppColors().main_orange),
                                        )),
                                  )
                                ],
                              ),
                            ));
                      }
                    },
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    ));
  }
}

// class AnalyticPage extends StatelessWidget {
//   Future<List<QuestionSet>> question_set = HandleQuestionSet()
//       .FetchDataQuestionSet(FirebaseAuth.instance.currentUser!.uid);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       body: ListView(children: [
//         Container(
//             margin: EdgeInsets.only(top: 25, bottom: 25),
//             width: double.infinity,
//             child: CarouselSlider(
//               options:
//                   CarouselOptions(height: 300, enableInfiniteScroll: false),
//               items: [
//  FutureBuilder(
// future: question_set,
// builder: (context, snapshot) {
//   if (snapshot.connectionState == ConnectionState.waiting) {
//     return Center(
//         child: CircularProgressIndicator(
//       strokeWidth: 10,
//       color: AppColors().main_purple,
//     ));
//   } else if (snapshot.hasError) {
//     return Center(
//       child: Text('Error: ${snapshot.error}'),
//     );
//   } else if (!snapshot.hasData) {
//     return const Center(
//       child: Text('No data'),
//     );
//   } else {
//     final List<QuestionSet> questionSetData =
//                         snapshot.data!;
//     return Text(questionSetData)
//   }
// })
//               ]
//             ))
//       ]),
//     ));
//   }
// }

// Container(
//             margin: const EdgeInsets.all(16),
//             width: double.infinity,
//             height: 150,
//             decoration: BoxDecoration(
//                 color: AppColors().main_orange_opa,
//                 borderRadius: BorderRadius.circular(15)),
//             child: Stack(
//               children: [
//                 Positioned(
//                     top: 16,
//                     left: 16,
//                     child: Text(
//                       "test test test",
//                       style: TextStyle(
//                           fontSize: AppFontSize().h2,
//                           fontFamily: 'poppins_bold'),
//                     )),
//                 Positioned(
//                     top: 48,
//                     left: 16,
//                     child: Text(
//                       "creator: " + "tantientatoo@gmail.com",
//                       style: TextStyle(color: AppColors().main_grey),
//                     )),
//                 Positioned(
//                     top: 66,
//                     left: 16,
//                     child: Text(
//                       "Your score: " + "10",
//                       style: TextStyle(color: AppColors().main_grey),
//                     )),
//                 Positioned(
//                     bottom: 16,
//                     right: 16,
//                     child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors().main_black),
//                         onPressed: () async {
//                           DocumentSnapshot snap = await FirebaseFirestore
//                               .instance
//                               .collection('rooms')
//                               .doc("ie6Hqj9DLgLnLrrTz48Q")
//                               .get();
//                           dynamic x = snap.data();
//                           print(x["room_name"]);
//                         },
//                         icon: iconoir.Iconoir(
//                           color: AppColors().main_white,
//                         ),
//                         label: const Text("Detail")))
//               ],
//             )),
//         Container(
//             margin: const EdgeInsets.all(16),
//             width: double.infinity,
//             height: 150,
//             decoration: BoxDecoration(
//                 color: AppColors().main_orange_opa,
//                 borderRadius: BorderRadius.circular(15)),
//             child: Stack(
//               children: [
//                 Positioned(
//                     top: 16,
//                     left: 16,
//                     child: Text(
//                       "test test test",
//                       style: TextStyle(
//                           fontSize: AppFontSize().h2,
//                           fontFamily: 'poppins_bold'),
//                     )),
//                 Positioned(
//                     top: 48,
//                     left: 16,
//                     child: Text(
//                       "creator: " + "tantientatoo@gmail.com",
//                       style: TextStyle(color: AppColors().main_grey),
//                     )),
//                 Positioned(
//                     top: 66,
//                     left: 16,
//                     child: Text(
//                       "Your score: " + "10",
//                       style: TextStyle(color: AppColors().main_grey),
//                     )),
//                 Positioned(
//                     bottom: 16,
//                     right: 16,
//                     child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors().main_black),
//                         onPressed: () {
//                           print(FirebaseAuth.instance.currentUser?.photoURL);
//                         },
//                         icon: iconoir.Iconoir(
//                           color: AppColors().main_white,
//                         ),
//                         label: const Text("Detail")))
//               ],
//             ))

class StatisticsDetail extends StatelessWidget {
  final String questionSetId;

  StatisticsDetail({required this.questionSetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors().main_black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Statistics",
          style: TextStyle(
            fontFamily: "poppins_bold",
            color: AppColors().main_black,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 25, top: 25),
                    child: Text("General",
                        style: TextStyle(
                            fontSize: AppFontSize().h4,
                            fontFamily: 'poppins_bold',
                            color: AppColors().main_black)),
                  ),
                  Container(
                    width: double.infinity,
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: FirebaseService()
                          .getDocumentDataFromQuestionSet(questionSetId),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          if (snapshot.hasData && snapshot.data != null) {
                            Map<String, dynamic>? data = snapshot.data;

                            // return Center(
                            //   child: Text(
                            //       '${data?['background']}'),
                            // );
                            return Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 200,
                                  margin: const EdgeInsets.only(right: 25),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: HandleImage()
                                          .AutoRenderImageDefault(
                                              "${data?['background']}")),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${data?['question_set_name']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: "poppins_bold",
                                      ),
                                    ),
                                    FutureBuilder<int>(
                                      future: FirebaseService()
                                          .countDocumentsInResultsCollection(
                                              questionSetId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          int documentCount =
                                              snapshot.data ?? 0;
                                          return Text(
                                            'View: $documentCount',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 25, top: 25),
                    child: Text("Detail",
                        style: TextStyle(
                            fontSize: AppFontSize().h4,
                            fontFamily: 'poppins_bold',
                            color: AppColors().main_black)),
                  ),
                  // TypeAheadField(
                  //   builder: (context, controller, focusNode) {
                  //     return TextField(
                  //         controller: controller,
                  //         focusNode: focusNode,
                  //         autofocus: true,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(16)),
                  //         ));
                  //   },
                  //   suggestionsCallback: (pattern) async {
                  //     // Tìm kiếm các document từ Firestore dựa trên pattern (từ khóa tìm kiếm)
                  //     // Đây là nơi bạn truy vấn Firestore để lấy danh sách các gợi ý dựa trên từ khóa pattern
                  //     // Trả về danh sách các gợi ý dưới dạng List<String>
                  //     // Ví dụ: return ["Result 1", "Result 2", "Result 3"];
                  //     return ["Result 1", "Result 2", "Result 3"];
                  //   },
                  //   itemBuilder: (context, suggestion) {
                  //     // Xây dựng giao diện cho từng gợi ý trong danh sách
                  //     return ListTile(
                  //       title: Text(suggestion.toString()),
                  //     );
                  //   },
                  //   onSelected: (Object? value) {},
                  // ),
                  FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                    future: FirebaseService().getResults(questionSetId),
                    builder: (BuildContext context,
                        AsyncSnapshot<
                                List<DocumentSnapshot<Map<String, dynamic>>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        List<DocumentSnapshot<Map<String, dynamic>>> documents =
                            snapshot.data ?? [];

                        return Column(
                          children: documents.map(
                              (DocumentSnapshot<Map<String, dynamic>>
                                  document) {
                            Map<String, dynamic> data = document.data() ?? {};

                            // Xây dựng giao diện cho từng document ở đây
                            // return ListTile(
                            //   title:
                            //       Text(data['score'].toString() ?? 'No Title'),
                            //   // Thay 'title' bằng trường bạn muốn hiển thị từ mỗi document
                            // );
                            return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors().main_purple,
                                        width: 2)),
                                // child: Text(data['score'].toString()),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors().main_purple),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: HandleString().SplitEmail(
                                                "Joiner: ${data['joiner_username']}"),
                                          ),
                                          TextSpan(
                                              text:
                                                  '\nResult: ${data['number_of_correct_answers']}/${data['number_of_questions']}'),
                                          TextSpan(
                                              text:
                                                  '\nScore: ${data['score']}'),
                                          TextSpan(
                                            text:
                                                "\nTime Submit: ${data['time_submit']}",
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Result(
                                                review: true,
                                                selectedOptions:
                                                    data['selected_options'],
                                                correctAnswers:
                                                    data['correctAnswer'],
                                                questionSetID: questionSetId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Detail >",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    AppColors().main_purple)))
                                  ],
                                ));
                          }).toList(),
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

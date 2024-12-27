import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconoir_flutter/font_size.dart';
import 'package:quiz_app/view/theme/configs/handle_image.dart';
import 'package:searchfield/searchfield.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:iconsax/iconsax.dart' as iconsax;
import 'package:timer_count_down/timer_count_down.dart';
import '../theme/configs/font_size.dart';
import '../theme/configs/handle_string.dart';
import '../../controller/route/route.dart' as route;

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().main_white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "Room",
      //     style: TextStyle(
      //         color: AppColors().main_black,
      //         fontFamily: "poppins_bold",
      //         fontSize: 25),
      //   ),
      //   backgroundColor: AppColors().main_white,
      //   elevation: 0.0,
      // ),
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.all(16),
        child: ListView(scrollDirection: Axis.vertical, children: [
          // SearchAnchor(
          //     builder: (BuildContext context, SearchController controller) {
          //   return SearchBar(
          //     hintText: "Search room",
          //     controller: controller,
          //     padding: const MaterialStatePropertyAll<EdgeInsets>(
          //       EdgeInsets.symmetric(horizontal: 16.0),
          //     ),
          //     onTap: () {
          //       controller.openView();
          //     },
          //     onChanged: (_) {
          //       controller.openView();
          //     },
          //     leading: const Icon(Icons.search),
          //   );
          // }, suggestionsBuilder:
          //         (BuildContext context, SearchController controller) {
          //   return List<ListTile>.generate(5, (int index) {
          //     final String item = 'item $index';
          //     return ListTile(
          //       title: Text(item),
          //       onTap: () {
          //         setState(() {
          //           controller.closeView(item);
          //         });
          //       },
          //     );
          //   });
          // }),
          Container(
              margin: const EdgeInsets.only(top: 36, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create quiz',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: AppFontSize().h3,
                        fontFamily: 'poppins_bold',
                        color: AppColors().main_black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    child: SizedBox(
                        width: double.infinity,
                        height: 190,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor:
                                  Color.fromARGB(255, 202, 245, 204),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, route.create_questions);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconoir.AddCircle(
                                color: AppColors().main_green,
                                width: 50,
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              )),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistics',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: AppFontSize().h3,
                    fontFamily: 'poppins_bold',
                    color: AppColors().main_black),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ],
                    color: AppColors().main_white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [],
                ),
              )
            ],
          )),
          // Container(
          //   margin: const EdgeInsets.only(top: 16, bottom: 16),
          //   child: SizedBox(
          //       width: double.infinity,
          //       height: 190,
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //             elevation: 0.0,
          //             backgroundColor: Color.fromARGB(255, 218, 202, 245),
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15))),
          //         onPressed: () {
          //           Navigator.pushNamed(context, route.create_questions);
          //         },
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             iconoir.AddCircle(
          //               color: AppColors().main_purple,
          //               width: 50,
          //             ),
          //             Text(
          //               'Create questions',
          //               style: TextStyle(
          //                   fontSize: AppFontSize().h2,
          //                   color: AppColors().main_purple,
          //                   fontFamily: 'poppins_bold'),
          //             ),
          //           ],
          //         ),
          //       )),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(top: 16, bottom: 16),
          //   child: SizedBox(
          //       width: double.infinity,
          //       height: 190,
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //             elevation: 0.0,
          //             backgroundColor: Color.fromARGB(255, 202, 245, 204),
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15))),
          //         onPressed: () {},
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             iconoir.AddCircle(
          //               color: AppColors().main_green,
          //               width: 50,
          //             ),
          //             Text(
          //               'Create new room!',
          //               style: TextStyle(
          //                   fontSize: AppFontSize().h2,
          //                   color: AppColors().main_green,
          //                   fontFamily: 'poppins_bold'),
          //             ),
          //           ],
          //         ),
          //       )),
          // ),
        ]),
      )),
    );
  }
}

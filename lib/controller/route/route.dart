import 'package:flutter/material.dart';
import 'package:quiz_app/view/screens/answer_question.dart';
import 'package:quiz_app/view/screens/create_questions.dart';

import '../../view/screens/login_page.dart';

import '../../view/screens/home_page.dart';

import '../../view/screens/your_room_subpage.dart';

import '../../view/screens/main_page_navigation.dart';

const String login_page = 'login';
const String home_page = 'home';
const String your_room_subpage = 'your_room_subpage';
const String create_questions = 'create_questions';
const String answer_question = 'answer_question';
const String main_page = 'main_page';
const String test = 'test';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case login_page:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case home_page:
      return MaterialPageRoute(builder: (context) => HomePage());
    case your_room_subpage:
      return MaterialPageRoute(builder: (context) => YourRoomPage());
    case create_questions:
      return MaterialPageRoute(builder: (context) => CreateQuizPage());
    case main_page:
      return MaterialPageRoute(builder: (context) => MainPage());

    default:
      throw ('404');
  }
}

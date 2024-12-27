import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/provider/input_provider.dart';
import 'package:quiz_app/controller/provider/user_answer.dart';
import 'controller/provider/bottom_navigation_bar_provider.dart';
import 'package:quiz_app/view/screens/login_page.dart';
import 'package:quiz_app/view/screens/main_page_navigation.dart';
import './controller/route/route.dart' as route;
import 'package:quiz_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BottomNavigationBarProvider>(
        create: (_) => BottomNavigationBarProvider(),
      ),
      ChangeNotifierProvider<InputProvider>(
        create: (_) => InputProvider(),
      ),
      ChangeNotifierProvider<AnswerProvider>(
        create: (_) => AnswerProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'poppins_regular',
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: route.controller,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return LoginPage();
            } else {
              return MainPage();
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        },
      ),
    );
  }
}

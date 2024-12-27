import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/provider/bottom_navigation_bar_provider.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:quiz_app/view/theme/configs/font_size.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 65),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                FirebaseAuth.instance.currentUser!.displayName.toString(),
                style: TextStyle(
                    fontFamily: "poppins_bold", fontSize: AppFontSize().h4),
              ),
            ),
            Expanded(
                child: Center(
              child: Text("Vùng cấu hình app (âm lượng, video, hình ảnh,...)"),
            ))
          ],
        )),
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(16)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              onPressed: () {
                GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
                context.read<BottomNavigationBarProvider>().setIndexItem(0);
              },
              child: Text(
                'Sign out',
                style: TextStyle(
                    color: AppColors().main_black,
                    fontSize: AppFontSize().h3,
                    fontFamily: "poppins_bold"),
              )),
        )
      ],
    )));
  }
}

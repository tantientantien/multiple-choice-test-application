import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/services/authentication.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';
import 'package:quiz_app/view/theme/configs/font_size.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background/main_bgr.png"),
                  fit: BoxFit.cover),
            ),
            child: Center(
                child: Container(
              height: 300,
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quize!',
                    style: TextStyle(
                        fontFamily: 'poppins_bold',
                        color: AppColors().main_white,
                        fontSize: AppFontSize().logo),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: AppColors().main_white,
                              padding: const EdgeInsets.only(
                                top: 13,
                                bottom: 13,
                              )),
                          onPressed: () async {
                            if (GoogleSignIn().isSignedIn() != true) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 10,
                                      color: AppColors().main_purple,
                                    ));
                                  });
                            }
                            await AuthenticationService().signInWithGoogle();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 16),
                                child: Image.asset(
                                  'assets/images/logo/gmail.png',
                                  scale: 50,
                                ),
                              ),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                    color: AppColors().main_black,
                                    fontSize: AppFontSize().h3,
                                    fontFamily: 'poppins_bold'),
                              )
                            ],
                          )),
                      // Container(
                      //   margin: EdgeInsets.only(top: 16),
                      //   child: TextButton(
                      //       onPressed: () => {
                      //             showModalBottomSheet(
                      //                 context: context,
                      //                 builder: ((context) {
                      //                   return SizedBox(
                      //                     height: 300,
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceEvenly,
                      //                       children: [
                      //                         Container(
                      //                           margin: const EdgeInsets.only(
                      //                               left: 16, right: 16),
                      //                           child: ElevatedButton(
                      //                               style: ElevatedButton
                      //                                   .styleFrom(
                      //                                       elevation: 0,
                      //                                       shape: RoundedRectangleBorder(
                      //                                           borderRadius:
                      //                                               BorderRadius
                      //                                                   .circular(
                      //                                                       20),
                      //                                           side:
                      //                                               const BorderSide(
                      //                                                   color: Color(
                      //                                                       0xFFE8E8E8),
                      //                                                   width:
                      //                                                       2)),
                      //                                       backgroundColor:
                      //                                           const Color(
                      //                                               0xFF1878F3),
                      //                                       padding:
                      //                                           const EdgeInsets
                      //                                               .only(
                      //                                         top: 13,
                      //                                         bottom: 13,
                      //                                       )),
                      //                               onPressed: () async {
                      //                                 try {
                      //                                   await AuthenticationService()
                      //                                       .signInWithFacebook();
                      //                                   if (context.mounted) {
                      //                                     print(FirebaseAuth
                      //                                         .instance
                      //                                         .currentUser!
                      //                                         .displayName);
                      //                                   }
                      //                                 } catch (e) {
                      //                                   print(e);
                      //                                 }
                      //                               },
                      //                               child: Row(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .center,
                      //                                 children: [
                      //                                   Container(
                      //                                     margin:
                      //                                         const EdgeInsets
                      //                                                 .only(
                      //                                             right: 16),
                      //                                     child: Image.asset(
                      //                                       'assets/images/logo/facebook.webp',
                      //                                       scale: 40,
                      //                                     ),
                      //                                   ),
                      //                                   Text(
                      //                                     'Continue with Facebook',
                      //                                     style: TextStyle(
                      //                                         color:
                      //                                             AppColors().main_white,
                      //                                         fontSize: AppFontSize().h3,
                      //                                         fontFamily:
                      //                                             'poppins_bold'),
                      //                                   )
                      //                                 ],
                      //                               )),
                      //                         ),
                      //                         Container(
                      //                           margin: const EdgeInsets.only(
                      //                               left: 16, right: 16),
                      //                           child: ElevatedButton(
                      //                               style: ElevatedButton
                      //                                   .styleFrom(
                      //                                       elevation: 0,
                      //                                       shape: RoundedRectangleBorder(
                      //                                           borderRadius:
                      //                                               BorderRadius
                      //                                                   .circular(
                      //                                                       20),
                      //                                           side:
                      //                                               const BorderSide(
                      //                                                   color: Color(
                      //                                                       0xFFE8E8E8),
                      //                                                   width:
                      //                                                       2)),
                      //                                       backgroundColor:
                      //                                           Colors.white,
                      //                                       padding:
                      //                                           const EdgeInsets
                      //                                               .only(
                      //                                         top: 13,
                      //                                         bottom: 13,
                      //                                       )),
                      //                               onPressed: () => {},
                      //                               child: Row(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .center,
                      //                                 children: [
                      //                                   Text(
                      //                                     'Create a new account!',
                      //                                     style: TextStyle(
                      //                                         color:
                      //                                             Colors.black,
                      //                                         fontSize: AppFontSize().h3,
                      //                                         fontFamily:
                      //                                             'poppins_bold'),
                      //                                   )
                      //                                 ],
                      //                               )),
                      //                         ),
                      //                         Container(
                      //                             margin: const EdgeInsets.only(
                      //                                 left: 16, right: 16),
                      //                             child: Text(
                      //                               'By continuing, you agree to the Term of Use and Privacy Policy',
                      //                               textAlign: TextAlign.center,
                      //                               style: TextStyle(
                      //                                   fontSize: AppFontSize().h4,
                      //                                   color:
                      //                                       AppColors().main_grey),
                      //                             ))
                      //                       ],
                      //                     ),
                      //                   );
                      //                 }))
                      //           },
                      //       child: Text(
                      //         'Other options',
                      //         style: TextStyle(
                      //             color: AppColors().main_white,
                      //             fontSize: AppFontSize().h3,
                      //             fontFamily: 'poppins_bold'),
                      //       )),
                      // )
                    ],
                  )
                ],
              ),
            ))));
  }
}

import 'package:flutter/material.dart';

import '../theme/colors/colors.dart';
import '../theme/configs/font_size.dart';

class YourRoomPage extends StatelessWidget {
  const YourRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: RoomCard(),
    );
  }

  ElevatedButton RoomCard() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, elevation: 0.0),
        onPressed: () {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 40),
          height: 200,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors().main_white,
                          border: Border.all(
                              color: AppColors().main_grey, width: 1)),
                    ),
                  )),
              Positioned(
                  bottom: 16,
                  left: 32,
                  child: Material(
                    child: Container(
                      width: 120,
                      height: 175,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://nhadepso.com/wp-content/uploads/2023/02/hinh-nen-dep-cute-ngau_13.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  right: 50,
                  top: 200 * 0.4,
                  bottom: 0,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: AppColors().main_black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'FLUTTER TEST \n',
                            style: TextStyle(
                                fontFamily: 'poppins_bold',
                                fontSize: AppFontSize().h4)),
                        TextSpan(
                            text: 'Creator: Nguyễn Tân Tiến \n',
                            style: TextStyle(
                                fontSize: AppFontSize().h5,
                                fontFamily: 'poppins_regular',
                                color: AppColors().main_grey)),
                        TextSpan(
                            text: 'Date: 09/09/2023 \n',
                            style: TextStyle(
                                fontSize: AppFontSize().h5,
                                fontFamily: 'poppins_regular',
                                color: AppColors().main_grey)),
                        TextSpan(
                            text: 'Visibility: ',
                            style: TextStyle(
                                fontSize: AppFontSize().h5,
                                fontFamily: 'poppins_regular',
                                color: AppColors().main_grey)),
                        TextSpan(
                            text: 'Private \n',
                            style: TextStyle(
                                fontFamily: 'poppins_bold',
                                fontSize: AppFontSize().h5)),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}

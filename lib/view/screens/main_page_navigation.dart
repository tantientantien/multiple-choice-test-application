import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart' as iconsax;
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/provider/bottom_navigation_bar_provider.dart';
import 'package:quiz_app/view/screens/analytic_page.dart';
import 'package:quiz_app/view/screens/create_questions.dart';
import 'package:quiz_app/view/screens/create_room_page.dart';
import 'package:quiz_app/view/screens/home_page.dart';
import 'package:quiz_app/view/screens/profile_page.dart';
import 'package:quiz_app/view/theme/colors/colors.dart';

class MainPage extends StatelessWidget {
  final List<IconData> icons = [
    iconsax.Iconsax.home_25,
    iconsax.Iconsax.additem5,
    iconsax.Iconsax.cup5,
    iconsax.Iconsax.profile_circle5,
  ];

  final List<Widget> screens = [
    HomePage(),
    CreateQuizPage(),
    StatisticsPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    int currentIndex = context.watch<BottomNavigationBarProvider>().index_item;
    IconData selectedIcon = icons[currentIndex];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          onTap: (index) {
            context.read<BottomNavigationBarProvider>().setIndexItem(index);
          },
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          unselectedItemColor: const Color(0xFFA9A9A9),
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
              icon: (currentIndex == 0)
                  ? Icon(
                      selectedIcon,
                      color: AppColors().main_purple,
                    )
                  : const Icon(
                      iconsax.Iconsax.home_2,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: (currentIndex == 1)
                  ? Icon(
                      selectedIcon,
                      color: AppColors().main_green,
                    )
                  : const Icon(
                      iconsax.Iconsax.additem,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: (currentIndex == 2)
                  ? Icon(
                      selectedIcon,
                      color: AppColors().main_orange,
                    )
                  : const Icon(
                      iconsax.Iconsax.cup,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: (currentIndex == 3)
                  ? Icon(
                      selectedIcon,
                      color: Colors.amber,
                    )
                  : const Icon(
                      iconsax.Iconsax.profile_circle,
                    ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

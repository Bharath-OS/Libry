import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:libry/screens/settings.dart';
import 'package:libry/screens/transactions.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../constants/app_colors.dart';
import 'books_screen.dart';
import 'home.dart';
import 'members.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _controller = PageController();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    BooksScreen(),
    MembersScreen(),
    TransactionsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(), // disables swipe
        children: _screens,
      ),
      bottomNavigationBar: StylishBottomBar(
        elevation: 3,
        notchStyle: NotchStyle.square,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _controller.jumpToPage(index);
        },
        items: [
          BottomBarItem(
            icon: svgIcon(path: "assets/icons/home-icon.svg", index: 0),
            selectedColor: MyColors.primaryButtonColor,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: svgIcon(path: "assets/icons/books-icon.svg", index: 1),
            selectedColor: MyColors.primaryButtonColor,
            title: const Text('Books'),
          ),
          BottomBarItem(
            icon: svgIcon(path: "assets/icons/members-icon.svg", index: 2),
            selectedColor: MyColors.primaryButtonColor,
            title: const Text('Members'),
          ),
          BottomBarItem(
            icon: svgIcon(path: "assets/icons/transactions-icon.svg", index: 3),
            selectedColor: MyColors.primaryButtonColor,
            title: const Text('Transactions'),
          ),
          BottomBarItem(
            icon: svgIcon(path: "assets/icons/settings-icon.svg", index: 4),
            selectedColor: MyColors.primaryButtonColor,
            title: const Text('Settings'),
          ),
        ],
        option: AnimatedBarOptions(
          iconSize: 32,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.simple,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget svgIcon({required String path, required int index}) {
    return SvgPicture.asset(
      path,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        _selectedIndex == index ? MyColors.primaryButtonColor : const Color(0xff000000),
        BlendMode.srcIn,
      ),
    );
  }
}
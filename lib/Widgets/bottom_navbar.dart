import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../Utilities/constants.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final selectedColor = MyColors.primaryButtonColor;
  final unSelectedColor = Color(0xff000000);
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      elevation: 3,
      notchStyle: NotchStyle.square,
      items: [
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/home-icon.svg", index: 0),
          selectedColor: selectedColor,
          title: const Text('Home'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/books-icon.svg", index: 1),
          selectedColor: selectedColor,
          title: const Text('Books'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/members-icon.svg", index: 2),
          selectedColor: selectedColor,
          title: const Text('Members'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/transactions-icon.svg", index: 3),
          selectedColor: selectedColor,
          title: const Text('Transactions'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/settings-icon.svg", index: 4),
          selectedColor: selectedColor,
          title: const Text('Settings'),
        ),
      ],

      option: AnimatedBarOptions(
        iconSize: 32,
        barAnimation: BarAnimation.fade,
        iconStyle: IconStyle.simple,
        opacity: 0.3,
      ),
      currentIndex: selected,
      onTap: (index) {
        setState(() => selected = index);
      },
    );
  }

  Widget svgIcon({required String path, required index}) {
    return SvgPicture.asset(
      path,
      width: 24,
      height: 24,

      colorFilter: ColorFilter.mode(
        selected == index ? selectedColor : unSelectedColor,
        BlendMode.srcIn,
      ),
    );
  }
}

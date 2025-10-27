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
      items: [
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/home-icon.svg", index: 0),
          title: const Text('Home'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/books-icon.svg", index: 1),
          title: const Text('Books'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/members-icon.svg", index: 2),
          title: const Text('Members'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/transactions-icon.svg", index: 3),
          title: const Text('Transactions'),
        ),
        BottomBarItem(
          icon: svgIcon(path: "assets/icons/settings-icon.svg", index: 4),
          title: const Text('Settings'),
        ),
      ],
      option: DotBarOptions(
        dotStyle: DotStyle.circle,
        inkColor: MyColors.primaryButtonColor,
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
      colorFilter: ColorFilter.mode(
        selected == index ? selectedColor : unSelectedColor,
        BlendMode.srcIn,
      ),
    );
  }
}

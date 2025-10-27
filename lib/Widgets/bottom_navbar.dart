import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../Utilities/constants.dart';


StylishBottomBar bottomNavBar({
  required int selected,
  required int? Function(int? index)? method,
}) {
  final selectedColor = MyColors.primaryButtonColor;
  final unSelectedColor = Color(0xff000000);

  return StylishBottomBar(
    items: [
      BottomBarItem(
        icon: const Icon(Icons.home_outlined),
        title: const Text('Home'),
        unSelectedColor: unSelectedColor,
        selectedColor: selectedColor
      ),
      BottomBarItem(
        icon: const Icon(Icons.library_books_rounded),
        title: const Text('Books'),
        unSelectedColor: unSelectedColor,
        selectedColor: selectedColor
      ),
      BottomBarItem(
        icon: const Icon(Icons.groups_outlined),
        title: const Text('Members'),
        unSelectedColor: unSelectedColor,
        selectedColor: selectedColor
      ),
      BottomBarItem(
          icon: const Icon(Icons.currency_exchange_outlined),
          title: const Text('Abc'),
          unSelectedColor: unSelectedColor,
          selectedColor: selectedColor
      ),
      BottomBarItem(
          icon: const Icon(Icons.settings_outlined),
          title: const Text('Abc'),
          unSelectedColor: unSelectedColor,
          selectedColor: selectedColor
      ),
    ],
    option: DotBarOptions(
      dotStyle: DotStyle.circle,
      inkColor: MyColors.primaryButtonColor
    ),
    currentIndex: selected,
    onTap: method,
  );
}

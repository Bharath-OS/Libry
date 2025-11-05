import 'package:flutter/material.dart';
import 'package:libry/Screens/homeScreens/dart/profile.dart';
import 'package:libry/Widgets/scaffold.dart';

import '../Utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 10,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Good Morning, \nBharath OS\n",
                        style: TextStyle(
                          color: MyColors.whiteBG,
                          fontFamily: "Lobster",
                          fontSize: 26,
                        ),
                        children: [
                          TextSpan(
                            text: "Thursday 16, Oct 2025",
                            style: TextStyle(
                              color: MyColors.whiteBG,
                              fontFamily: "Livvic",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: SizedBox.expand(
                                child: detailsCard(
                                  count: 199,
                                  parameter: "Total Books",
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox.expand(
                                child: detailsCard(
                                  count: 23,
                                  parameter: "Total Members",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: SizedBox.expand(
                                child: detailsCard(
                                  count: 12,
                                  parameter: "Due Today",
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox.expand(
                                child: detailsCard(
                                  count: 12,
                                  parameter: "Over Due",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsCard({required int count, required String parameter}) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.whiteBG,
        borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "$count\n",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: "Livvic",
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: parameter,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

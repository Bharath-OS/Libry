import 'package:flutter/material.dart';

import '../../Widgets/appbar.dart';
import '../../widgets/scaffold.dart';

class BookHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: LibryAppBar.appBar(
        barTitle: 'Book Borrow History',
        context: context,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [_buildHeader()]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
      child: Text("Book History"),
    );
  }
}

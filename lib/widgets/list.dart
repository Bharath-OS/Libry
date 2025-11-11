import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libry/Models/books.dart';
import '../Models/members.dart';
import '../themes/styles.dart';
import '../Utilities/constants.dart';
import '../Widgets/buttons.dart';
import '../Widgets/scaffold.dart';

class ListScreen<T> extends StatelessWidget {
  final String title;
  final int totalCount;
  final int availableCount;
  final String searchHint;
  final List<T> items;
  final Widget Function(T item) tileBuilder;
  final void Function(T item)? onTap;

  const ListScreen({
    super.key,
    required this.title,
    required this.totalCount,
    required this.availableCount,
    required this.searchHint,
    required this.items,
    required this.tileBuilder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              _buildList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(MyColors.whiteBG),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset("assets/icons/search-line.svg"),
          ),
          hintText: searchHint,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total : $totalCount",
                  style: BodyTextStyles.headingSmallStyle(MyColors.whiteBG),
                ),
                Text(
                  "Available : $availableCount",
                  style: BodyTextStyles.bodySmallStyle(MyColors.whiteBG),
                ),
              ],
            ),
            MyButton.filterButton(method: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: MyColors.bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: ListView.separated(
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              return GestureDetector(
                onTap: () => onTap?.call(item),
                child: tileBuilder(item),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 4),
          ),
        ),
      ),
    );
  }
}


class MemberTile extends StatelessWidget {
  final Members memberDetails;

  const MemberTile({super.key, required this.memberDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(memberDetails.name, style: CardStyles.cardTitleStyle),
                  Text(memberDetails.memberId, style: CardStyles.cardSubTitleStyle),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [MyButton.deleteButton(method: () {})],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
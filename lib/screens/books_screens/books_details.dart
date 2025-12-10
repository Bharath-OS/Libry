import 'dart:io';
import 'package:flutter/material.dart';
import 'package:libry/provider/book_provider.dart';
import 'package:libry/screens/books_screens/edit_book_screen.dart';
import 'package:libry/utilities/helpers.dart';
import 'package:libry/widgets/buttons.dart';
import 'package:provider/provider.dart';
import '../../models/books_model.dart';
import '../../constants/app_colors.dart';
import '../../widgets/layout_widgets.dart';
import '../../themes/styles.dart';
import 'book_history.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  String selectedStatus = 'Available';
  final List<String> statusOptions = ['Available', 'Not Available'];
  late Books bookDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bookDetails = context.watch<BookProvider>().getBookById(widget.bookId)!;
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Books Details", context: context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 3,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildBookDetailsCard(),
                  _buildBookImage(),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: MyButton.deleteButton(
                      method: () => deleteBook(
                        context: context,
                        bookDetails: bookDetails,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Book Container
  Widget _buildBookDetailsCard() {
    final book = bookDetails;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 100, 30, 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: MyColors.whiteBG,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(book),
            const SizedBox(height: 10),
            _buildMetadataSection(book),
            const SizedBox(height: 10),
            _buildStatusDropdown(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  //Book Title
  Widget _buildTitleSection(Books book) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: book.title,
          style: BodyTextStyles.mainHeadingStyle.copyWith(height: 1.5),
          children: [
            TextSpan(
              text: "\nBy ${book.author}\n",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Livvic",
                color: MyColors.darkGrey,
              ),
            ),
            TextSpan(
              text: book.year,
              style: TextStyle(
                fontFamily: "Livvic",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MyColors.lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Book details
  Widget _buildMetadataSection(Books book) {
    return RichText(
      text: TextSpan(
        text: "Language : ${book.language}",
        style: const TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.8,
        ),
        children: [
          TextSpan(text: "\nPublisher : ${book.publisher}"),
          TextSpan(text: "\nGenre : ${book.genre}"),
          TextSpan(text: "\nPages : ${book.pages}"),
          TextSpan(text: "\nTotal copies : ${book.totalCopies}"),
          TextSpan(text: "\nTotal copies available : ${book.copiesAvailable}"),
        ],
      ),
    );
  }

  //Book availability dropdown button
  Widget _buildStatusDropdown() {
    return Container(
      color: selectedStatus == "Available"
          ? MyColors.successColor
          : MyColors.warningColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: selectedStatus,
        items: statusOptions.map((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedStatus = newValue!;
          });
        },
        underline: const SizedBox(),
      ),
    );
  }

  //Book action buttons
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyButton.secondaryButton(
          method: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookHistoryScreen()),
          ),
          text: "View History",
        ),
        const SizedBox(height: 10),
        MyButton.primaryButton(
          method: () {
            Navigator.push(
              context,
              transition(child: EditBookScreen(book: bookDetails)),
            );

            if (mounted) {
              context.read<BookProvider>().fetchBooks();
            }
          },
          text: "Edit Book",
        ),
      ],
    );
  }

  //Book cover image
  Widget _buildBookImage() {
    return Positioned(
      top: -90,
      left: 100,
      child: Container(
        width: 170,
        height: 180,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 7),
              blurRadius: 10,
              color: MyColors.lightGrey,
            ),
          ],
        ),
        // child: Image.asset("assets/images/dummy_book_cover.png"),
        child: Image.file(File(bookDetails.coverPicture),fit: BoxFit.cover,),
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../data/model/books_model.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../viewmodel/book_provider.dart';


class BookInfoScreenView extends StatefulWidget {
  final String bookId;

  const BookInfoScreenView({super.key, required this.bookId});

  @override
  State<BookInfoScreenView> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookInfoScreenView> {
  final Color infoIconColor = AppColors.primary;
  @override
  Widget build(BuildContext context) {
    final bookDetails = context.watch<BookViewModel>().getBookById(
      widget.bookId,
    );

    if (bookDetails == null) {
      return LayoutWidgets.customScaffold(
        appBar: LayoutWidgets.appBar(
          barTitle: "Book Details",
          context: context,
        ),
        body: Center(child: Text('Book not found')),
      );
    }

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Book Details", context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInformationSection(bookDetails),

              MyButton.buildDetailsActionButtons(context,bookDetails),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BookModel book) {
    final isAvailable = book.copiesAvailable > 0;
    const Color titleTextColor = Colors.black;
    final Color authorTextColor = AppColors.darkGrey;

    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          // Book Cover
          Container(
            height: 220,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildBookCover(book.coverPictureData),
            ),
          ),

          SizedBox(height: 20),

          // Title and Author
          Text(
            book.title,
            style: TextStyle(
              color: titleTextColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            'by ${book.author}',
            style: TextStyle(
              color: authorTextColor,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            book.year,
            style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
          ),

          SizedBox(height: 16),

          // Availability Tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAvailable ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  isAvailable
                      ? 'Available (${book.copiesAvailable}/${book.totalCopies})'
                      : 'Not Available',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Divider(height: 32,)
        ],
      ),
    );
  }

  Widget _buildInformationSection(BookModel book) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(book),
          Text(
            'Book Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          _buildInfoRow(Icons.language, 'Language', book.language),
          _buildInfoRow(Icons.business, 'Publisher', book.publisher),
          _buildInfoRow(Icons.category, 'Genre', book.genre),
          _buildInfoRow(Icons.book, 'Pages', '${book.pages}'),

          Divider(height: 32),

          Text(
            'Availability',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Total Copies',
                  book.totalCopies.toString(),
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  'Available',
                  book.copiesAvailable.toString(),
                  book.copiesAvailable > 0 ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  'Borrowed',
                  '${book.totalCopies - book.copiesAvailable}',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: infoIconColor, size: 20),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1*255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((0.3*255).toInt())),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover(Uint8List? coverPictureData) {
    if (coverPictureData != null && coverPictureData.isNotEmpty) {
      return Image.memory(
        coverPictureData,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderCover();
        },
      );
    }
    return _buildPlaceholderCover();
  }

  Widget _buildPlaceholderCover() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 60, color: AppColors.darkGrey),
          SizedBox(height: 8),
          Text('No Cover', style: TextStyle(color: AppColors.darkGrey)),
        ],
      ),
    );
  }
}

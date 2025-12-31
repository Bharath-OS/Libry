import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libry/core/utilities/helpers/date_formater.dart';
import 'package:libry/features/settings/viewmodel/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/styles.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/glassmorphism.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../../books/data/model/books_model.dart';
import '../../books/viewmodel/book_provider.dart';
import '../../members/data/model/members_model.dart';
import '../../members/viewmodel/members_provider.dart';
import '../viewmodel/issue_provider.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _memberFieldController = TextEditingController();
  final _bookFieldController = TextEditingController();

  MemberModel? _selectedMember;
  BookModel? _selectedBook;
  late DateTime _dueDate;

  bool _isMemberVerified = false;
  bool _isBookSelected = false;
  bool _isProcessing = false;

  List<MemberModel> _filteredMembers = [];
  List<BookModel> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final memberProvider = context.read<MembersProvider>();
    final bookProvider = context.read<BookViewModel>();
    _dueDate = DateTime.now().add(Duration(days: context.read<SettingsViewModel>().issuePeriod));

    _filteredMembers = memberProvider.members;
    _filteredBooks = bookProvider.books
        .where((book) => book.copiesAvailable > 0)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Issue Book", context: context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: GlassMorphism(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        "Issue Book to Member",
                        textAlign: TextAlign.center,
                        style: CardStyles.cardTitleStyle.copyWith(
                          color: AppColors.background,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Search and select member and book",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.background.withAlpha((0.8 * 255).toInt()),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Member Search Section
                      _buildMemberSection(),

                      const SizedBox(height: 24),

                      // Book Search Section (only if member verified)
                      if (_isMemberVerified) _buildBookSection(),

                      const SizedBox(height: 24),

                      // Due Date Section (only if book selected)
                      if (_isBookSelected) _buildDueDateSection(),

                      const SizedBox(height: 32),

                      // Issue Button
                      if (_isBookSelected)
                        MyButton.primaryButton(
                          method: _isProcessing ? () {} : _processIssue,
                          text: _isProcessing ? "Processing..." : "Issue Book",
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "1. Select Member",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField.customIssueTextField(
          inputController: _memberFieldController,
          label: "Search by name or member ID",
          prefixIcon: Icons.person_search,
          flagVariable: _isMemberVerified,
          onPressed: _searchMembers,
          onChanged: (value) => _filterMembers(value),
          onFieldSubmitted: (_) => _searchMembers(),
        ),

        // Member Suggestions Dropdown
        if (_memberFieldController.text.isNotEmpty && !_isMemberVerified)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                final member = _filteredMembers[index];
                return ListTile(
                  // Leading if needed an avatar.
                  title: Text(
                    member.name,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text("ID: ${member.memberId}"),
                  trailing: Text(
                    "Borrowed: ${member.currentlyBorrow}/5",
                    style: TextStyle(
                      color: member.currentlyBorrow >= 5
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _selectMember(member),
                );
              },
            ),
          ),

        // Selected Member Card
        if (_isMemberVerified && _selectedMember != null)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withAlpha((0.1 * 255).toInt())),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.success,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMember!.name,
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "ID: ${_selectedMember!.memberId} • Borrowed: ${_selectedMember!.currentlyBorrow}/5",
                        style: TextStyle(
                          color: AppColors.background.withAlpha((0.7 * 255).toInt()),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: _clearMemberSelection,
                  tooltip: 'Change member',
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBookSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "2. Select Book",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField.customIssueTextField(
          inputController: _bookFieldController,
          label: "Search by title or author",
          prefixIcon: Icons.book,
          flagVariable: _isBookSelected,
          onPressed: _searchBooks,
          onChanged: (value) => _filterBooks(value),
          onFieldSubmitted: (_) => _searchBooks(),
        ),

        // Book Suggestions Dropdown
        if (_bookFieldController.text.isNotEmpty && !_isBookSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredBooks.length,
              itemBuilder: (context, index) {
                final book = _filteredBooks[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      // color: AppColors.background.withAlpha((0.1 * 255).toInt()),
                      color: AppColors.background,
                    ),
                    child:
                        book.coverPicture.isNotEmpty &&
                            File(book.coverPicture).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(
                              File(book.coverPicture),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.book, color: AppColors.background),
                  ),
                  title: Text(
                    book.title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.author,
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Available: ${book.copiesAvailable}/${book.totalCopies}",
                        style: TextStyle(
                          fontSize: 11,
                          color: book.copiesAvailable > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: book.copiesAvailable > 0
                      ? Icon(Icons.arrow_forward_ios, size: 16)
                      : Chip(
                          label: Text("Out of Stock"),
                          backgroundColor: Colors.red[50],
                          labelStyle: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                  onTap: book.copiesAvailable > 0
                      ? () => _selectBook(book)
                      : null,
                );
              },
            ),
          ),

        // Selected Book Card
        if (_isBookSelected && _selectedBook != null)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withAlpha((0.1 * 255).toInt())),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.background.withAlpha((0.1 * 255).toInt()),
                  ),
                  child: _selectedBook!.coverPicture.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(_selectedBook!.coverPicture),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.book, color: AppColors.background, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedBook!.title,
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "by ${_selectedBook!.author}",
                        style: TextStyle(
                          color: AppColors.background.withAlpha((0.7 * 255).toInt()),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Available: ${_selectedBook!.copiesAvailable}/${_selectedBook!.totalCopies}",
                        style: TextStyle(
                          color: _selectedBook!.copiesAvailable > 0
                              ? Colors.green
                              : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: _clearBookSelection,
                  tooltip: 'Change book',
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "3. Set Due Date",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDueDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.background.withAlpha((0.1 * 255).toInt())),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.background),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Due Date",
                        style: TextStyle(
                          color: AppColors.background.withAlpha((0.7 * 255).toInt()),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.background),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Book must be returned by this date to avoid fines",
          style: TextStyle(
            color: AppColors.background.withAlpha((0.6 * 255).toInt()),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _filterMembers(String query) {
    final members = context.read<MembersProvider>().members;

    if (query.isEmpty) {
      setState(() => _filteredMembers = members);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredMembers = members.where((member) {
        return member.name.toLowerCase().contains(lowercaseQuery) ||
            member.memberId!.toLowerCase().contains(lowercaseQuery) ||
            member.phone.contains(query) ||
            member.email.toLowerCase().contains(lowercaseQuery);
      }).toList();
    });
  }

  void _filterBooks(String query) {
    final books = context.read<BookViewModel>().books;
    final availableBooks = books
        .where((book) => book.copiesAvailable > 0)
        .toList();

    if (query.isEmpty) {
      setState(() => _filteredBooks = availableBooks);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredBooks = availableBooks.where((book) {
        return book.title.toLowerCase().contains(lowercaseQuery) ||
            book.author.toLowerCase().contains(lowercaseQuery) ||
            book.genre.toLowerCase().contains(lowercaseQuery) ||
            book.publisher.toLowerCase().contains(lowercaseQuery);
      }).toList();
    });
  }

  void _searchMembers() {
    if (_memberFieldController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter member name or ID")));
      return;
    }

    // If only one member matches, select it automatically
    if (_filteredMembers.length == 1) {
      _selectMember(_filteredMembers.first);
    }
  }

  void _searchBooks() {
    if (_bookFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter book title or author")),
      );
      return;
    }

    // If only one book matches, select it automatically
    if (_filteredBooks.length == 1) {
      _selectBook(_filteredBooks.first);
    }
  }

  void _selectMember(MemberModel member) {
    setState(() {
      _selectedMember = member;
      _isMemberVerified = true;
      _memberFieldController.text = "${member.name} (${member.memberId})";
      _memberFieldController.selection = TextSelection.collapsed(
        offset: _memberFieldController.text.length,
      );
    });

    // Check if member can borrow more books
    if (member.currentlyBorrow >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This member has reached the borrow limit (5 books)"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _selectBook(BookModel book) {
    setState(() {
      _selectedBook = book;
      _isBookSelected = true;
      _bookFieldController.text = "${book.title} by ${book.author}";
      _bookFieldController.selection = TextSelection.collapsed(
        offset: _bookFieldController.text.length,
      );
    });
  }

  void _clearMemberSelection() {
    setState(() {
      _selectedMember = null;
      _isMemberVerified = false;
      _memberFieldController.clear();
      _filteredMembers = context.read<MembersProvider>().members;
    });
  }

  void _clearBookSelection() {
    setState(() {
      _selectedBook = null;
      _isBookSelected = false;
      _bookFieldController.clear();
      _filteredBooks = context
          .read<BookViewModel>()
          .books
          .where((book) => book.copiesAvailable > 0)
          .toList();
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.background,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() => _dueDate = selectedDate);
    }
  }

  Future<void> _processIssue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMember == null || _selectedBook == null) return;

    // Validation checks
    if (_selectedMember!.currentlyBorrow >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Member has reached borrow limit (5 books)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedBook!.copiesAvailable <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Book is not available"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final issueProvider = context.read<IssueProvider>();
      final bookProvider = context.read<BookViewModel>();
      final memberProvider = context.read<MembersProvider>();

      // 1. Create issue record in Hive
      final issueId = await issueProvider.borrowBook(
        bookId: _selectedBook!.id!,
        memberId: _selectedMember!.id!,
        dueDate: _dueDate,
        memberName: _selectedMember!.name,
        bookName: _selectedBook!.title,
      );

      // 2. Update book in SQLite
      final updatedBook = BookModel(
        id: _selectedBook!.id,
        title: _selectedBook!.title,
        author: _selectedBook!.author,
        year: _selectedBook!.year,
        language: _selectedBook!.language,
        publisher: _selectedBook!.publisher,
        genre: _selectedBook!.genre,
        pages: _selectedBook!.pages,
        totalCopies: _selectedBook!.totalCopies,
        copiesAvailable: _selectedBook!.copiesAvailable - 1,
        coverPicture: _selectedBook!.coverPicture,
      );
      await bookProvider.updateBook(updatedBook);

      // 3. Update member in SQLite
      final updatedMember = MemberModel(
        id: _selectedMember!.id,
        memberId: _selectedMember!.memberId,
        name: _selectedMember!.name,
        email: _selectedMember!.email,
        phone: _selectedMember!.phone,
        address: _selectedMember!.address,
        fine: _selectedMember!.fine,
        totalBorrow: _selectedMember!.totalBorrow + 1,
        currentlyBorrow: _selectedMember!.currentlyBorrow + 1,
        joined: _selectedMember!.joined,
        expiry: _selectedMember!.expiry,
      );
      await memberProvider.updateMember(updatedMember);

      // Show success dialog
      await _showSuccessDialog(issueId);

      // Reset form
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _showSuccessDialog(String issueId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 60),
            const SizedBox(width: 8),
            Text("Success!", style: TextStyle(color: AppColors.darkGrey,fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Book issued successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightGrey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Issue ID: $issueId",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Text(
                    "Member: ${_selectedMember!.name}",
                    style: TextStyle(color: AppColors.darkGrey),
                  ),
                  Text(
                    "Book: ${_selectedBook!.title}",
                    style: TextStyle(color: AppColors.darkGrey),
                  ),
                  Text(
                    "Due Date: ${dateFormat(date: _dueDate)}",
                    style: TextStyle(color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          MyButton.primaryButton(
            method: () => Navigator.pop(context),
            text: "Done",
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedMember = null;
      _selectedBook = null;
      _isMemberVerified = false;
      _isBookSelected = false;
      _isProcessing = false;
      _dueDate = DateTime.now().add(Duration(days: 14));
      _memberFieldController.clear();
      _bookFieldController.clear();
      _filteredMembers = context.read<MembersProvider>().members;
      _filteredBooks = context
          .read<BookViewModel>()
          .books
          .where((book) => book.copiesAvailable > 0)
          .toList();
    });
  }

  @override
  void dispose() {
    _memberFieldController.dispose();
    _bookFieldController.dispose();
    super.dispose();
  }
}

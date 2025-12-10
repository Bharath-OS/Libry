import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libry/utilities/image_services.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../themes/styles.dart';
import '../../models/books_model.dart';
import '../../models/members_model.dart';
import '../../provider/book_provider.dart';
import '../../provider/members_provider.dart';
import '../../provider/issue_provider.dart';
import '../../utilities/validation.dart';
import '../../widgets/buttons.dart';
import '../../widgets/layout_widgets.dart';
import '../../widgets/glassmorphism.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _memberFieldController = TextEditingController();
  final _bookFieldController = TextEditingController();

  Members? _selectedMember;
  Books? _selectedBook;
  //initially starts with 14days
  DateTime _dueDate = DateTime.now().add(Duration(days: 14));

  bool _isMemberVerified = false;
  bool _isBookSelected = false;
  bool _isProcessing = false;

  List<Members> _filteredMembers = [];
  List<Books> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final memberProvider = context.read<MembersProvider>();
    final bookProvider = context.read<BookProvider>();

    _filteredMembers = memberProvider.members;
    _filteredBooks = bookProvider.books.where((book) => book.copiesAvailable > 0).toList();
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
                          color: MyColors.bgColor,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Search and select member and book",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.bgColor.withOpacity(0.8),
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
                          method: _isProcessing ? (){} : _processIssue,
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
            color: MyColors.bgColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _memberFieldController,
          decoration: InputDecoration(
            hintText: "Search by name or member ID",
            prefixIcon: Icon(Icons.person_search, color: MyColors.bgColor),
            suffixIcon: _isMemberVerified
                ? Icon(Icons.verified, color: MyColors.successColor)
                : IconButton(
              icon: Icon(Icons.search, color: MyColors.bgColor),
              onPressed: _searchMembers,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MyColors.bgColor.withOpacity(0.3)),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
          style: TextStyle(color: MyColors.bgColor),
          onChanged: (value) => _filterMembers(value),
          onFieldSubmitted: (_) => _searchMembers(),
          validator: (value) => Validator.emptyValidator(value),
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
              color: MyColors.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyColors.successColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.successColor,
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
                          color: MyColors.bgColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "ID: ${_selectedMember!.memberId} • Borrowed: ${_selectedMember!.currentlyBorrow}/5",
                        style: TextStyle(
                          color: MyColors.bgColor.withOpacity(0.7),
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
            color: MyColors.bgColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _bookFieldController,
          decoration: InputDecoration(
            hintText: "Search by title or author",
            prefixIcon: Icon(Icons.book, color: MyColors.bgColor),
            suffixIcon: _isBookSelected
                ? Icon(Icons.check, color: MyColors.successColor)
                : IconButton(
              icon: Icon(Icons.search, color: MyColors.bgColor),
              onPressed: _searchBooks,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: MyColors.bgColor.withOpacity(0.3)),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
          style: TextStyle(color: MyColors.bgColor),
          onChanged: (value) => _filterBooks(value),
          onFieldSubmitted: (_) => _searchBooks(),
          validator: (value) => Validator.emptyValidator(value),
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
                      // color: MyColors.bgColor.withOpacity(0.1),
                      color: MyColors.bgColor
                    ),
                    child: book.coverPicture.isNotEmpty && File(book.coverPicture).existsSync()
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(book.coverPicture),
                        fit: BoxFit.cover,
                      ),
                    )
                        : Icon(Icons.book, color: MyColors.bgColor),
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
                    labelStyle: TextStyle(fontSize: 10, color: Colors.red),
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
              color: MyColors.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyColors.successColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: MyColors.bgColor.withOpacity(0.1),
                  ),
                  child: _selectedBook!.coverPicture.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      File(_selectedBook!.coverPicture),
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(Icons.book, color: MyColors.bgColor, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedBook!.title,
                        style: TextStyle(
                          color: MyColors.bgColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "by ${_selectedBook!.author}",
                        style: TextStyle(
                          color: MyColors.bgColor.withOpacity(0.7),
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
            color: MyColors.bgColor,
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
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyColors.bgColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: MyColors.bgColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Due Date",
                        style: TextStyle(
                          color: MyColors.bgColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}",
                        style: TextStyle(
                          color: MyColors.bgColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: MyColors.bgColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Book must be returned by this date to avoid fines",
          style: TextStyle(
            color: MyColors.bgColor.withOpacity(0.6),
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
    final books = context.read<BookProvider>().books;
    final availableBooks = books.where((book) => book.copiesAvailable > 0).toList();

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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter member name or ID"))
      );
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
          SnackBar(content: Text("Please enter book title or author"))
      );
      return;
    }

    // If only one book matches, select it automatically
    if (_filteredBooks.length == 1) {
      _selectBook(_filteredBooks.first);
    }
  }

  void _selectMember(Members member) {
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
          )
      );
    }
  }

  void _selectBook(Books book) {
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
      _filteredBooks = context.read<BookProvider>().books
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
              primary: MyColors.bgColor,
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
          )
      );
      return;
    }

    if (_selectedBook!.copiesAvailable <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Book is not available"),
            backgroundColor: Colors.red,
          )
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final issueProvider = context.read<IssueProvider>();
      final bookProvider = context.read<BookProvider>();
      final memberProvider = context.read<MembersProvider>();

      // 1. Create issue record in Hive
      final issueId = await issueProvider.borrowBook(
        bookId: _selectedBook!.id!,
        memberId: _selectedMember!.id!,
        dueDate: _dueDate,
      );

      // 2. Update book in SQLite
      final updatedBook = Books(
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
      final updatedMember = Members(
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
          )
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
        title: Row(
          children: [
            Icon(Icons.check_circle, color: MyColors.successColor),
            const SizedBox(width: 8),
            Text("Success!", style: TextStyle(color: MyColors.successColor)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Book issued successfully!"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.bgColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Issue ID: $issueId", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Member: ${_selectedMember!.name}"),
                  Text("Book: ${_selectedBook!.title}"),
                  Text("Due Date: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}"),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
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
      _filteredBooks = context.read<BookProvider>().books
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
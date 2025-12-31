import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:libry/features/issues/viewmodel/issue_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PdfExportService {
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  /// Initialize fonts with Unicode support
  static Future<void> _initializeFonts() async {
    if (_regularFont == null || _boldFont == null) {
      _regularFont = await PdfGoogleFonts.robotoRegular();
      _boldFont = await PdfGoogleFonts.robotoBold();
    }
  }

  /// Export books to PDF
  static Future<void> exportBooksToPdf(List<dynamic> books) async {
    // Initialize fonts first
    await _initializeFonts();

    final pdf = pw.Document();

    // Create table data
    final headers = [
      'ID',
      'Title',
      'Author',
      'Publisher',
      'Year',
      'Genre',
      'Pages',
      'Total',
      'Available',
    ];

    final data = books.map((book) {
      return [
        (book.id ?? '').toString(),
        _truncateText(book.title, 20),
        _truncateText(book.author, 15),
        _truncateText(book.publisher, 15),
        book.year,
        _truncateText(book.genre, 12),
        book.pages.toString(),
        book.totalCopies.toString(),
        book.copiesAvailable.toString(),
      ];
    }).toList();

    // Add pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: _regularFont!, bold: _boldFont!),
        build: (context) => [
          // Title
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'BookModel Export Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: _boldFont,
                  ),
                ),
                pw.Text(
                  'Generated: ${_formatDateTime(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10, font: _regularFont),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Summary
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total BookModel', books.length.toString()),
                _buildSummaryItem(
                  'Available',
                  books.where((b) => b.copiesAvailable > 0).length.toString(),
                ),
                _buildSummaryItem(
                  'Unavailable',
                  books.where((b) => b.copiesAvailable == 0).length.toString(),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Table
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: data,
            border: pw.TableBorder.all(color: PdfColors.grey400),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
              font: _boldFont,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: pw.TextStyle(fontSize: 8, font: _regularFont),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.center,
              5: pw.Alignment.centerLeft,
              6: pw.Alignment.center,
              7: pw.Alignment.center,
              8: pw.Alignment.center,
            },
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, font: _regularFont),
          ),
        ),
      ),
    );

    // Save or share PDF
    await _savePdf(pdf, 'books_export');
  }

  /// Export members to PDF
  static Future<void> exportMembersToPdf(List<dynamic> members) async {
    // Initialize fonts first
    await _initializeFonts();

    final pdf = pw.Document();

    // Create table data
    final headers = [
      'Member ID',
      'Name',
      'Email',
      'Phone',
      'Address',
      'Total\nBorrow',
      'Currently\nBorrow',
      'Fine',
      'Joined',
      'Expiry',
    ];

    final data = members.map((member) {
      return [
        member.memberId ?? '',
        _truncateText(member.name, 15),
        _truncateText(member.email, 20),
        member.phone,
        _truncateText(member.address, 15),
        member.totalBorrow.toString(),
        member.currentlyBorrow.toString(),
        'Rs ${member.fine.toStringAsFixed(0)}', // Changed to show no decimals for currency
        _formatDate(member.joined),
        _formatDate(member.expiry),
      ];
    }).toList();

    // Add pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: _regularFont!, bold: _boldFont!),
        build: (context) => [
          // Title
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'MemberModel Export Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: _boldFont,
                  ),
                ),
                pw.Text(
                  'Generated: ${_formatDateTime(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10, font: _regularFont),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Summary
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total MemberModel', members.length.toString()),
                _buildSummaryItem(
                  'Active',
                  members
                      .where((m) => m.expiry.isAfter(DateTime.now()))
                      .length
                      .toString(),
                ),
                _buildSummaryItem(
                  'Expired',
                  members
                      .where((m) => m.expiry.isBefore(DateTime.now()))
                      .length
                      .toString(),
                ),
                _buildSummaryItem(
                  'With Fines',
                  members.where((m) => m.fine > 0).length.toString(),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Table
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: data,
            border: pw.TableBorder.all(color: PdfColors.grey400),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
              font: _boldFont,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
            cellHeight: 35,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerLeft,
              5: pw.Alignment.center,
              6: pw.Alignment.center,
              7: pw.Alignment.center,
              8: pw.Alignment.center,
              9: pw.Alignment.center,
            },
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, font: _regularFont),
          ),
        ),
      ),
    );

    // Save or share PDF
    await _savePdf(pdf, 'members_export');
  }

  /// Build summary item widget
  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: _boldFont,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(label, style: pw.TextStyle(fontSize: 10, font: _regularFont)),
      ],
    );
  }

  /// Save PDF to device and open share dialog
  static Future<void> _savePdf(pw.Document pdf, String filename) async {
    try {
      final bytes = await pdf.save();

      // Save to temporary directory first
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${filename}_${_formatFilename(DateTime.now())}.pdf',
      );
      await file.writeAsBytes(bytes);

      // Share the PDF
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${filename}_${_formatFilename(DateTime.now())}.pdf',
      );
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      rethrow;
    }
  }

  static Future<bool> _savePdfToDevice({
    required String filename,
    required pw.Document pdf,
  }) async {
    final root = await getExternalStorageDirectory();
    final file = File('${root!.path}/$filename');
    try {
      await file.writeAsBytes(await pdf.save());
      return true;
    } catch (e) {
      debugPrint('Exception e: $e');
      return false;
    }
  }

  /// Truncate text to fit in table cells
  static String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Format date for display
  static String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date-time for header
  static String _formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Format filename with timestamp
  static String _formatFilename(DateTime date) {
    return DateFormat('yyyyMMdd_HHmmss').format(date);
  }

  static Future<void> exportIssuesPdf(List<dynamic> issues) async {
    await _initializeFonts();

    final pdf = pw.Document();

    final headers = [
      'ID',
      'Name of Book',
      'Name of Member',
      'Issue Date',
      'Due Date',
      'Returned Date',
    ];

    final data = issues.map((issue) {
      return [
        (issue.issueId ?? '').toString(),
        _truncateText(issue.bookName, 20),
        _truncateText(issue.memberName, 20),
        issue.issueDate.toString(),
        issue.dueDate.toString(),
        issue.returnDate.toString(),
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: _regularFont!, bold: _boldFont!),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Issue Records',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: _boldFont,
                  ),
                ),
                pw.Text(
                  'Generated: ${_formatDateTime(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10, font: _regularFont),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Issues made',
                  issues.length.toString(),
                ),
                _buildSummaryItem(
                  'Active',
                  Provider.of<IssueViewModel>(
                    context as BuildContext,
                  ).activeCount.toString(),
                ),
                _buildSummaryItem(
                  'Returned',
                  Provider.of<IssueViewModel>(
                    context as BuildContext,
                  ).returnedCount.toString(),
                ),
                _buildSummaryItem(
                  'Due Today',
                  Provider.of<IssueViewModel>(
                    context as BuildContext,
                  ).issuedTodayCount.toString(),
                ),
                _buildSummaryItem(
                  'Over Due',
                  Provider.of<IssueViewModel>(
                    context as BuildContext,
                  ).overDueCount.toString(),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          pw.TableHelper.fromTextArray(
            headers: headers,
            data: data,
            border: pw.TableBorder.all(color: PdfColors.grey400),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
              font: _boldFont,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: pw.TextStyle(fontSize: 8, font: _regularFont),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
            },
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, font: _regularFont),
          ),
        ),
      ),
    );

    await _savePdfToDevice(
      pdf: pdf,
      filename: 'issue_records${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

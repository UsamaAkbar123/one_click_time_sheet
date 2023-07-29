import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:open_document/open_document.dart';
import 'package:open_document/open_document_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfServices {
  /// example
  Future<Uint8List> createHelloWorld(List<JobHistoryModel> jobList) async {
    final pdf = pw.Document();
    final font =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf"));
    //final font = pw.Font.ttf(ttFont);

    pdf.addPage(pw.MultiPage(
      build: (context) {
        return [
          buildTitle('July 2023', font),
          pw.SizedBox(height: 20),
          buildReportTable(jobList),
        ];
      },
    ));

    return pdf.save();
  }

  /// build report table
  static pw.Widget buildReportTable(List<JobHistoryModel> jobList) {
    final headers = [
      '',
      'Start',
      'End',
      'Difference',
      'Considered',
    ];
    // ignore: deprecated_member_use
    return pw.Table.fromTextArray(
      headers: headers,
      data: [],
    );
  }

  /// build title
  static pw.Widget buildTitle(String tittle, Font font) {
    return pw.Text(
      tittle,
      style: pw.TextStyle(
        font: font,
        fontSize: 20,
      ),
    );
  }

  Future<void> savePdfFile(String filename, Uint8List byteList) async {
    final output = await getExternalStorageDirectory();
    var filePath = "${output?.path}/$filename.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    try {
      await OpenDocument.openDocument(filePath: filePath);
    } on OpenDocumentException catch (e) {
      // debugPrint("ERROR: ${e.errorMessage}");
      filePath = 'Failed to get platform version.';
    }
  }
}

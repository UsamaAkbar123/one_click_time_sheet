import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:open_document/open_document_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfServices {
  /// example
  Future<Uint8List> createHelloWorld() async {
    final pdf = pw.Document();
    final font =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf"));
    //final font = pw.Font.ttf(ttFont);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Hello world',
              style: pw.TextStyle(
                font: font,
                fontSize: 40,
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> savePdfFile(String filename, Uint8List byteList) async {
    final output = await getExternalStorageDirectory();
    var filePath = "${output?.path}/$filename.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    try {
      await OpenDocument.openDocument(filePath: filePath);
    } on OpenDocumentException catch (e) {
      debugPrint("ERROR: ${e.errorMessage}");
      filePath = 'Failed to get platform version.';
    }
  }
}

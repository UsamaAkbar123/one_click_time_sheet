import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:open_document/open_document_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../../../model/report_model.dart';

class PdfServices {
  /// example
  Future<Uint8List> createMonthlyReport({
    required List<FinalReportModel> reportList,
    required List<ReportSumModel> sumList,
  }) async {
    final pdf = pw.Document();
    final font =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf"));
    //final font = pw.Font.ttf(ttFont);

    pdf.addPage(pw.MultiPage(
      build: (context) {
        return [
          buildTitle('Monthly Report', font),
          pw.SizedBox(height: 20),
          for (int i = 0; i < reportList.length; i++)
            buildReportTable(i, reportList[i], sumList[i]),
          // for (int i = 0; i < sumList.length; i++) buildSumWidget(sumList[i]),
        ];
      },
    ));

    return pdf.save();
  }

  String jobId = '';

  /// build report table
  pw.Widget buildReportTable(
    int iIndex,
    FinalReportModel finalReport,
    ReportSumModel reportSumModel,
  ) {
    if (iIndex == 0 || jobId != finalReport.id) {
      jobId = finalReport.id;
    } else {
      jobId = '';
    }

    final headers = [
      ' ',
      'Start',
      'End',
      'Difference',
      'Considered',
    ];

    final data = finalReport.reportModelList.map((e) {
      return [
        e.jobTitle,
        e.startTime,
        e.endTime,
        e.difference,
        e.considered,
      ];
    }).toList();

    return pw.Padding(
      padding: const EdgeInsets.all(10),
      child: pw.Column(
        children: [
          // if (iIndex == 0) pw.Text(finalReport.id),
          jobId == finalReport.id
              ? pw.Align(
                  alignment: Alignment.centerLeft,
                  child: pw.Text(
                    jobId,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : pw.SizedBox(),
          pw.SizedBox(height: 8),
          // ignore: deprecated_member_use
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
          ),
          pw.SizedBox(height: 5),
          buildSumWidget(reportSumModel),
        ],
      ),
    );
  }

  /// build sum widget
  static pw.Widget buildSumWidget(ReportSumModel reportSumModel) {
    return pw.Row(children: [
      pw.Text(
        'Sum',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      pw.Spacer(),
      pw.Text(
        reportSumModel.sum,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ]);
  }

  /// build title
  static pw.Widget buildTitle(String tittle, Font font) {
    return pw.Center(
      child: pw.Text(
        tittle,
        style: pw.TextStyle(
          font: font,
          fontSize: 20,
        ),
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
      flutter.debugPrint("ERROR: ${e.errorMessage}");
      filePath = 'Failed to get platform version.';
    }
  }
}

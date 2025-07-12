import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<String> createBlankA4Pdf() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Container(color: PdfColors.white),
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/blank_a4.pdf');
  await file.writeAsBytes(await pdf.save());
  return file.path;
}

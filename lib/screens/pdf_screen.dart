import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfEditorWidget extends StatefulWidget {
  const PdfEditorWidget({super.key});

  @override
  _PdfEditorWidgetState createState() => _PdfEditorWidgetState();
}

class _PdfEditorWidgetState extends State<PdfEditorWidget> {
  String? pdfPath;
  int currentPage = 1;
  late PdfViewerController pdfController;

  @override
  void initState() {
    super.initState();
    pdfController = PdfViewerController();
    _initPdf();
  }

  Future<void> _initPdf() async {
    final path = await createTwoPageBlankPdf();
    setState(() {
      pdfPath = path;
    });
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    setState(() {
      currentPage = details.newPageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (pdfPath == null)
                      const Center(child: CircularProgressIndicator())
                    else
                      Positioned.fill(
                        child: SfPdfViewer.file(
                          File(pdfPath!),
                          controller: pdfController,
                          onPageChanged: _onPageChanged,
                          pageLayoutMode: PdfPageLayoutMode.single,
                          scrollDirection: PdfScrollDirection.horizontal,
                        ),
                      ),

                    // Left side page flip button
                    Positioned(
                      left: 0,
                      top: MediaQuery.of(context).size.height / 2 - 25 - 16,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(16),
                          ),
                          onTap: () {
                            if (currentPage > 1) {
                              pdfController.jumpToPage(currentPage - 1);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(16),
                              ),
                            ),
                            child:
                                const Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // Right side page flip button
                    Positioned(
                      right: 0,
                      top: MediaQuery.of(context).size.height / 2 - 25 - 16,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                          ),
                          onTap: () {
                            pdfController.jumpToPage(currentPage + 1);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                            ),
                            child:
                                const Icon(Icons.arrow_forward_ios, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Bottom Cancel / Save buttons styled exactly like your LiftPlanScreen
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement your Save logic here or navigate as needed
                        // Example: Navigator.push to next screen
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> createTwoPageBlankPdf() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Container(color: PdfColors.white),
    ),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Container(color: PdfColors.white),
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/blank_two_page_a4.pdf');
  await file.writeAsBytes(await pdf.save());
  return file.path;
}

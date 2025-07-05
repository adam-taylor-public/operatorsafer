import 'package:flutter/material.dart';

class FileFormatScreen extends StatefulWidget {
  const FileFormatScreen({super.key});

  @override
  State<FileFormatScreen> createState() => _FileFormatScreenState();
}

class _FileFormatScreenState extends State<FileFormatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('File Preview')),
    body: Container(
      // to display the pdf created from details
    ),);
  }
}

import 'package:flutter/material.dart';
import 'package:pdf_viewer/ekran_mesove_pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'מציג PDF',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const EkranRashi(),
    );
  }
}

class EkranRashi extends StatelessWidget {
  const EkranRashi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('מציג PDF'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EkranMesovePDF(
                      kovetzPDF: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                      kotert: 'דוגמא PDF',
                    ),
                  ),
                );
              },
              child: const Text('פתח קובץ PDF לדוגמא'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // כאן תוכל להוסיף אפשרות לבחירת קובץ מהמכשיר
                // או הזנת כתובת ידנית
              },
              child: const Text('בחר קובץ PDF מהמכשיר'),
            ),
          ],
        ),
      ),
    );
  }
}

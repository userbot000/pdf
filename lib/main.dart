import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'ekran_mesove_pdf.dart';

class EkranRashi extends StatelessWidget {
  const EkranRashi({super.key});

  // פונקציה לטעינת קובץ PDF
  Future<void> _pickAndOpenPdf(BuildContext context) async {
    try {
      // פתיחת חלון בחירת קבצים
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      // בדיקה אם נבחר קובץ
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        
        if (!mounted) return;
        
        // מעבר למסך הצגת ה-PDF
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EkranMesovePDF(
              kovetzPDF: filePath,
              kotert: 'הקובץ שלי',
            ),
          ),
        );
      }
    } catch (e) {
      // טיפול בשגיאות
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה בפתיחת הקובץ: $e')),
      );
    }
  }

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
              onPressed: () => _pickAndOpenPdf(context),
              child: const Text('בחר קובץ PDF מהמכשיר'),
            ),
          ],
        ),
      ),
    );
  }
}
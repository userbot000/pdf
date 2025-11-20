# מציג PDF בפלאטר

אפליקציה להצגת קבצי PDF בתוך אפליקציות Flutter באמצעות WebView.

## דרישות מערכת

- Flutter SDK >=3.0.0
- Dart SDK >=2.17.0
- Android Studio / VS Code עם הרחבות Flutter

## התקנה

1. שכפל את הריפוזיטורי:
   ```bash
   git clone https://github.com/yourusername/pdf_viewer_flutter.git
   cd pdf_viewer_flutter
   ```

2. התקן את התלויות:
   ```bash
   flutter pub get
   ```

3. הרץ את האפליקציה:
   ```bash
   flutter run
   ```

## שימוש

```dart
import 'package:pdf_viewer/ekran_mesove_pdf.dart';

// בתוך ה-widget שלך:
EkranMesovePDF(
  kovetzPDF: 'https://example.com/your-file.pdf',
  kotert: 'כותרת המסמך',
  meniLiftoachBeMatsaveChitzoni: true,
)
```

## הרצה לבדיקות

```bash
# הרץ בדיקות
flutter test

# בדוק את איכות הקוד
flutter analyze

# הרץ בדיקות עם כיסוי קוד
flutter test --coverage
```

## בנייה

### לאנדרואיד
```bash
flutter build apk --release
# או
flutter build appbundle --release
```

### ל-iOS
```bash
flutter build ipa --export-options-plist=ios/exportOptions.plist
```

## רישיון

MIT

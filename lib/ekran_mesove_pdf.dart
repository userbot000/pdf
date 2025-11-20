import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// Add this for WebView widget
export 'package:webview_flutter/webview_flutter.dart' show WebView, WebViewController, JavascriptMode;

class EkranMesovePDF extends StatefulWidget {
  final String kovetzPDF;
  final String kotert;
  final bool meniLiftoachBeMatsaveChitzoni;

  const EkranMesovePDF({
    super.key,
    required this.kovetzPDF,
    required this.kotert,
    this.meniLiftoachBeMatsaveChitzoni = true,
  });

  @override
  State<EkranMesovePDF> createState() => _EkranMesovePDFState();
}

class _EkranMesovePDFState extends State<EkranMesovePDF> {
  bool _toveaTovah = true;
  late WebViewController _menahal;

  @override
  void initState() {
    super.initState();
    
    // Enable hybrid composition for better performance on Android
    if (Platform.isAndroid) {
      final AndroidWebViewController androidController = WebViewController()
        ..setJavaScriptMode(JavascriptMode.unrestricted);
      WebView.platform = AndroidWebViewPlatform(controller: androidController);
    }
  }

  Future<void> _lehatilPDF() async {
    setState(() => _toveaTovah = true);
    
    if (widget.kovetzPDF.startsWith('http')) {
      final tikunRishmi = await getTemporaryDirectory();
      final kovetz = File('${tikunRishmi.path}/temp.pdf');
      final teshuvah = await http.get(Uri.parse(widget.kovetzPDF));
      await kovetz.writeAsBytes(teshuvah.bodyBytes);
      _liftoachBeMatsaveChitzoni(kovetz.path);
    } else {
      _liftoachBeMatsaveChitzoni(widget.kovetzPDF);
    }
  }

  Future<void> _liftoachBeMatsaveChitzoni(String netiv) async {
    if (await canLaunchUrl(Uri.parse(netiv))) {
      await launchUrl(
        Uri.parse(netiv),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kotert),
        centerTitle: true,
        actions: [
          if (widget.meniLiftoachBeMatsaveChitzoni)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => _liftoachBeMatsaveChitzoni(widget.kovetzPDF),
              tooltip: 'פתח ביישום חיצוני',
            ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'about:blank',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _menahal = webViewController;
              _tovLefareshHTML();
            },
            onPageFinished: (String url) {
              setState(() => _toveaTovah = false);
            },
          ),
          if (_toveaTovah)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Future<void> _tovLefareshHTML() async {
    final htmlContent = '''
    <!DOCTYPE html>
    <html dir="rtl">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
      <style>
        body, html { 
          margin: 0; 
          padding: 0; 
          height: 100%; 
          overflow: hidden; 
          background-color: #f5f5f5;
        }
        #pdf-viewer { 
          width: 100%; 
          height: 100%; 
          border: none; 
        }
        .loading {
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100%;
          font-family: Arial, sans-serif;
          color: #666;
        }
      </style>
    </head>
    <body>
      <div id="loading" class="loading">
        <p>טוען מסמך...</p>
      </div>
      <iframe 
        id="pdf-viewer" 
        src="https://docs.google.com/viewer?url=${Uri.encodeComponent(widget.kovetzPDF)}&embedded=true" 
        frameborder="0"
        onload="document.getElementById('loading').style.display='none';"
        style="display:none;">
      </iframe>
      <script>
        document.getElementById('pdf-viewer').onload = function() {
          document.getElementById('loading').style.display = 'none';
          document.getElementById('pdf-viewer').style.display = 'block';
        };
      </script>
    </body>
    </html>
    ''';
    
    await _menahal.loadHtmlString(htmlContent);
  }
}

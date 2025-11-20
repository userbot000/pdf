import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EkranMesovePDF extends StatefulWidget {
  final String kovetzPDF;
  final String kotert;
  final bool meniLiftoachBeMatsaveChitzoni;

  const EkranMesovePDF({
    Key? key,
    required this.kovetzPDF,
    required this.kotert,
    this.meniLiftoachBeMatsaveChitzoni = true,
  }) : super(key: key);

  @override
  _EkranMesovePDFState createState() => _EkranMesovePDFState();
}

class _EkranMesovePDFState extends State<EkranMesovePDF> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    // יצירת בקר חדש
    _controller = WebViewController();
    
    // הפעלת JavaScript
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    
    // טיפול באירועי טעינה
    _controller.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (String url) {
        setState(() => _isLoading = true);
      },
      onPageFinished: (String url) {
        setState(() => _isLoading = false);
      },
    ));

    // טעינת ה-PDF
    final pdfUrl = widget.kovetzPDF.startsWith('http')
        ? 'https://docs.google.com/viewer?url=${Uri.encodeComponent(widget.kovetzPDF)}&embedded=true'
        : widget.kovetzPDF;
        
    await _controller.loadRequest(Uri.parse(pdfUrl));
  }

  Future<void> _liftoachBeMatsaveChitzoni(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
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
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameWebViewPage extends StatefulWidget {
  const GameWebViewPage({
    super.key,
    required this.url,
    this.title = 'Joc',
  });

  final String url;
  final String title;

  @override
  State<GameWebViewPage> createState() => _GameWebViewPageState();
}

class _GameWebViewPageState extends State<GameWebViewPage> {
  late final WebViewController _ctrl;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p / 100),
          onPageFinished: (_) => setState(() => _progress = 0),
          onWebResourceError: (e) => debugPrint('Web error: $e'),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // dacă avem istoric în WebView -> mergem înapoi în WebView
        if (await _ctrl.canGoBack()) {
          _ctrl.goBack();
          return;
        }

        // altfel închidem ecranul Flutter (verifică BuildContext-ul, nu State-ul)
        if (!context.mounted) return;
        Navigator.of(context).pop(result);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _ctrl.canGoBack()) {
                _ctrl.goBack();
                return;
              }
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _ctrl.reload(),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _progress > 0 && _progress < 1 ? 3 : 0,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: _progress,
                child: const ColoredBox(color: Colors.green),
              ),
            ),
          ),
        ),
        body: WebViewWidget(controller: _ctrl),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/helpers/url_manager.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/components/quilt_overlay_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final String? title;
  final bool isGame;
  final bool showOpenInBrowser;
  final VoidCallback? onOpenInBrowser;

  const CustomWebView({
    super.key,
    required this.url,
    this.title,
    this.isGame = false,
    this.showOpenInBrowser = true,
    this.onOpenInBrowser,
  });

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  final UrlManager _urlManager = UrlManager();

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGame) {
      return Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading) const QuiltOverlayIndicator(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title ?? '',
          style: QuiltTheme.simpleWhiteTextStyle.copyWith(fontSize: 24),
        ),
        backgroundColor: QuiltTheme.dialogBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: QuiltTheme.primaryLabelColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<_WebViewMenuAction>(
            icon: const Icon(
              Icons.more_vert,
              color: QuiltTheme.primaryLabelColor,
            ),
            color: QuiltTheme.dialogBackgroundColor,
            offset: const Offset(0, kToolbarHeight),
            onSelected: (action) async {
              switch (action) {
                case _WebViewMenuAction.refresh:
                  await controller.reload();
                  return;
                case _WebViewMenuAction.openInBrowser:
                  if (widget.onOpenInBrowser != null) {
                    widget.onOpenInBrowser!();
                    return;
                  }
                  await _urlManager.launch(widget.url);
                  return;
              }
            },
            itemBuilder: (context) {
              final items = <PopupMenuEntry<_WebViewMenuAction>>[
                PopupMenuItem(
                  value: _WebViewMenuAction.refresh,
                  child: Text(
                    'Refresh',
                    style: QuiltTheme.simpleWhiteTextStyle,
                  ),
                ),
              ];
              if (widget.showOpenInBrowser) {
                items.add(
                  PopupMenuItem(
                    value: _WebViewMenuAction.openInBrowser,
                    child: Text(
                      'Open in browser',
                      style: QuiltTheme.simpleWhiteTextStyle,
                    ),
                  ),
                );
              }
              return items;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const QuiltOverlayIndicator(),
        ],
      ),
    );
  }
}

enum _WebViewMenuAction { refresh, openInBrowser }

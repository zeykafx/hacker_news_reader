import 'dart:async';
import 'dart:io';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/item.dart';
import 'NavigationControls.dart';

class StoryReader extends StatefulWidget {
  final Item item;

  const StoryReader({Key? key, required this.item}) : super(key: key);

  @override
  _StoryReaderState createState() => _StoryReaderState();
}

class _StoryReaderState extends State<StoryReader> {
  int loadingPercentage = 0;

  Completer<WebViewController> controller = Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    bsbController.addListener(onBsbChanged);
    super.initState();
  }

  bool isLocked = false;
  bool isCollapsed = true;
  bool isExpanded = false;
  final bsbController = BottomSheetBarController();

  void onBsbChanged() {
    if (bsbController.isCollapsed && !isCollapsed) {
      setState(() {
        isCollapsed = true;
        isExpanded = false;
      });
    } else if (bsbController.isExpanded && !isExpanded) {
      setState(() {
        isCollapsed = false;
        isExpanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: BottomSheetBar(
        backdropColor: Theme.of(context).colorScheme.surface,
        controller: bsbController,
        locked: isLocked,
        expandedBuilder: (scrollController) => ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) => ListTile(title: Text(index.toString())),
          itemCount: 50,
        ),
        collapsed: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                controller.future.then((value) async {
                  if (await value.canGoBack()) {
                    await value.goBack();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No page in history')),
                    );
                    return;
                  }
                });
              },
            ),
            IconButton(
                onPressed: () {
                  controller.future.then((value) {
                    value.reload();
                  });
                },
                icon: const Icon(Icons.replay)),
            IconButton(
                onPressed: () {
                  bsbController.expand();
                },
                icon: const Icon(Icons.arrow_upward)),
            // TODO: add a dark mode button somehow
            // IconButton(
            //     onPressed: () {
            //       controller.future.then((value) {
            //         value.
            //       });
            //     },
            //     icon: const Icon(Icons.invert_colors_on)),
          ],
        ),
        body: Stack(
          children: [
            if (widget.item.url != "")
              WebView(
                initialUrl: widget.item.url,
                onWebViewCreated: (webViewController) {
                  controller.complete(webViewController);
                },
                onPageStarted: (url) {
                  setState(() {
                    loadingPercentage = 0;
                  });
                },
                onProgress: (progress) {
                  setState(() {
                    loadingPercentage = progress;
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    loadingPercentage = 100;
                  });
                },
              ),
            if (widget.item.text != "")
              Column(
                children: [
                  Text("${widget.item.title} - ${widget.item.by}"),
                  Text(widget.item.text),
                ],
              ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}

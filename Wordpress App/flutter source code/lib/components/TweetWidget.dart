import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mighty_news/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetWebView extends StatefulWidget {
  final String? tweetUrl;

  final String? tweetID;

  TweetWebView({this.tweetUrl, this.tweetID});

  TweetWebView.tweetID(String tweetID)
      : this.tweetID = tweetID,
        this.tweetUrl = null;

  TweetWebView.tweetUrl(String tweetUrl)
      : this.tweetUrl = tweetUrl,
        this.tweetID = null;

  @override
  _TweetWebViewState createState() => new _TweetWebViewState();
}

class _TweetWebViewState extends State<TweetWebView> {
  String? _tweetHTML;

  WebViewController? webViewController;
  double height = 500.0;

  @override
  void initState() {
    super.initState();

    _requestTweet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_tweetHTML != null && _tweetHTML!.length > 0) {
      String downloadUrl = Uri.dataFromString(_tweetHTML!, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();

      // Create the WebView to contain the tweet HTML
      Widget webView = WebView(
        initialUrl: downloadUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (c) async {
          webViewController = c;

          try {
            //height = double.parse(await c.evaluateJavascript("document.documentElement.scrollHeight;"));
          } on Exception catch (e) {
            height = 500.0;
            log(e);
          }

          setState(() {});
        },
      );

      child = LimitedBox(
        maxHeight: height,
        child: Stack(
          children: [
            webView,
            Container().onTap(() {
              launchUrl(widget.tweetUrl!, forceWebView: true);
            }),
          ],
        ),
      );
    } else {
      child = Text('Loading...', style: primaryTextStyle());
    }

    return Container(child: child);
  }

  /// Download the embedded tweet.
  /// See Twitter docs: https://developer.twitter.com/en/docs/twitter-for-websites/embedded-tweets/overview
  void _requestTweet() async {
    String? tweetUrl = widget.tweetUrl;
    String? tweetID;

    if (tweetUrl == null || tweetUrl.isEmpty) {
      if (widget.tweetID == null || widget.tweetID!.isEmpty) {
        throw new ArgumentError('Missing tweetUrl or tweetID property.');
      }
      tweetUrl = _formTweetURL(widget.tweetID);
      tweetID = widget.tweetID;
    }

    if (tweetID == null) {
      //tweetID = _tweetIDFromUrl(tweetUrl);
    }

    // Example: https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/463440424141459456
    final downloadUrl = "https://publish.twitter.com/oembed?url=$tweetUrl";
    log("TweetWebView._requestTweet: $downloadUrl");

    final jsonString = await _loadTweet(downloadUrl);
    final html = _parseTweet(jsonString);
    if (html != null) {
      //final filename = await _saveTweetToFile('1', html);
      setState(() {
        _tweetHTML = html;
      });
    }
  }

  String? tweetIDFromUrl(String tweetUrl) {
    final uri = Uri.parse(tweetUrl);
    if (uri.pathSegments.length > 0) {
      return uri.pathSegments[uri.pathSegments.length - 1];
    }
    return null;
  }

  String _formTweetURL(String? tweetID) {
    return "https://twitter.com/Interior/status/$tweetID";
  }

  Future<String> saveTweetToFile(String tweetID, String html) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final filename = '$tempPath/tweet-$tweetID.html';
    File(filename).writeAsString(html);
    return filename;
  }

  String? _parseTweet(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      log('TweetWebView._parseTweet: empty jsonString');
      return null;
    }

    var item;
    try {
      item = json.decode(jsonString);
    } catch (e) {
      log(e);
      log('error parsing tweet json: $jsonString');
      return '<p>error loading tweet</p>';
    }

    final String? html = item['html'];

    if (html == null || html.isEmpty) {
      log('TweetWebView._parseTweet: empty html');
    }

    return html;
  }

  Future<String> _loadTweet(String tweetUrl) async {
    http.Response result = await _downloadTweet(tweetUrl);

    return result.body;
  }

  Future<http.Response> _downloadTweet(String tweetUrl) {
    return http.get(Uri.parse(tweetUrl));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}

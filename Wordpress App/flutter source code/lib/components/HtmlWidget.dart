import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:mighty_news/components/VimeoEmbedWidget.dart';
import 'package:mighty_news/components/YouTubeEmbedWidget.dart';
import 'package:mighty_news/utils/Common.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';
import 'TweetWidget.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent!,
      onLinkTap: (s, _, __, ___) {
        launchUrl(s!, forceWebView: true);
      },
      onImageTap: (s, _, __, ___) {
        openPhotoViewer(context, Image.network(s!).image);
      },
      style: {
        'embed': Style(color: color ?? transparentColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'strong': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'a': Style(color: color ?? Colors.blue, fontWeight: FontWeight.bold, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'div': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'figure': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()), padding: EdgeInsets.zero, margin: EdgeInsets.zero),
        'h1': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h2': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h3': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h4': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h5': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'h6': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'ol': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'ul': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'strike': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'u': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'b': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'i': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'hr': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'header': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'code': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'data': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'body': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'big': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'blockquote': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'audio': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'img': Style(width: context.width(), padding: EdgeInsets.only(bottom: 8), fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
        'li': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
          listStyleType: ListStyleType.DISC,
          listStylePosition: ListStylePosition.OUTSIDE,
        ),
      },
      customRender: {
        "embed": (RenderContext renderContext, Widget child) {
          var videoLink = renderContext.parser.htmlData.text.splitBetween('<embed>', '</embed');

          if (videoLink.contains('yout')) {
            return YouTubeEmbedWidget(videoLink.replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (videoLink.contains('vimeo')) {
            return VimeoEmbedWidget(videoLink.replaceAll('<br>', ''));
          } else {
            return child;
          }
        },
        "figure": (RenderContext renderContext, Widget child) {
          if (renderContext.tree.element!.innerHtml.contains('yout')) {
            return YouTubeEmbedWidget(renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (renderContext.tree.element!.innerHtml.contains('vimeo')) {
            return VimeoEmbedWidget(renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').splitAfter('com/'));
          } else if (renderContext.tree.element!.innerHtml.contains('twitter')) {
            String t = renderContext.tree.element!.innerHtml.splitAfter('<div class="wp-block-embed__wrapper">').splitBefore('</div>');
            return TweetWebView.tweetUrl(t);
          } else if (renderContext.tree.element!.innerHtml.contains('audio controls')) {
            return Theme(
              data: ThemeData(),
              child: child,
            );
          } else {
            return child;
          }
        },
      },
    );
  }
}

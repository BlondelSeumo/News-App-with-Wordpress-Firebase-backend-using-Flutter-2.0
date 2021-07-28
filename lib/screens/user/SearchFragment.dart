import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'UserNewsListWidget.dart';

class SearchFragment extends StatefulWidget {
  static String tag = '/SearchFragment';

  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  TextEditingController searchCont = TextEditingController();

  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    200.milliseconds.delay.then((value) => context.requestFocus(searchFocus));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.cardColor,
        title: AppTextField(
          controller: searchCont,
          textFieldType: TextFieldType.OTHER,
          autoFocus: true,
          focus: searchFocus,
          decoration: InputDecoration(
            hintText: 'search_news'.translate,
            hintStyle: primaryTextStyle(),
            border: InputBorder.none,
          ),
          onChanged: (s) {
            setState(() {});
          },
        ),
      ),
      body: Container(
        child: searchCont.text.isNotEmpty
            ? FutureBuilder<List<NewsData>>(
                future: newsService.getNewsFuture(searchText: searchCont.text),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (snap.data!.isEmpty) return noDataWidget();

                    return UserNewsListWidget(list: snap.data.validate());
                  } else {
                    return snapWidgetHelper(snap);
                  }
                },
              )
            : Text('start_typing'.translate, style: primaryTextStyle()).center(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/components/AppWidgets.dart';
import 'package:mighty_news_firebase/models/CommentData.dart';
import 'package:mighty_news_firebase/screens/user/LoginScreen.dart';
import 'package:mighty_news_firebase/services/CommentService.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class CommentScreen extends StatefulWidget {
  static String tag = '/CommentScreen';
  final String? newsId;

  CommentScreen({required this.newsId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentCont = TextEditingController();
  FocusNode commentFocus = FocusNode();

  CommentService? commentService;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    commentService = CommentService(widget.newsId);

    if (!isMobile) 1.seconds.delay.then((value) => context.requestFocus(commentFocus));
  }

  Future<void> saveComment() async {
    if (appStore.isTester) return toast(mTesterNotAllowedMsg);

    if (commentCont.text.trim().isEmpty) return toast('comment_required'.translate);
    hideKeyboard(context);

    CommentData commentData = CommentData();

    commentData.newsId = widget.newsId;
    commentData.comment = commentCont.text.trim();
    commentData.userId = getStringAsync(USER_ID);
    commentData.userName = getStringAsync(FULL_NAME);
    commentData.createdAt = DateTime.now();
    commentData.updatedAt = DateTime.now();

    await commentService!.addDocument(commentData.toJson()).then((value) {
      commentCont.clear();

      if (!isMobile) context.requestFocus(commentFocus);

      setState(() {});
    });
  }

  Future<void> deleteComment(String? id) async {
    if (appStore.isTester) return toast(mTesterNotAllowedMsg);

    await commentService!.removeDocument(id).then((value) {
      commentCont.clear();

      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('comments'.translate, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
      body: Container(
        height: context.height(),
        width: context.width(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            StreamBuilder<List<CommentData>>(
              stream: commentService?.comments(),
              builder: (BuildContext context, snap) {
                if (snap.hasData) {
                  if (snap.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snap.data!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 100),
                      itemBuilder: (_, index) {
                        CommentData data = snap.data![index];

                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data.comment.validate(), style: primaryTextStyle()).expand(),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline_outlined),
                                      onPressed: () {
                                        deleteComment(data.id);
                                      },
                                    ).visible(data.userId == appStore.userId),
                                  ],
                                ),
                                Text(data.updatedAt!.timeAgo, style: secondaryTextStyle(size: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return noDataWidget();
                  }
                } else {
                  return snapWidgetHelper(snap);
                }
              },
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: context.dividerColor))),
                padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                width: context.width(),
                height: 60,
                child: AppTextField(
                  controller: commentCont,
                  focus: commentFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: InputDecoration(
                    hintText: 'write_here'.translate,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  suffix: Icon(Icons.send, color: Colors.black).paddingAll(4).onTap(() {
                    saveComment();
                  }),
                  onFieldSubmitted: (s) {
                    saveComment();
                  },
                ),
              ).visible(
                appStore.isLoggedIn,
                defaultWidget: AppButton(
                  text: 'login'.translate,
                  width: context.width() - 16,
                  onTap: () async {
                    await LoginScreen(isNewTask: false).launch(context);

                    setState(() {});
                  },
                ).paddingAll(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

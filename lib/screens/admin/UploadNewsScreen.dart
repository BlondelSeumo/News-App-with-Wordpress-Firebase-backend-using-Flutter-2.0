import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_news_firebase/components/HtmlWidget.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/models/CategoryData.dart';
import 'package:mighty_news_firebase/models/NewsData.dart';
import 'package:mighty_news_firebase/network/RestApis.dart';
import 'package:mighty_news_firebase/services/FileStorageService.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import '../../main.dart';
import 'CommentScreen.dart';
import 'components/PickImageDialog.dart';

class UploadNewsScreen extends StatefulWidget {
  static String tag = '/UploadNewsScreen';
  final NewsData? data;

  UploadNewsScreen({this.data});

  @override
  _UploadNewsScreenState createState() => _UploadNewsScreenState();
}

class _UploadNewsScreenState extends State<UploadNewsScreen> {
  var formKey = GlobalKey<FormState>();
  AsyncMemoizer categoryMemoizer = AsyncMemoizer<List<CategoryData>>();
  bool isUpdate = false;

  TextEditingController titleCont = TextEditingController();
  TextEditingController imageCont = TextEditingController();
  TextEditingController sourceUrlCont = TextEditingController();
  TextEditingController contentCont = TextEditingController();
  TextEditingController shortContentCont = TextEditingController();

  String? newsStatus = NewsStatusDraft;
  String? newsType = NewsTypeRecent;

  List<String> newsStatusList = [NewsStatusPublished, NewsStatusUnpublished, NewsStatusDraft];
  List<String> newsTypeList = [NewsTypeRecent, NewsTypeBreaking, NewsTypeStory];

  CategoryData? selectedCategory;

  bool? sendNotification = true;
  bool? allowComments = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    // Don't send push notifications when updating by default.
    sendNotification = !isUpdate;

    if (isUpdate) {
      titleCont.text = widget.data!.title.validate();
      imageCont.text = widget.data!.image.validate();
      sourceUrlCont.text = widget.data!.sourceUrl.validate();
      contentCont.text = widget.data!.content.validate();
      shortContentCont.text = widget.data!.shortContent.validate();

      newsStatus = widget.data!.newsStatus;
      newsType = widget.data!.newsType;
    }
  }

  Future<void> save() async {
    if (appStore.isTester) return toast(mTesterNotAllowedMsg);

    if (selectedCategory == null) return toast('select_category'.translate);

    if (formKey.currentState!.validate()) {
      NewsData newsData = NewsData();

      newsData.title = titleCont.text.trim();
      newsData.caseSearch = titleCont.text.trim().setSearchParam();
      newsData.image = imageCont.text.trim();
      newsData.sourceUrl = sourceUrlCont.text.trim();
      newsData.content = contentCont.text.trim();
      newsData.shortContent = parseHtmlString(shortContentCont.text.trim());

      newsData.newsStatus = newsStatus;
      newsData.newsType = newsType;
      newsData.allowComments = allowComments;

      if (selectedCategory != null) {
        newsData.categoryRef = db.collection('categories').doc(selectedCategory!.id);
      }
      newsData.authorRef = db.collection('users').doc(appStore.userId);

      newsData.updatedAt = DateTime.now();

      if (isUpdate) {
        /// Set default value when updating document
        newsData.id = widget.data!.id;
        newsData.createdAt = widget.data!.createdAt;
        newsData.postViewCount = widget.data!.postViewCount.validate();
        newsData.commentCount = widget.data!.commentCount.validate();

        ///
        await newsService.updateDocument(newsData.toJson(), newsData.id).then((value) {
          toast('save'.translate);

          finish(context);
        });
      } else {
        newsData.postViewCount = 0;
        newsData.commentCount = 0;
        newsData.createdAt = DateTime.now();

        ///
        await newsService.addDocument(newsData.toJson()).then((value) async {
          toast('save'.translate);

          if (sendNotification!) {
            //Send push notification

            sendPushNotifications(parseHtmlString(titleCont.text.trim()), parseHtmlString(contentCont.text.trim()), id: value.id, image: imageCont.text.trim());
          }

          LiveStream().emit(StreamSelectItem, 2);
        });
      }
    } else {
      //
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: isUpdate
          ? appBarWidget(
              parseHtmlString(widget.data!.title),
              actions: [
                IconButton(
                  icon: Icon(FontAwesome.comment_o, color: Colors.black),
                  onPressed: () {
                    CommentScreen(newsId: widget.data!.id).launch(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_outlined, color: Colors.black),
                  onPressed: () {
                    showConfirmDialog(context, 'delete_post'.translate, positiveText: 'yes'.translate, negativeText: 'no'.translate).then((value) {
                      if (value ?? false) {
                        if (appStore.isTester) return toast(mTesterNotAllowedMsg);

                        newsService.removeDocument(widget.data!.id).then((value) {
                          deleteFile(widget.data!.image!).then((value) {
                            finish(context);
                          });
                        });
                      }
                    });
                  },
                ),
              ],
            )
          : null,
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.width() * 0.5,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 50),
                child: Form(
                  key: formKey,
                  onChanged: () {
                    if (formKey.currentState!.validate()) {
                      newsStatus = NewsStatusPublished;

                      setState(() {});
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('category'.translate, style: secondaryTextStyle()),
                          8.height,
                          FutureBuilder<List<CategoryData>>(
                            future: categoryMemoizer.runOnce(() => categoryService.categoriesFuture()).then((value) => value as List<CategoryData>),
                            builder: (_, snap) {
                              if (snap.hasData) {
                                if (snap.data!.isEmpty) return SizedBox();

                                if (selectedCategory == null) {
                                  if (isUpdate) {
                                    selectedCategory = snap.data!.firstWhere((element) => element.id == widget.data!.categoryRef!.id);
                                  } else {
                                    selectedCategory = snap.data!.first;
                                  }
                                }
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: radius(),
                                    color: Colors.grey.shade200,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: DropdownButton(
                                    underline: Offstage(),
                                    items: snap.data!.map((e) {
                                      return DropdownMenuItem(
                                        child: Text(e.name.validate()),
                                        value: e,
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: selectedCategory,
                                    onChanged: (dynamic c) {
                                      selectedCategory = c;

                                      setState(() {});
                                    },
                                  ),
                                );
                              } else {
                                return snapWidgetHelper(snap);
                              }
                            },
                          ),
                          16.height,
                          AppTextField(
                            controller: titleCont,
                            textFieldType: TextFieldType.ADDRESS,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 2,
                            minLines: 1,
                            decoration: inputDecoration(labelText: 'title'.translate),
                            validator: (s) {
                              if (s!.trim().isEmpty) return errorThisFieldRequired;
                              return null;
                            },
                          ),
                          16.height,
                          Stack(
                            children: [
                              AppTextField(
                                controller: imageCont,
                                textFieldType: TextFieldType.OTHER,
                                decoration: inputDecoration(labelText: 'featured_image_url'.translate).copyWith(
                                  suffixIcon: AppButton(
                                    text: 'media'.translate,
                                    onTap: () {
                                      showInDialog(context, child: PickImageDialog(), contentPadding: EdgeInsets.zero).then((value) {
                                        if (value != null && value.toString().isNotEmpty) {
                                          imageCont.text = value.toString();
                                        }
                                      });
                                    },
                                  ).paddingRight(8).visible(false),
                                ),
                                keyboardType: TextInputType.url,
                                validator: (s) {
                                  if (s!.isEmpty) return errorThisFieldRequired;
                                  if (!s.validateURL()) return 'url_invalid'.translate;
                                  return null;
                                },
                              ),
                            ],
                          ),
                          16.height,
                          AppTextField(
                            controller: sourceUrlCont,
                            textFieldType: TextFieldType.ADDRESS,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: inputDecoration(labelText: 'source_url'.translate),
                            maxLines: 2,
                            minLines: 1,
                            keyboardType: TextInputType.url,
                            validator: (s) {
                              if (s!.isNotEmpty && !s.validateURL()) return 'url_invalid'.translate;
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            controller: shortContentCont,
                            textFieldType: TextFieldType.ADDRESS,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: inputDecoration(labelText: 'short_content'.translate),
                            maxLines: 2,
                            minLines: 1,
                            maxLength: 200,
                            validator: (s) {
                              if (newsType == NewsTypeStory && s!.trim().isEmpty) return 'Short content is required when you add a story';
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            controller: contentCont,
                            textFieldType: TextFieldType.ADDRESS,
                            decoration: inputDecoration(labelText: 'content_html'.translate),
                            minLines: 4,
                            validator: (s) {
                              if (s!.trim().isEmpty) return errorThisFieldRequired;
                              return null;
                            },
                            onChanged: (s) {
                              setState(() {});
                            },
                          ),
                          16.height,
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('type'.translate, style: boldTextStyle()).withWidth(80),
                              Wrap(
                                children: newsTypeList.map((e) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio(
                                        value: e,
                                        groupValue: newsType,
                                        onChanged: (dynamic s) {
                                          newsType = s;

                                          setState(() {});
                                        },
                                      ),
                                      Text(e.capitalizeFirstLetter(), style: secondaryTextStyle()).withWidth(100).paddingAll(8).onTap(() {
                                        newsType = e;

                                        setState(() {});
                                      }),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          16.height,
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('status'.translate, style: boldTextStyle()).withWidth(80),
                              Wrap(
                                children: newsStatusList.map((e) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio(
                                        value: e,
                                        groupValue: newsStatus,
                                        onChanged: (dynamic s) {
                                          newsStatus = s;

                                          setState(() {});
                                        },
                                      ),
                                      Text(e.capitalizeFirstLetter(), style: secondaryTextStyle()).withWidth(100).paddingAll(8).onTap(() {
                                        newsStatus = e;

                                        setState(() {});
                                      }),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(top: 16, left: 16, right: 16, bottom: 16),
                      CheckboxListTile(
                        value: sendNotification,
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        title: Text('send_notification'.translate, style: boldTextStyle()),
                        onChanged: (s) {
                          sendNotification = s;

                          setState(() {});
                        },
                      ),
                      CheckboxListTile(
                        value: allowComments,
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        title: Text('allow_comments'.translate, style: boldTextStyle()),
                        onChanged: (s) {
                          allowComments = s;

                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ).expand(),
            Container(
              width: context.width() * 0.5,
              height: context.height(),
              decoration: BoxDecoration(
                border: Border.all(color: context.dividerColor),
                borderRadius: radius(),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('preview'.translate, style: boldTextStyle()),
                        AppButton(
                          text: 'save'.translate,
                          padding: EdgeInsets.all(20),
                          onTap: () {
                            save();
                          },
                        ),
                      ],
                    ),
                    Divider(height: 25),
                    /*Text(titleCont.text.trim(), style: boldTextStyle()),
                    8.height,
                    Row(
                      children: [
                        if (thumbnailCont.text.trim().validateURL())
                          cachedImage(
                            thumbnailCont.text.trim(),
                            width: context.width(),
                          ).expand(),
                        8.width,
                        if (imageCont.text.trim().validateURL())
                          cachedImage(
                            imageCont.text.trim(),
                            width: context.width(),
                          ).expand(),
                      ],
                    ),
                    16.height,*/
                    HtmlWidget(postContent: contentCont.text.trim()),
                  ],
                ),
              ),
            ).expand(),
          ],
        ),
      ),
    );
  }
}

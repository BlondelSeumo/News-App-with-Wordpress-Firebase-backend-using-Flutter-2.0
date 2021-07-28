import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/AppLocalizations.dart';
import 'package:mighty_news_firebase/main.dart';
import 'package:mighty_news_firebase/network/RestApis.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'PickImageDialog.dart';

class SendNotificationWidget extends StatefulWidget {
  static String tag = '/SendNotificationWidget';

  @override
  SendNotificationWidgetState createState() => SendNotificationWidgetState();
}

class SendNotificationWidgetState extends State<SendNotificationWidget> {
  var formKey = GlobalKey<FormState>();

  TextEditingController titleCont = TextEditingController();
  TextEditingController notificationCont = TextEditingController();
  TextEditingController imageCont = TextEditingController();

  FocusNode notificationFocus = FocusNode();
  FocusNode imageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> onSendClick() async {
    if (appStore.isTester) return toast(mTesterNotAllowedMsg);

    if (formKey.currentState!.validate()) {
      sendPushNotifications(parseHtmlString(titleCont.text.trim()), parseHtmlString(notificationCont.text.trim()), image: imageCont.text.trim()).then((value) {
        //
      }).catchError((e) {
        toast(e);
      });
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
      body: Container(
        padding: EdgeInsets.all(16),
        width: context.width() * 0.5,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('send_notification_all_users'.translate, style: boldTextStyle()),
              16.height,
              AppTextField(
                controller: titleCont,
                textFieldType: TextFieldType.ADDRESS,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                decoration: inputDecoration(labelText: 'title'.translate),
                nextFocus: notificationFocus,
                autoFocus: true,
                validator: (s) {
                  if (s!.trim().isEmpty) return errorThisFieldRequired;
                  return null;
                },
              ),
              16.height,
              AppTextField(
                controller: notificationCont,
                focus: notificationFocus,
                textFieldType: TextFieldType.ADDRESS,
                textCapitalization: TextCapitalization.sentences,
                minLines: 4,
                decoration: inputDecoration(labelText: 'notification'.translate),
                nextFocus: imageFocus,
                validator: (s) {
                  if (s!.trim().isEmpty) return errorThisFieldRequired;
                  return null;
                },
              ),
              16.height,
              AppTextField(
                controller: imageCont,
                focus: imageFocus,
                textFieldType: TextFieldType.ADDRESS,
                decoration: inputDecoration(labelText: 'image_url'.translate).copyWith(
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
                  if (s!.isNotEmpty && !s.validateURL()) return 'url_invalid'.translate;
                  return null;
                },
              ),
              16.height,
              AppButton(
                text: 'send'.translate,
                padding: EdgeInsets.all(20),
                onTap: () {
                  onSendClick();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

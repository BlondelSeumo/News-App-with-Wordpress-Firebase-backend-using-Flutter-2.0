import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mighty_news_firebase/services/FileStorageService.dart';
import 'package:mighty_news_firebase/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class FileUploadWidget extends StatefulWidget {
  static String tag = '/FileUploadWidget';

  @override
  FileUploadWidgetState createState() => FileUploadWidgetState();
}

class FileUploadWidgetState extends State<FileUploadWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['jpeg', 'jpg', 'png', 'gif', 'webp']);

    if (result != null) {
      await uploadFile(bytes: result.files.first.bytes).then((value) {
        log(value);
      }).catchError((e) {
        log(e);
        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
            text: 'upload'.translate,
            onTap: () {
              pickFile();
            },
          ),
        ],
      ),
    );
  }
}

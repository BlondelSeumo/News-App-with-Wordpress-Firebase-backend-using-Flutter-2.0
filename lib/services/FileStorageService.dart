import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mighty_news_firebase/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as path;

Future<String> uploadFile({Uint8List? bytes, dynamic blob, File? file, String prefix = mFirebaseStorageFilePath}) async {
  if (Uint8List == null && blob == null && file == null) {
    throw errorSomethingWentWrong;
  }

  if (prefix.isNotEmpty && !prefix.endsWith('/')) {
    prefix = '$prefix';
  }
  String fileName = currentTimeStamp().toString();
  if (file != null) {
    fileName = '${path.basename(file.path)}';
  }

  Reference storageReference = FirebaseStorage.instance.ref(mFirebaseStorageFilePath).child('$fileName.png');

  log(storageReference.fullPath);

  UploadTask? uploadTask;

  if (file != null) {
    uploadTask = storageReference.putFile(file);
  } else if (blob != null) {
    uploadTask = storageReference.putBlob(blob);
  } else if (bytes != null) {
    uploadTask = storageReference.putData(bytes, SettableMetadata(contentType: 'image/png'));
  }

  if (uploadTask == null) throw errorSomethingWentWrong;

  log('File Uploading');

  return await uploadTask.then((v) async {
    log('File Uploaded');

    if (v.state == TaskState.success) {
      String url = await storageReference.getDownloadURL();

      log(url);

      return url;
    } else {
      throw errorSomethingWentWrong;
    }
  }).catchError((error) {
    throw error;
  });
}

Future<void> deleteFile(String url) async {
  String path = url.replaceAll(RegExp(r'https://firebasestorage.googleapis.com/v0/b/mighty-news-firebase.appspot.com/o/default_images%2F'), '').split('?')[0];

  await FirebaseStorage.instance.ref().child(path).delete().then((value) {
    log('File deleted: $url');
  }).catchError((e) {
    throw e;
  });
}

Future<List<String>> listOfFileFromFirebaseStorage({String? path}) async {
  List<String> list = [];

  var ref = FirebaseStorage.instance.ref('$mFirebaseStorageFilePath');
  log(ref);

  var listResult = await ref.listAll();
  log(listResult);

  listResult.prefixes.forEach((element) {
    log(element.fullPath);
  });
  listResult.items.forEach((element) {
    log(element.fullPath);

    list.add(element.fullPath);
  });
  return list;
}

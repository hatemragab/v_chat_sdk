import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class CloudFireUpload {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  static Future<String> uploadFile(
    PlatformFileSource fileSource,
    String userID,
  ) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putData(
        fileSource.uint8List,
        SettableMetadata(
          contentType: fileSource.mimeType,
        ));
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudStorageService {
  FirebaseStorage firebaseStorage =FirebaseStorage.instance;
  final _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();

  void _showSnackBar(String text) {
    _scaffoldKey.currentState!.showSnackBar(
       SnackBar(
      content: new Text(text),
    ));
  }

  Future<CloudStorageResult?> uploadImage({
    required File imageToUpload,
    required String title,
  }) async {
    debugPrint("cloudstorage: uploadImage: here");

    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    Reference firebaseStorageRef =firebaseStorage.ref().child('courrier/$imageFileName');

    TaskSnapshot storageSnapshot = await firebaseStorageRef.putFile(imageToUpload);

    try{
      if (storageSnapshot.state == TaskState.success){
        debugPrint("cloudstorage: uploadImage: taskstate: ${TaskState.success}");

        var downloadUrl = await storageSnapshot.ref.getDownloadURL();



        var url = downloadUrl.toString();
        return CloudStorageResult(
          imageUrl: url,
          imageFileName: imageFileName,
        );
      }
    }catch(e){
      _showSnackBar("Sorry couldn't upload image");
    }

    _showSnackBar("Sorry couldn't upload image");

    return null;
  }

  Future deleteImage(String imageFileName) async {
    final FirebaseStorage firebaseStorage =FirebaseStorage.instance;
    Reference firebaseStorageRef =firebaseStorage.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class CloudStorageResult {
  final String? imageUrl;
  final String? imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}

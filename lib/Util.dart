import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as i;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbstore/Widget/Notification.dart';
import 'package:path_provider/path_provider.dart';

void showDeletionNotification(BuildContext context, String content) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      // Show the dialog
      return NotificationDialog(
        content: content,
      );
    },
  );
  // Automatically close the dialog after 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    Navigator.of(context).pop();
  });

  Future<Uint8List> readFileAsBytes(String imgPath) async {
    // Read the file as bytes
    Uint8List uint8List = await i.File(imgPath).readAsBytes();

    return uint8List;
  }
}

menhgia(number) {
  final formatCurrency = NumberFormat("#,##0");
  return formatCurrency.format(number);
}

Future<File> getImageFile(Uint8List imageData) async {
  File imageFile;

  if (imageData != Uint8List(0) && imageData != null && imageData.isNotEmpty) {
    // Generate a unique file name using current timestamp
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName =
          'image_$timestamp.png'; // You can change the file extension as needed

      // Get the app's temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      // Create a new File in the app's temporary directory
      imageFile = File('$tempPath/$fileName');

      // Write the image data to the file
      await imageFile.writeAsBytes(imageData);
    } on Exception catch (e) {
      print(e);
      return Future.error('Failed to create image file');
    }
  } else {
    print(" Image is empty");
    imageFile = File('');
  }

  return imageFile;
}

void showAutoDismissDialog(BuildContext context, String a) {
  Future.delayed(Duration(seconds: 1), () {
    Navigator.pop(context); // Dismiss the dialog after 1 second
  });

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(a),
          ));
}
 bool checkEmailFormat(String a){
  if (EmailValidator.validate(a)) {
    return true;
  } else {
    print("Invalid email address");
    return false;
  }
}

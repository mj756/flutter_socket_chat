import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Utility {
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = false,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: isSuccess ? Colors.white : Colors.red),
        ),
      ));
    } catch (ex) {}
  }

  static Future<String> selectFile({required BuildContext context}) async {
    String path = '';
    await FilePicker.platform
        .pickFiles(
      allowMultiple: false,
      type: FileType.any,
    )
        .then((result) {
      if (result != null && result.files.single.path != null) {
        path = result.files.single.path!;
        final f = File(path);
        int sizeInBytes = f.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 5) {
          path = '';
          Utility.showSnackBar(context, 'File size must be less than 5MB');
        }
      }
    });

    return path;
  }
}

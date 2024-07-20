import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:musicapp/utilits/constants/fontsStyles.dart';

class CustomAlertDialoge {
  static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String errMessage,
    required Function fn,
    required String image,
    bool isError = true,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image),
                const Gutter(),
                Text(
                  errMessage,
                  style: FontsStyles.teststyle15,
                ),
                const Gutter(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          fn();
                          Navigator.pop(context);
                        },
                        child: const Text("OK")),
                  ],
                )
              ],
            ),
          );
        });
  }
}

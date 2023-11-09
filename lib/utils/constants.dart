import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final supabase = Supabase.instance.client;


//colors
const kLeadBlack = Color(0xff1F1F1F);
const kModelBlack = Color(0xff2D2E33);
const kYellow = Color(0xffe99600);
const kYellowHighlight = Color.fromARGB(255, 245, 168, 25);
const kAccent = Color(0xff12596B);

// text
const kNunitoSansSemiBold18 = TextStyle(
  fontFamily: "NunitoSans",
  fontSize: 17,
  fontWeight: FontWeight.w600,
);

const kNunitoSans16 = TextStyle(
  fontFamily: "NunitoSans",
  fontSize: 17,
);

/// Simple preloader inside a Center widget
const preloader = Center(child: CircularProgressIndicator(color: Colors.white));

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        elevation: 6,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        // width: 280.0,
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }

  void showSuccessSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.green);
  }
}


// input field
const inputDecorationConst = InputDecoration(
  isDense: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  labelStyle:
      TextStyle(fontFamily: "NunitoSans", color: Colors.grey, fontSize: 16),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    // borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: OutlineInputBorder(
    // borderSide: BorderSide(color: Colors.white), // Set the border color to white
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Colors.grey),
  ),
   hintStyle: TextStyle(color: Colors.grey),
  //  style: TextStyle(color: Colors.white),
  // prefixStyle: TextStyle(color: Colors.white),
  // suffixStyle: TextStyle(color: Colors.white),
  // counterStyle: TextStyle(color: Colors.white),
  helperStyle: TextStyle(color: Colors.grey),
);


// pop up
Future kDefaultDialog(String title, String message,
    {VoidCallback? onYesPressed}) async {
  if (GetPlatform.isIOS) {
    await Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (onYesPressed != null)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
              ),
            ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onYesPressed,
            child: Text(
              (onYesPressed == null) ? "Ok" : "Yes", style: const TextStyle(color: kAccent),
            ),
          ),
        ],
      ),
    );
  } else {
    await Get.dialog(
      barrierDismissible: false,
      useSafeArea: false,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        actions: [
          if (onYesPressed != null)
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel", style: TextStyle(color: Colors.black),
              ),
            ),
          TextButton(
            onPressed: (onYesPressed == null)
                ? () { Get.back();}
                : onYesPressed,
            child: Text(
              (onYesPressed == null) ? "OK" : "Yes",
              style: const TextStyle(
                color: kAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// pop up
Future kDefaultDialog2(String title, String message) async {
  if (GetPlatform.isIOS) {
    await Get.dialog(
      CupertinoTheme(
        data: const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue, // Change the background color.
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white, // Change the text color.
      ),
    ),
        child: CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            // if (onYesPressed != null)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Okay",
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Okay",
              style: TextStyle(
                color: Color(0xFFE99600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
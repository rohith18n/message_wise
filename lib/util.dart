import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message_wise/size_config.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
//colors

const Color colorWhite = Color.fromARGB(255, 255, 255, 255);
const Color colorblack = Color.fromARGB(255, 42, 42, 42);
const Color colorlogo = Color.fromARGB(255, 4, 147, 147);
const Color colorSearchBarFilled = Color.fromARGB(255, 51, 114, 99);
const Color colorSearchBartext = Color.fromARGB(255, 255, 255, 255);
const Color colorMessageCurrentuser = Color.fromARGB(255, 51, 114, 99);
const Color colorMessageClientuser = Color.fromARGB(255, 205, 235, 186);
const Color colorMessageClientText = Color.fromARGB(255, 39, 39, 39);
const Color colorMessageClientTextWhite = Color.fromARGB(255, 255, 255, 255);
const Color iconColorGreen = Color.fromARGB(255, 114, 222, 170);
const Color errorColor = Colors.red;
const Color closeIconColor = Colors.red;
const Color successColor = Colors.green;

//sized box gap
Widget sizeHeight15 = SizedBox(
  height: getProportionateScreenHeight(15),
);
Widget sizeWidth20 = SizedBox(
  width: getProportionateScreenWidth(20),
);
//null image
const String nullPhoto = "assets/images/nullPhoto.jpeg";
// notification
void showTopNotification(
    {required BuildContext context,
    required String state,
    required MaterialColor color}) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      backgroundColor: color,
      message: state,
    ),
  );
}

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

enum UserConnections { request, connected, connect, pending }

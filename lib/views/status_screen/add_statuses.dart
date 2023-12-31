// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message_wise/Controllers/bloc/status_bloc.dart';
import 'package:message_wise/Controllers/bloc/status_event.dart';
import 'package:message_wise/Controllers/bloc/status_state.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/util.dart';
import 'package:message_wise/views/common/widgets/custom_text.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';

class AddStatus extends StatefulWidget {
  const AddStatus({super.key});

  @override
  State<AddStatus> createState() => _AddStatusState();
}

class _AddStatusState extends State<AddStatus> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(child: CustomText(content: 'New Status')),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: const CustomText(content: 'Take a Photo'),
                    onPressed: () async {
                      Navigator.pop(context);
                      Uint8List file = await pickImage(ImageSource.camera);
                      setState(() {
                        _file = file;
                      });
                    }),
                SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: const CustomText(content: 'Choose from Gallery'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Uint8List file = await pickImage(ImageSource.gallery);
                      setState(() {
                        _file = file;
                      });
                    }),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const CustomText(content: "Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(20)),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: getProportionateScreenHeight(35),
                    icon: const Icon(
                      Icons.upload,
                    ),
                    onPressed: () => _selectImage(context),
                  ),
                  const CustomText(
                    content: "Select Files to Upload",
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                child: Text(
                  'Status',
                  style: appBarHeadingStyle,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    final currentUser = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();

                    context.read<StatusBloc>().add(AddStatusEvent(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          username: currentUser.get("userName"),
                          profImage: currentUser.get("photo"),
                          description: _descriptionController.text,
                          file: _file!,
                        ));
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // Status Form
            body: BlocListener<StatusBloc, StatusState>(
              listener: (context, state) {
                if (state is StatusAddedState) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                  if (context.mounted) {
                    showSnackBar(
                      context,
                      'Updated!',
                    );
                  }
                  clearImage();
                } else if (state is StatusErrorState) {
                  if (context.mounted) {
                    showSnackBar(context, state.error);
                  }
                }
              },
              child: Column(
                children: <Widget>[
                  isLoading
                      ? const CustomIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  const Divider(),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Add a caption..",
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(CupertinoIcons.pencil),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
  }
}

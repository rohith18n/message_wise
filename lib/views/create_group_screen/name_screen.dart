// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_wise/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:message_wise/Models/select_model.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/service/profile%20service/profile_service.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/injectable.dart';
import 'package:message_wise/size_config.dart';
import 'package:message_wise/views/home%20Screen/home_screen.dart';
import 'package:message_wise/views/new%20group%20screen/widgets/group_member_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util.dart';
import '../common/widgets/custom_text.dart';
import '../common/widgets/textformcommon_style.dart';

final textController = TextEditingController();

class NameScreen extends StatelessWidget {
  NameScreen({super.key, required this.seletedBots});
  final List<SelectModel> seletedBots;
  final ValueNotifier<FilePickerResult?> imagePath = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: imagePath,
        builder: (context, value, child) => FloatingButton(
            text: textController.text,
            selectedBots: seletedBots,
            imagePath: imagePath.value),
      ),
      appBar: AppBar(
        title: Text("Create Group", style: appBarHeadingStyle),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  height: getProportionateScreenHeight(200),
                  child: ValueListenableBuilder(
                    valueListenable: imagePath,
                    builder: (context, value, child) => CircleAvatar(
                      backgroundImage: imagePath.value == null ||
                              imagePath.value!.paths[0] == null
                          ? const AssetImage(nullPhoto)
                          : FileImage(File(imagePath.value!.paths[0] ?? ""))
                              as ImageProvider,
                    ),
                  ),
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: getProportionateScreenHeight(39),
                    width: getProportionateScreenHeight(39),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFFF5F6F9),
                      ),
                      onPressed: () async {
                        imagePath.value =
                            await getIt<ProfileService>().selectImage();
                      },
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                    ),
                  ),
                ),
                // Positioned.fill(
                //     child: IconButton(
                //         onPressed: () async {
                //           imagePath.value =
                //               await getIt<ProfileService>().selectImage();
                //         },
                //         icon: const Icon(
                //           CupertinoIcons.camera,
                //           size: 20,
                //         ))),
              ],
            ),
            sizeHeight15,
            SizedBox(
              width: getProportionateScreenWidth(200),
              height: getProportionateScreenHeight(40),
              child: TextField(
                controller: textController,
                style: GoogleFonts.poppins(color: kTextColor),
                decoration: textFormFieldStyle("Group Name"),
              ),
            ),
            sizeHeight15,
            const CustomText(
              content: "Participants",
              colour: kTextColor,
            ),
            sizeHeight15,
            Expanded(
              child: GridView.builder(
                itemCount: seletedBots.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) =>
                    GroupMembersIcon(bot: seletedBots[index], isVisible: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingButton extends StatefulWidget {
  FloatingButton(
      {super.key,
      required this.text,
      required this.selectedBots,
      this.imagePath});
  final String text;
  final List<SelectModel> selectedBots;
  FilePickerResult? imagePath;

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  Color buttoncolor = successColor;
  @override
  void dispose() {
    log("disposed");

    textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: buttoncolor,
        onPressed: () {
          if (textController.text.isEmpty) {
            setState(() {
              buttoncolor = errorColor;
            });
          } else {
            context.read<GroupBloc>().add(CreateGroupEvent(
                botsId: widget.selectedBots,
                name: textController.text,
                image: widget.imagePath));
            setState(() {
              buttoncolor = successColor;
            });
          }
        },
        child: BlocConsumer<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is SuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const CustomIndicator();
            } else {
              return const Icon(
                Icons.check,
                color: colorMessageClientTextWhite,
              );
            }
          },
        ));
  }
}

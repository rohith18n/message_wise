import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_wise/components/custom_circular_progress_indicator.dart';
import 'package:message_wise/size_config.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Controllers/profile/profile_bloc_bloc.dart';
import '../../../Models/user_model.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(135),
      width: getProportionateScreenHeight(135),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          BlocConsumer<ProfileBlocBloc, ProfileBlocState>(
            listener: (context, state) {
              if (state is UpdateErorrState) {
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.error(
                    message: state.messages,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LoadCurrentUserState) {
                log("load current user in settings ${(state.props.first as Profile).email}");
                return CircleAvatar(
                  radius: getProportionateScreenHeight(80),
                  backgroundImage: state.currentUser.photo == null
                      ? const AssetImage("assets/images/nullPhoto.jpeg")
                          as ImageProvider
                      : NetworkImage(state.currentUser.photo ?? ""),
                );
              } else if (state is LoadingState) {
                return CircleAvatar(
                  radius: getProportionateScreenHeight(80),
                  backgroundImage:
                      const AssetImage("assets/images/nullPhoto.jpeg"),
                  child: const CustomIndicator(),
                );
              } else if (state is UpdateSuccessState) {
                return CircleAvatar(
                  radius: getProportionateScreenHeight(80),
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                );
              } else {
                return CircleAvatar(
                  radius: getProportionateScreenHeight(80),
                  backgroundImage:
                      const AssetImage("assets/images/nullPhoto.jpeg"),
                );
              }
            },
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 39,
              width: 39,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  context.read<ProfileBlocBloc>().add(UpdateFileEvent());
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

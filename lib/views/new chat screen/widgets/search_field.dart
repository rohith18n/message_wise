import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController textEditingcontroller;
  final String? hintText;
  const SearchField({
    Key? key,
    this.onChanged,
    required this.textEditingcontroller,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.85,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: textEditingcontroller,
        onChanged: onChanged,
        style: GoogleFonts.poppins(color: kTextColor),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.search,
              color: kPrimaryColor,
            )),
      ),
    );
  }
}

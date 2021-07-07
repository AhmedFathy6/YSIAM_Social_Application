import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Constants.dart';

class Component {
  static Widget defaultButton({
    Color color = primaryColor,
    double width = double.infinity,
    bool isUpperCase = true,
    double radius = 5.0,
    required String text,
    required VoidCallback onPressed,
  }) =>
      Container(
        width: width,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              radius,
            )),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
          ),
          textColor: Colors.white,
        ),
      );

  static Widget defaultTextButton({
    required String text,
    required VoidCallback onPressed,
    bool isUpperCase = true,
    TextStyle? style,
  }) =>
      TextButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: style == null
              ? TextStyle(
                  fontWeight: FontWeight.bold,
                )
              : style,
        ),
      );

  static Widget defaultTextFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType type,
    required FormFieldValidator<String> validator,
    BuildContext? context,
    String? hintText,
    bool hideBorder = false,
    TextStyle? style,
    bool isExpanded = false,
    TextStyle? labelStyle,
    bool isPassword = false,
    bool readOnly = false,
    bool hideCounter = false,
    double borderRadius = 20.0,
    IconData? suffixIcon,
    Color? suffixIconColor,
    GestureTapCallback? suffixPressed,
    ValueChanged<String>? submit,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    int maxLength = 50,
  }) =>
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
            ),
            height: 60.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 6.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: TextFormField(
              //textDirection: TextDirection.rtl,
              textAlign: TextAlign.end,
              controller: controller,
              validator: validator,
              onFieldSubmitted: submit,
              onChanged: onChanged,
              onTap: onTap,
              readOnly: readOnly,
              maxLength: maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                counterText: hideCounter ? '' : null,
                border: InputBorder.none,
                filled: true,
                errorStyle: TextStyle(
                  color: Colors.white,
                ),
                fillColor: Colors.white,
                counterStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              style: GoogleFonts.cairo().copyWith(
                color: Colors.black,
                fontSize: 14.0,
              ),
              keyboardType: type,
              obscureText: isPassword,
            ),
          ),
        ],
      );

  static void navigateTo(BuildContext context, Widget screen) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );

  static void navigateAndFinish(BuildContext context, Widget screen) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (route) => false,
      );

  static Widget buildLine({required double height, required double width}) =>
      Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
        ),
        child: Container(
          height: height,
          width: width,
          color: Colors.grey[300],
        ),
      );

  static AwesomeDialog buildAlert({
    required BuildContext context,
    required String title,
    required String body,
    required DialogType dialogType,
    Duration? hideAfter,
  }) {
    return AwesomeDialog(
      context: context,
      title: title,
      body: Text(
        body,
        style: GoogleFonts.cairo().copyWith(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
      dialogType: dialogType,
      padding: EdgeInsets.all(
        20.0,
      ),
      autoHide: hideAfter,
    );
  }
}

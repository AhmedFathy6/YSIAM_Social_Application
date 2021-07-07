import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'constants.dart';
import 'cubit/cubit.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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
    required IconData? prefixIcon,
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
    double borderRadius = 20.0,
    IconData? suffixIcon,
    Color? suffixIconColor,
    GestureTapCallback? suffixPressed,
    ValueChanged<String>? submit,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
  }) =>
      TextFormField(
        controller: controller,
        validator: validator,
        onFieldSubmitted: submit,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: style == null && context != null
            ? TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    AppCubit.get(context).isDark ? Colors.white : Colors.black)
            : style,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: hideBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: !hideBorder ? primaryColor : Colors.transparent,
                    width: 5.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    borderRadius,
                  ),
                ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: context != null
                      ? AppCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black
                      : Colors.black,
                )
              : null,
          suffixIcon: IconButton(
            onPressed: suffixPressed,
            icon: Icon(
              suffixIcon,
              color: suffixIconColor == null
                  ? context != null
                      ? AppCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black
                      : Colors.black
                  : suffixIconColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !hideBorder ? primaryColor : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !hideBorder ? primaryColor : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
          focusColor: Colors.black,
          labelStyle: context != null
              ? Theme.of(context).textTheme.caption
              : labelStyle,
          hintStyle: labelStyle,
        ),
        keyboardType: type,
        obscureText: isPassword,
        maxLines: isExpanded ? null : 1,
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
      dialogBackgroundColor:
          AppCubit.get(context).isDark ? HexColor('333739') : Colors.white,
      title: title,
      body: Text(
        body,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      dialogType: dialogType,
      padding: EdgeInsets.all(
        20.0,
      ),
      autoHide: hideAfter,
    );
  }

  static Future<Map<Uint8List, File?>> getImageAsBytes() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    final bytes = await pickedFile!.readAsBytes();
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path +
        "/${Random().nextInt(100)}${Uri.file(pickedFile.path).pathSegments.last}";
    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      minHeight: 900,
      minWidth: 900,
      quality: 35,
    );
    return {bytes: result};
  }

  static Future<List<File>> getFiles() async {
    var extensions = ['jpg', 'png', 'gif', 'jpeg'];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      allowMultiple: true,
    );
    if (result != null) {
      List<File> files = result.paths.map((e) => File(e!)).toList();
      return files;
    } else {
      // User canceled the picker
      return [];
    }
  }

  static Future<File?> compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path +
        "/${Random().nextInt(100)}${Uri.file(file.path).pathSegments.last}";
    return await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      minHeight: 900,
      minWidth: 900,
      quality: 35,
    );
  }

  static AppBar defaultAppBar({
    required BuildContext context,
    Widget? title,
    List<Widget>? actions,
    required VoidCallback beforeGoBack,
  }) =>
      AppBar(
        title: title != null ? title : null,
        titleSpacing: 0.0,
        actions: actions,
        leading: IconButton(
            icon: Icon(
              AppCubit.get(context).lang == 'en'
                  ? IconBroken.Arrow___Left_2
                  : IconBroken.Arrow___Right_2,
            ),
            onPressed: () {
              beforeGoBack();
              Navigator.pop(context);
            }),
      );

  static Widget defaultDivider(
          {required BuildContext context,
          double endIndent = 20.0,
          double indent = 20.0}) =>
      Divider(
        color: Theme.of(context).textTheme.caption!.color,
        endIndent: endIndent,
        indent: indent,
      );

  static Widget defaultFooter() => Container(
        height: 85,
      );
}

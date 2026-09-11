import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.softWrap = true,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      ),
    );
  }
}

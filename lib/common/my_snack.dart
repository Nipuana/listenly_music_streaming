import 'package:flutter/material.dart';
import '../core/constants/app_constants/app_colors.dart';
import '../core/constants/app_constants/app_radius.dart';

import '../core/utils/mysnack_utils.dart';
class MySnack {
	static void show(
		BuildContext context, {
		required String message,
		String? actionLabel,
		VoidCallback? onAction,
		Color? backgroundColor,
		Color? textColor,
		IconData? icon,
		SnackBarAction? customAction,
	}) {
		MysnackUtils.showCustom(
			context,
			message,
			backgroundColor: backgroundColor ?? AppColors.surface,
			textColor: textColor ?? AppColors.textPrimary,
			icon: icon ?? Icons.info_outline_rounded,
			shape: RoundedRectangleBorder(
				borderRadius: AppRadius.xl,
			),
		);
	}
}

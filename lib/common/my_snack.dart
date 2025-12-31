import 'package:flutter/material.dart';
import '../constant/app_colors.dart';
import '../constant/app_radius.dart';
import '../constant/app_text.dart';

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
		final snackBar = SnackBar(
			backgroundColor: backgroundColor ?? AppColors.surface,
			behavior: SnackBarBehavior.floating,
			elevation: 6,
			shape: RoundedRectangleBorder(
				borderRadius: AppRadius.xl,
			),
			content: Row(
				children: [
					if (icon != null)
						Padding(
							padding: const EdgeInsets.only(right: 8.0),
							child: Icon(icon, color: textColor ?? AppColors.textPrimary, size: 22),
						),
					Expanded(
						child: Text(
							message,
							style: AppText.body.copyWith(
								color: textColor ?? AppColors.textPrimary,
							),
						),
					),
				],
			),
			action: customAction ?? (actionLabel != null && onAction != null
					? SnackBarAction(
							label: actionLabel,
							onPressed: onAction,
							textColor: AppColors.link,
						)
					: null),
			margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
		);
		ScaffoldMessenger.of(context).showSnackBar(snackBar);
	}
}

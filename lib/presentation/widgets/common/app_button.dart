import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Border? border;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.padding,
    this.borderRadius,
    this.border,
    this.isLoading = false,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : backgroundColor = null,
       foregroundColor = null,
       padding = null,
       borderRadius = null,
       border = null;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : backgroundColor = AppColors.white,
       foregroundColor = AppColors.black,
       padding = null,
       borderRadius = null,
       border = null;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.white,
        foregroundColor: foregroundColor ?? AppColors.black,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        padding: padding ?? EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppBorderRadius.medium),
          side:
              border?.top ??
              BorderSide(
                color: AppColors.black.withValues(alpha: 0.3),
                width: 1,
              ),
        ),
      ),
      child:
          isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.bodyBase.copyWith(
                      fontWeight: FontWeight.w500,
                      color: foregroundColor ?? AppColors.black,
                    ),
                  ),
                ],
              ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      text: 'Continue with Google',
      onPressed: onPressed,
      isLoading: isLoading,
      icon: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://developers.google.com/identity/images/g-logo.png',
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

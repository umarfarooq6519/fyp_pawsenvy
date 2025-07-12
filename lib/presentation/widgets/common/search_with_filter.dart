import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/colors.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';

class SearchWithFilter extends StatelessWidget {
  final TextEditingController? searchController;
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onFilterPressed;
  final EdgeInsetsGeometry? padding;

  const SearchWithFilter({
    super.key,
    this.searchController,
    this.hintText = 'Search',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onFilterPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: AppSpacing.xl).add(
            EdgeInsets.symmetric(vertical: AppSpacing.md),
          ), // was pagePadding
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              controller: TextEditingController(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
              border: Border.all(color: AppColorStyles.lightPurple),
              boxShadow: AppShadows.purpleShadow,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.black,
              padding: EdgeInsets.all(AppSpacing.md),
              icon: const Icon(LineIcons.filter, color: Colors.black54),
              onPressed: onFilterPressed,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            color: AppColors.purple,
            boxShadow: AppShadows.mediumShadow,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            onTap: _toggle,
            child: const Center(
              child: Icon(Icons.close, color: AppColors.white, size: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
              color: AppColors.purple,
              boxShadow: AppShadows.mediumShadow,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
              onTap: _toggle,
              child: const Center(
                child: Icon(Icons.add, color: AppColors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;

    for (var i = 0; i < count; i++) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: 90.0, // Always go straight up
          maxDistance: (i + 1) * 60.0, // Stack vertically with 45px spacing
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: FadeTransition(
            opacity: progress,
            child: Transform.scale(scale: progress.value, child: child!),
          ),
        );
      },
      child: child,
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.iconColor,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? label;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        boxShadow: AppShadows.mediumShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md + 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(color: AppColors.black, size: 20),
                child: icon,
              ),
              if (label != null) ...[
                const SizedBox(width: 6),
                Text(label!, style: AppTextStyles.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

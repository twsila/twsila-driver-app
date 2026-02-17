import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/styles_manager.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<int> activePages;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.activePages,
  }) : super(key: key);

  static const double _centerSize = 90;
  static const double _barHeight = 120;
  static const double _contentBottomPadding = 16;
  static const double _rowHeight = 80;

  bool _canTap(int index) => activePages.contains(index);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _barHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: _contentBottomPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _NavItem(
                        rowHeight: _rowHeight,
                        activeIcon: ImageAssets.searchTripsActiveIcon,
                        inactiveIcon: ImageAssets.searchTripsInactiveIcon,
                        label: AppStrings.searchTrips.tr(),
                        selected: currentIndex == 0,
                        enabled: _canTap(0),
                        onTap: () => onTap(0),
                      ),
                      const SizedBox(width: _centerSize),
                      _NavItem(
                        rowHeight: _rowHeight,
                        activeIcon: ImageAssets.profileActiveIcon,
                        inactiveIcon: ImageAssets.profileInactiveIcon,
                        label: AppStrings.myProfile.tr(),
                        selected: currentIndex == 2,
                        enabled: _canTap(2),
                        onTap: () => onTap(2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: _contentBottomPadding,
            child: _CenterTripsButton(
              size: _centerSize,
              selected: currentIndex == 1,
              enabled: _canTap(1),
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterTripsButton extends StatefulWidget {
  final double size;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _CenterTripsButton({
    required this.size,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_CenterTripsButton> createState() => _CenterTripsButtonState();
}

class _CenterTripsButtonState extends State<_CenterTripsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _animate() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  static final Color _blue = ColorManager.splashBGColor;
  static final Color _blueDark = Color(0xFF050836);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scale,
          child: GestureDetector(
            onTap: widget.enabled ? _animate : null,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_blue, _blueDark],
                  stops: const [0.0, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _blue.withOpacity(0.45),
                    blurRadius: 16,
                    spreadRadius: widget.selected ? 2 : 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    ImageAssets.tripCenterIcon,
                    fit: BoxFit.contain,
                    width: widget.size - 48,
                    height: widget.size - 48,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.myTrips.tr(),
          textAlign: TextAlign.center,
          style: getMediumStyle(
            color: ColorManager.headersTextColor,
            fontSize: 12,
          ).copyWith(
            fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
            color: widget.selected
                ? ColorManager.splashBGColor
                : ColorManager.headersTextColor,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _NavItem extends StatelessWidget {
  final double rowHeight;
  final String activeIcon;
  final String inactiveIcon;
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _NavItem({
    required this.rowHeight,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? ColorManager.splashBGColor : ColorManager.hintTextColor;
    final effectiveColor = enabled ? color : color.withOpacity(0.5);

    return SizedBox(
      height: rowHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    selected ? activeIcon : inactiveIcon,
                    width: 26,
                    height: 26,
                    colorFilter: ColorFilter.mode(
                      effectiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: (selected ? getBoldStyle : getMediumStyle)(
                      color: effectiveColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

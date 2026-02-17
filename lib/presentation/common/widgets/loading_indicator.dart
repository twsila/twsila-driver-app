import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class EasyLoader extends StatefulWidget {
  const EasyLoader({
    Key? key,
  }) : super(key: key);

  @override
  State<EasyLoader> createState() => _EasyLoaderState();
}

class _EasyLoaderState extends State<EasyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop with subtle blur
        ModalBarrier(
          color: ColorManager.blackTextColor.withOpacity(0.4),
        ),
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.headersTextColor.withOpacity(0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: ColorManager.primary.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorManager.primary,
                        ),
                        backgroundColor: ColorManager.primary.withOpacity(0.15),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: Text(
                        AppStrings.loading.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

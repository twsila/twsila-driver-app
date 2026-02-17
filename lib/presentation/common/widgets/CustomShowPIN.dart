// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// import '../../../utils/resources/color_manager.dart';
//
// class CustomShowPinButton extends StatefulWidget {
//   final Function(bool) onChanged;
//   const CustomShowPinButton({Key? key, required this.onChanged})
//       : super(key: key);
//
//   @override
//   State<CustomShowPinButton> createState() => _CustomShowPinButtonState();
// }
//
// class _CustomShowPinButtonState extends State<CustomShowPinButton> {
//   bool isHidden = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isHidden = !isHidden;
//           widget.onChanged(isHidden);
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             color: ColorManager.primary,
//             borderRadius: const BorderRadius.all(Radius.circular(8)),
//             boxShadow: [
//               BoxShadow(
//                 color: ColorManager.primary.withOpacity(0.5),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: const Offset(0, 2),
//               )
//             ]),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 30,
//               height: 35,
//               child: isHidden
//                   ? Image.asset(
//                       ImageAssets.eye,
//                       color: Colors.white,
//                     )
//                   : Image.asset(ImageAssets.eye_closed, color: Colors.white),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               isHidden ? AppStrings.showCode.tr() : AppStrings.hideCode.tr(),
//               style: Theme.of(context)
//                   .textTheme
//                   .titleSmall!
//                   .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

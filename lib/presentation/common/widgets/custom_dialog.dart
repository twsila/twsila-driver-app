import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';
//
// class CustomDialog {
//   static showCustomDialog(BuildContext context, Widget dialogBody) {
//     showGeneralDialog(
//       context: context,
//       barrierLabel: "Barrier",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: Duration(milliseconds: 700),
//       pageBuilder: (_, __, ___) {
//         return Center(
//             child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10)),
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: AppSize.s8, vertical: AppSize.s60),
//                 child: SizedBox.expand(child: dialogBody)));
//       },
//       transitionBuilder: (_, anim, __, child) {
//         Tween<Offset> tween;
//         if (anim.status == AnimationStatus.reverse) {
//           tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
//         } else {
//           tween = Tween(begin: Offset(1, 0), end: Offset.zero);
//         }
//
//         return SlideTransition(
//           position: tween.animate(anim),
//           child: FadeTransition(
//             opacity: anim,
//             child: child,
//           ),
//         );
//       },
//     );
//   }
// }

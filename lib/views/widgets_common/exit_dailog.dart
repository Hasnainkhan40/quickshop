import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

Widget exitDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: Colors.transparent, // Glassmorphism effect
    elevation: 0,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Animated Icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder:
                      (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: redColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.exit_to_app_rounded,
                      size: 44,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 🔹 Title
                Text(
                  "Exit App?",
                  style: TextStyle(
                    fontFamily: bold,
                    fontSize: 22,
                    color: darkFontGrey,
                  ),
                ),
                const SizedBox(height: 10),

                // 🔹 Subtitle
                Text(
                  "Do you really want to close QuickShop?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: darkFontGrey.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),

                // 🔹 Buttons
                Row(
                  children: [
                    Expanded(
                      child: ourButton(
                        color: Colors.grey.shade200,
                        onPress: () => Navigator.pop(context),
                        textcolor: darkFontGrey,
                        title: "No",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ourButton(
                        color: redColor,
                        onPress: () => SystemNavigator.pop(),
                        textcolor: whiteColor,
                        title: "Yes",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

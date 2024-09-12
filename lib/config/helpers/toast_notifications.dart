import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

class ToastNotifications {
  static void showNotification({
    required BuildContext context,
    required String msg,
    ToastificationType type = ToastificationType.error,
  }) {
    toastification.show(
      context: context,
      title: Text(msg),
      alignment: Alignment.topCenter,
      type: type,
      style: ToastificationStyle.minimal,
      animationDuration: const Duration(milliseconds: 300),
      autoCloseDuration: const Duration(seconds: 3),
      icon: const Icon(Icons.error),
    );
  }
}

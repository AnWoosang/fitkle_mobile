import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toast message model
class ToastMessage {
  final String message;
  final ToastType type;
  final DateTime timestamp;

  ToastMessage({
    required this.message,
    this.type = ToastType.info,
  }) : timestamp = DateTime.now();
}

/// Toast types
enum ToastType {
  info,
  success,
  error,
  warning,
}

/// Toast notifier for managing toast messages
class ToastNotifier extends StateNotifier<ToastMessage?> {
  ToastNotifier() : super(null);

  void show(String message, {ToastType type = ToastType.info}) {
    state = ToastMessage(message: message, type: type);
  }

  void showError(String message) {
    show(message, type: ToastType.error);
  }

  void showSuccess(String message) {
    show(message, type: ToastType.success);
  }

  void showWarning(String message) {
    show(message, type: ToastType.warning);
  }

  void clear() {
    state = null;
  }
}

/// Global toast provider
final toastProvider = StateNotifierProvider<ToastNotifier, ToastMessage?>((ref) {
  return ToastNotifier();
});

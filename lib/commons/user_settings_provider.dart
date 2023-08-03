import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/models/user_model.dart';
import 'package:motiv8_ai/widgets/counter_widget.dart';

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsController, UserSettings>((ref) {
  // Fetch the initial state here
  UserSettings? initialState =
      ref.read(userControllerProvider.notifier).state.userSettings;
  // If initialState is null, provide a default UserSettings
  initialState ??= UserSettings(
    motivationalQuoteReminderFrequency: 1,
    motivationalQuoteStartTime: DateTime.now(),
    motivationalQuoteEndTime: DateTime.now().add(Duration(hours: 1)),
    // provide other default values
  );

  // Obtain the instance of UnsavedChangesNotifier
  final unsavedChangesNotifier = ref.read(hasUnsavedChangesProvider.notifier);

  return NotificationSettingsController(initialState, unsavedChangesNotifier);
});

final motivationalQuoteFrequencyProvider = Provider<int>((ref) {
  final counterParams = CounterProviderParams(type: CounterType.upToSeven);
  return ref.watch(counterProvider(counterParams)).state;
});

final motivationalQuoteStartDateProvider = Provider<DateTime>((ref) {
  final motivatonalStartDateParams = CounterProviderParams(
      type: CounterType.dateTime,
      startHour: 6,
      startMinute: 0,
      endHour: 24,
      endMinute: 00);
  return ref.watch(counterProvider(motivatonalStartDateParams)).state;
});

final motivationalQuoteEndDateProvider = Provider<DateTime>((ref) {
  final motivatonalEndDateParams = CounterProviderParams(
      type: CounterType.dateTime,
      startHour: 11,
      startMinute: 30,
      endHour: 23,
      endMinute: 30);
  return ref.watch(counterProvider(motivatonalEndDateParams)).state;
});
final hasUnsavedChangesProvider =
    StateNotifierProvider<UnsavedChangesNotifier, bool>((ref) {
  return UnsavedChangesNotifier();
});

class UnsavedChangesNotifier extends StateNotifier<bool> {
  UnsavedChangesNotifier() : super(false);

  void setUnsavedChanges(bool value) {
    state = value;
  }
}

class NotificationSettingsController extends StateNotifier<UserSettings> {
  final UnsavedChangesNotifier unsavedChangesNotifier;

  NotificationSettingsController(
      UserSettings settings, this.unsavedChangesNotifier)
      : super(settings);

  void updateMotivationalQuoteFrequency(int frequency) {
    state = state.copyWith(motivationalQuoteReminderFrequency: frequency);
    unsavedChangesNotifier.setUnsavedChanges(true);
  }

  void updateMotivationalQuoteStartTime(DateTime startTime) {
    state = state.copyWith(motivationalQuoteStartTime: startTime);
    unsavedChangesNotifier.setUnsavedChanges(true);
  }

  void updateMotivationalQuoteEndTime(DateTime endTime) {
    state = state.copyWith(motivationalQuoteEndTime: endTime);
    unsavedChangesNotifier.setUnsavedChanges(true);
  }

  void updateGoalCheckUpReminderTime(DateTime reminderTime) {
    state = state.copyWith(goalCheckUpReminderTime: reminderTime);
    unsavedChangesNotifier.setUnsavedChanges(true);
  }

  void updateTaskCheckUpReminderTime(DateTime reminderTime) {
    state = state.copyWith(taskCheckUpReminderTime: reminderTime);
    unsavedChangesNotifier.setUnsavedChanges(true);
  }

  void updateHasUnsavedChanges(bool val) {
    unsavedChangesNotifier.setUnsavedChanges(true);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/user/presentation/providers/state/settings_notifier.dart';
import '../../../features/user/presentation/providers/state/settings_state.dart';

final settingsFutureProvider = FutureProvider<SettingState>((ref) async {
  final themePref = ref.read(settingsNotifier.notifier);
  await themePref.loadPreferences();
  return ref.watch(settingsNotifier);
});

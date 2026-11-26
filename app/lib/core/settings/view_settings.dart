import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';

enum NowView {
  list('Liste'),
  tiles('Kacheln');

  const NowView(this.label);
  final String label;
}

const _nowViewKey = 'nowView';

class NowViewNotifier extends AsyncNotifier<NowView> {
  @override
  Future<NowView> build() async {
    final raw = await ref.watch(databaseProvider).readSetting(_nowViewKey);
    return NowView.values.firstWhere(
      (v) => v.name == raw,
      orElse: () => NowView.list,
    );
  }

  Future<void> set(NowView view) async {
    state = AsyncData(view);
    await ref.read(databaseProvider).writeSetting(_nowViewKey, view.name);
  }
}

final nowViewProvider = AsyncNotifierProvider<NowViewNotifier, NowView>(
  NowViewNotifier.new,
);

enum DayView {
  history('Verlauf'),
  timeline('Zeitstrahl');

  const DayView(this.label);
  final String label;
}

const _dayViewKey = 'dayView';

class DayViewNotifier extends AsyncNotifier<DayView> {
  @override
  Future<DayView> build() async {
    final raw = await ref.watch(databaseProvider).readSetting(_dayViewKey);
    return DayView.values.firstWhere(
      (v) => v.name == raw,
      orElse: () => DayView.history,
    );
  }

  Future<void> set(DayView view) async {
    state = AsyncData(view);
    await ref.read(databaseProvider).writeSetting(_dayViewKey, view.name);
  }
}

final dayViewProvider = AsyncNotifierProvider<DayViewNotifier, DayView>(
  DayViewNotifier.new,
);

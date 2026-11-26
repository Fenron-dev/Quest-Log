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

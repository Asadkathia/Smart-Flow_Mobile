import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/sync_processor.dart';
import 'connectivity_provider.dart';

part 'sync_provider.g.dart';

/// Auto-sync provider that triggers sync when online
@riverpod
class AutoSync extends _$AutoSync {
  @override
  FutureOr<void> build() {
    // Watch connectivity changes using the existing connectivity provider
    ref.listen(connectivityProvider, (previous, next) {
      if (next.isConnected) {
        // Trigger sync when coming online
        _triggerSync();
      }
    });
  }

  Future<void> _triggerSync() async {
    final processor = ref.read(syncProcessorProvider);
    await processor.processQueue();
    // Invalidate sync status to refresh UI
    ref.invalidate(syncStatusProvider);
  }

  /// Manual sync trigger
  Future<void> syncNow() async {
    await _triggerSync();
  }
}


import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/billing_settings_model.dart';
import '../../data/repositories/billing_repository.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

part 'billing_provider.g.dart';

/// Billing Settings Provider
/// 
/// Provides billing settings for the current organization.
@riverpod
Future<BillingSettingsModel> billingSettings(BillingSettingsRef ref) async {
  final repository = ref.watch(billingSettingsRepositoryProvider);
  final authState = ref.watch(authProvider);
  
  // Get orgId from current user
  final orgId = authState.user?.orgId;
  if (orgId == null) {
    throw Exception('Organization ID not found. User must be logged in.');
  }
  
  return await repository.getBillingSettings(orgId);
}

/// Update Billing Settings Provider
@riverpod
class UpdateBillingSettings extends _$UpdateBillingSettings {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Update billing settings
  Future<void> updateSettings(BillingSettingsModel settings) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(billingSettingsRepositoryProvider);
      await repository.updateBillingSettings(settings);
      
      // Invalidate billing settings to refresh
      ref.invalidate(billingSettingsProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}


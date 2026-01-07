import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/billing_settings_model.dart';
import '../../../../shared/data/remote/api_client.dart';
import '../../../../shared/data/local/offline_queue_service.dart';
import '../../../../shared/data/local/hive_service.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/config/app_config.dart';

/// Billing Settings Repository
/// 
/// Handles all billing settings-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class BillingSettingsRepository extends BaseRepository {
  BillingSettingsRepository(
    ApiClient apiClient,
    CacheService cache,
    OfflineQueueService offlineQueue, {
    bool? useMockData,
  }) : super(apiClient, cache, offlineQueue, useMockData: useMockData);

  /// Get billing settings for an organization - unified pattern
  Future<BillingSettingsModel> getBillingSettings(String orgId) async {
    final cacheKey = '${StorageKeys.billingSettingsCache}_$orgId';
    
    return await fetch<BillingSettingsModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response = await apiClient.get('/v1/org/$orgId/billing-settings');
        return BillingSettingsModel.fromJson(response.data);
      },
      fromJson: (data) => BillingSettingsModel.fromJson(data as Map<String, dynamic>),
      mockData: AppConfig.shouldUseMockData
          ? () => BillingSettingsModel(
                id: 'billing_1',
                orgId: orgId,
                serviceCallFee: 100.0,
                taxRate: 0.082, // 8.2% default
                currency: 'USD',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
          : null,
    );
  }

  /// Update billing settings - with offline support
  Future<BillingSettingsModel> updateBillingSettings(
    BillingSettingsModel settings,
  ) async {
    return await mutate<BillingSettingsModel>(
      cacheKey: '${StorageKeys.billingSettingsCache}_${settings.orgId}',
      apiCall: () async {
        final response = await apiClient.patch(
          '/v1/org/${settings.orgId}/billing-settings',
          data: settings.toJson(),
        );
        return BillingSettingsModel.fromJson(response.data);
      },
      actionType: PendingActionType.updateBillingSettings,
      actionData: {
        'org_id': settings.orgId,
        'settings': settings.toJson(),
      },
      fromJson: (data) => BillingSettingsModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => settings,
    );
  }
}

/// Billing Settings Repository Provider
final billingSettingsRepositoryProvider = Provider<BillingSettingsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cache = ref.watch(quotesCacheProvider); // Reuse quotes cache for now
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  
  return BillingSettingsRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: AppConfig.shouldUseMockData,
  );
});




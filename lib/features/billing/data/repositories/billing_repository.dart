import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/billing_settings_model.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/local/offline_queue_service.dart';
import 'package:smartflowpro/shared/data/local/hive_service.dart';
import 'package:smartflowpro/shared/data/repositories/base_repository.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/config/app_config.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';

/// Billing Settings Repository
/// 
/// Handles all billing settings-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class BillingSettingsRepository extends BaseRepository {
  BillingSettingsRepository(
    super.apiClient,
    super.cache,
    super.offlineQueue, {
    super.useMockData,
  });

  /// Get billing settings for an organization - unified pattern
  Future<BillingSettingsModel> getBillingSettings(String orgId) async {
    final cacheKey = '${StorageKeys.billingSettingsCache}_$orgId';
    
    return await fetch<BillingSettingsModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        // Use standard REST API instead of Edge Function
        // Table: billing_settings
        final url = '${ApiEndpoints.restApiBaseFull}/billing_settings?org_id=eq.$orgId&select=*';
        
        try {
          final response = await apiClient.get(url);
          
          if (response.data is List && (response.data as List).isNotEmpty) {
            return BillingSettingsModel.fromJson(response.data[0] as Map<String, dynamic>);
          }
          
          // Return defaults if no settings found
          return BillingSettingsModel(
            id: 'default',
            orgId: orgId,
            serviceCallFee: 75.0,
            taxRate: 0.082,
            currency: 'USD',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        } catch (e) {
            // Default on error to prevent blocking
            return BillingSettingsModel(
            id: 'default_error',
            orgId: orgId,
            serviceCallFee: 75.0,
            taxRate: 0.082,
            currency: 'USD',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
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
  final cache = ref.watch(billingCacheProvider); // Use dedicated billing cache
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  
  return BillingSettingsRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: AppConfig.shouldUseMockData,
  );
});




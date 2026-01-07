// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billingSettingsHash() => r'42c0b6398e57cf8dd3300f4ede9d74c2cb18f4e1';

/// Billing Settings Provider
///
/// Provides billing settings for the current organization.
///
/// Copied from [billingSettings].
@ProviderFor(billingSettings)
final billingSettingsProvider =
    AutoDisposeFutureProvider<BillingSettingsModel>.internal(
  billingSettings,
  name: r'billingSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billingSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingSettingsRef = AutoDisposeFutureProviderRef<BillingSettingsModel>;
String _$updateBillingSettingsHash() =>
    r'a7717164f42ff43858b734c7a53fd593013fa5ff';

/// Update Billing Settings Provider
///
/// Copied from [UpdateBillingSettings].
@ProviderFor(UpdateBillingSettings)
final updateBillingSettingsProvider =
    AutoDisposeAsyncNotifierProvider<UpdateBillingSettings, void>.internal(
  UpdateBillingSettings.new,
  name: r'updateBillingSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateBillingSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateBillingSettings = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

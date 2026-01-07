// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoSyncHash() => r'667700d2bb5987ab1ad9c68429edb4203bd779a7';

/// Auto-sync provider that triggers sync when online
///
/// Copied from [AutoSync].
@ProviderFor(AutoSync)
final autoSyncProvider =
    AutoDisposeAsyncNotifierProvider<AutoSync, void>.internal(
  AutoSync.new,
  name: r'autoSyncProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$autoSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoSync = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

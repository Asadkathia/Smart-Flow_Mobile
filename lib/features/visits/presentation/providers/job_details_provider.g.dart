// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobDetailsTabHash() => r'e70a947a852728875b6215ab9a5343364fa4ce16';

/// Provider for managing the selected tab in Job Details screen
///
/// Copied from [JobDetailsTab].
@ProviderFor(JobDetailsTab)
final jobDetailsTabProvider =
    AutoDisposeNotifierProvider<JobDetailsTab, int>.internal(
  JobDetailsTab.new,
  name: r'jobDetailsTabProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jobDetailsTabHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JobDetailsTab = AutoDisposeNotifier<int>;
String _$selectedVisitIdHash() => r'59f7687898b157eed98badc59db734a44316e785';

/// Provider for storing the current visit ID in Job Details screen
///
/// Copied from [SelectedVisitId].
@ProviderFor(SelectedVisitId)
final selectedVisitIdProvider =
    AutoDisposeNotifierProvider<SelectedVisitId, String?>.internal(
  SelectedVisitId.new,
  name: r'selectedVisitIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedVisitIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedVisitId = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

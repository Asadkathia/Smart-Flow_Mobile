// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_visits_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completedVisitsHash() => r'b8084e1af51b75dc46a1a6ae0a1181f44e577b9d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Completed Visits Provider
///
/// Provides a list of completed visits with optional date filtering.
///
/// Copied from [completedVisits].
@ProviderFor(completedVisits)
const completedVisitsProvider = CompletedVisitsFamily();

/// Completed Visits Provider
///
/// Provides a list of completed visits with optional date filtering.
///
/// Copied from [completedVisits].
class CompletedVisitsFamily extends Family<AsyncValue<List<VisitModel>>> {
  /// Completed Visits Provider
  ///
  /// Provides a list of completed visits with optional date filtering.
  ///
  /// Copied from [completedVisits].
  const CompletedVisitsFamily();

  /// Completed Visits Provider
  ///
  /// Provides a list of completed visits with optional date filtering.
  ///
  /// Copied from [completedVisits].
  CompletedVisitsProvider call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CompletedVisitsProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  CompletedVisitsProvider getProviderOverride(
    covariant CompletedVisitsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'completedVisitsProvider';
}

/// Completed Visits Provider
///
/// Provides a list of completed visits with optional date filtering.
///
/// Copied from [completedVisits].
class CompletedVisitsProvider
    extends AutoDisposeFutureProvider<List<VisitModel>> {
  /// Completed Visits Provider
  ///
  /// Provides a list of completed visits with optional date filtering.
  ///
  /// Copied from [completedVisits].
  CompletedVisitsProvider({
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          (ref) => completedVisits(
            ref as CompletedVisitsRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: completedVisitsProvider,
          name: r'completedVisitsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$completedVisitsHash,
          dependencies: CompletedVisitsFamily._dependencies,
          allTransitiveDependencies:
              CompletedVisitsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  CompletedVisitsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<List<VisitModel>> Function(CompletedVisitsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompletedVisitsProvider._internal(
        (ref) => create(ref as CompletedVisitsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<VisitModel>> createElement() {
    return _CompletedVisitsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedVisitsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompletedVisitsRef on AutoDisposeFutureProviderRef<List<VisitModel>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _CompletedVisitsProviderElement
    extends AutoDisposeFutureProviderElement<List<VisitModel>>
    with CompletedVisitsRef {
  _CompletedVisitsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as CompletedVisitsProvider).startDate;
  @override
  DateTime? get endDate => (origin as CompletedVisitsProvider).endDate;
}

String _$completedVisitsNotifierHash() =>
    r'f5f23e383eca6d2b36df28a7f8cb6880fe51c82e';

/// Completed Visits Notifier
///
/// Manages state for completed visits with filtering capabilities.
///
/// Copied from [CompletedVisitsNotifier].
@ProviderFor(CompletedVisitsNotifier)
final completedVisitsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CompletedVisitsNotifier, List<VisitModel>>.internal(
  CompletedVisitsNotifier.new,
  name: r'completedVisitsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedVisitsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompletedVisitsNotifier = AutoDisposeAsyncNotifier<List<VisitModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

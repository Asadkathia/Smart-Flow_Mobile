// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visits_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredVisitsHash() => r'15f9d08422f830d520a1126ad26dd6f44831a99e';

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

/// Filtered Visits Provider
///
/// Provides visits filtered by status.
///
/// Copied from [filteredVisits].
@ProviderFor(filteredVisits)
const filteredVisitsProvider = FilteredVisitsFamily();

/// Filtered Visits Provider
///
/// Provides visits filtered by status.
///
/// Copied from [filteredVisits].
class FilteredVisitsFamily extends Family<List<VisitModel>> {
  /// Filtered Visits Provider
  ///
  /// Provides visits filtered by status.
  ///
  /// Copied from [filteredVisits].
  const FilteredVisitsFamily();

  /// Filtered Visits Provider
  ///
  /// Provides visits filtered by status.
  ///
  /// Copied from [filteredVisits].
  FilteredVisitsProvider call(
    VisitStatus? status,
  ) {
    return FilteredVisitsProvider(
      status,
    );
  }

  @override
  FilteredVisitsProvider getProviderOverride(
    covariant FilteredVisitsProvider provider,
  ) {
    return call(
      provider.status,
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
  String? get name => r'filteredVisitsProvider';
}

/// Filtered Visits Provider
///
/// Provides visits filtered by status.
///
/// Copied from [filteredVisits].
class FilteredVisitsProvider extends AutoDisposeProvider<List<VisitModel>> {
  /// Filtered Visits Provider
  ///
  /// Provides visits filtered by status.
  ///
  /// Copied from [filteredVisits].
  FilteredVisitsProvider(
    VisitStatus? status,
  ) : this._internal(
          (ref) => filteredVisits(
            ref as FilteredVisitsRef,
            status,
          ),
          from: filteredVisitsProvider,
          name: r'filteredVisitsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredVisitsHash,
          dependencies: FilteredVisitsFamily._dependencies,
          allTransitiveDependencies:
              FilteredVisitsFamily._allTransitiveDependencies,
          status: status,
        );

  FilteredVisitsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final VisitStatus? status;

  @override
  Override overrideWith(
    List<VisitModel> Function(FilteredVisitsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredVisitsProvider._internal(
        (ref) => create(ref as FilteredVisitsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<VisitModel>> createElement() {
    return _FilteredVisitsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredVisitsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredVisitsRef on AutoDisposeProviderRef<List<VisitModel>> {
  /// The parameter `status` of this provider.
  VisitStatus? get status;
}

class _FilteredVisitsProviderElement
    extends AutoDisposeProviderElement<List<VisitModel>>
    with FilteredVisitsRef {
  _FilteredVisitsProviderElement(super.provider);

  @override
  VisitStatus? get status => (origin as FilteredVisitsProvider).status;
}

String _$activeVisitHash() => r'294f44772265b77d4e2645bebb4ee46bd7d0ce2d';

/// Active Visit Provider
///
/// Provides the currently active (in progress) visit, if any.
///
/// Copied from [activeVisit].
@ProviderFor(activeVisit)
final activeVisitProvider = AutoDisposeProvider<VisitModel?>.internal(
  activeVisit,
  name: r'activeVisitProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeVisitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveVisitRef = AutoDisposeProviderRef<VisitModel?>;
String _$todayVisitsHash() => r'aa6a851684244b7226df8eb906f6ddc6ea39c580';

/// Today's Visits Provider
///
/// Provides a list of visits scheduled for today.
/// Handles loading, error, and refresh states.
///
/// Copied from [TodayVisits].
@ProviderFor(TodayVisits)
final todayVisitsProvider =
    AutoDisposeAsyncNotifierProvider<TodayVisits, List<VisitModel>>.internal(
  TodayVisits.new,
  name: r'todayVisitsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayVisitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayVisits = AutoDisposeAsyncNotifier<List<VisitModel>>;
String _$visitDetailsHash() => r'76e28706e8b53878072957f3ec9566839bb4724f';

abstract class _$VisitDetails
    extends BuildlessAutoDisposeAsyncNotifier<VisitModel> {
  late final String visitId;

  FutureOr<VisitModel> build(
    String visitId,
  );
}

/// Single Visit Details Provider
///
/// Provides details for a specific visit by ID.
///
/// Copied from [VisitDetails].
@ProviderFor(VisitDetails)
const visitDetailsProvider = VisitDetailsFamily();

/// Single Visit Details Provider
///
/// Provides details for a specific visit by ID.
///
/// Copied from [VisitDetails].
class VisitDetailsFamily extends Family<AsyncValue<VisitModel>> {
  /// Single Visit Details Provider
  ///
  /// Provides details for a specific visit by ID.
  ///
  /// Copied from [VisitDetails].
  const VisitDetailsFamily();

  /// Single Visit Details Provider
  ///
  /// Provides details for a specific visit by ID.
  ///
  /// Copied from [VisitDetails].
  VisitDetailsProvider call(
    String visitId,
  ) {
    return VisitDetailsProvider(
      visitId,
    );
  }

  @override
  VisitDetailsProvider getProviderOverride(
    covariant VisitDetailsProvider provider,
  ) {
    return call(
      provider.visitId,
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
  String? get name => r'visitDetailsProvider';
}

/// Single Visit Details Provider
///
/// Provides details for a specific visit by ID.
///
/// Copied from [VisitDetails].
class VisitDetailsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VisitDetails, VisitModel> {
  /// Single Visit Details Provider
  ///
  /// Provides details for a specific visit by ID.
  ///
  /// Copied from [VisitDetails].
  VisitDetailsProvider(
    String visitId,
  ) : this._internal(
          () => VisitDetails()..visitId = visitId,
          from: visitDetailsProvider,
          name: r'visitDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitDetailsHash,
          dependencies: VisitDetailsFamily._dependencies,
          allTransitiveDependencies:
              VisitDetailsFamily._allTransitiveDependencies,
          visitId: visitId,
        );

  VisitDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.visitId,
  }) : super.internal();

  final String visitId;

  @override
  FutureOr<VisitModel> runNotifierBuild(
    covariant VisitDetails notifier,
  ) {
    return notifier.build(
      visitId,
    );
  }

  @override
  Override overrideWith(VisitDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: VisitDetailsProvider._internal(
        () => create()..visitId = visitId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        visitId: visitId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VisitDetails, VisitModel>
      createElement() {
    return _VisitDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitDetailsProvider && other.visitId == visitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, visitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VisitDetailsRef on AutoDisposeAsyncNotifierProviderRef<VisitModel> {
  /// The parameter `visitId` of this provider.
  String get visitId;
}

class _VisitDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VisitDetails, VisitModel>
    with VisitDetailsRef {
  _VisitDetailsProviderElement(super.provider);

  @override
  String get visitId => (origin as VisitDetailsProvider).visitId;
}

String _$visitNotesHash() => r'c96fb91131b242536293f52f443f7023f60db136';

abstract class _$VisitNotes
    extends BuildlessAutoDisposeAsyncNotifier<List<NoteModel>> {
  late final String visitId;

  FutureOr<List<NoteModel>> build(
    String visitId,
  );
}

/// Visit Notes Provider
///
/// Provides notes for a specific visit.
///
/// Copied from [VisitNotes].
@ProviderFor(VisitNotes)
const visitNotesProvider = VisitNotesFamily();

/// Visit Notes Provider
///
/// Provides notes for a specific visit.
///
/// Copied from [VisitNotes].
class VisitNotesFamily extends Family<AsyncValue<List<NoteModel>>> {
  /// Visit Notes Provider
  ///
  /// Provides notes for a specific visit.
  ///
  /// Copied from [VisitNotes].
  const VisitNotesFamily();

  /// Visit Notes Provider
  ///
  /// Provides notes for a specific visit.
  ///
  /// Copied from [VisitNotes].
  VisitNotesProvider call(
    String visitId,
  ) {
    return VisitNotesProvider(
      visitId,
    );
  }

  @override
  VisitNotesProvider getProviderOverride(
    covariant VisitNotesProvider provider,
  ) {
    return call(
      provider.visitId,
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
  String? get name => r'visitNotesProvider';
}

/// Visit Notes Provider
///
/// Provides notes for a specific visit.
///
/// Copied from [VisitNotes].
class VisitNotesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VisitNotes, List<NoteModel>> {
  /// Visit Notes Provider
  ///
  /// Provides notes for a specific visit.
  ///
  /// Copied from [VisitNotes].
  VisitNotesProvider(
    String visitId,
  ) : this._internal(
          () => VisitNotes()..visitId = visitId,
          from: visitNotesProvider,
          name: r'visitNotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$visitNotesHash,
          dependencies: VisitNotesFamily._dependencies,
          allTransitiveDependencies:
              VisitNotesFamily._allTransitiveDependencies,
          visitId: visitId,
        );

  VisitNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.visitId,
  }) : super.internal();

  final String visitId;

  @override
  FutureOr<List<NoteModel>> runNotifierBuild(
    covariant VisitNotes notifier,
  ) {
    return notifier.build(
      visitId,
    );
  }

  @override
  Override overrideWith(VisitNotes Function() create) {
    return ProviderOverride(
      origin: this,
      override: VisitNotesProvider._internal(
        () => create()..visitId = visitId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        visitId: visitId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VisitNotes, List<NoteModel>>
      createElement() {
    return _VisitNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VisitNotesProvider && other.visitId == visitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, visitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VisitNotesRef on AutoDisposeAsyncNotifierProviderRef<List<NoteModel>> {
  /// The parameter `visitId` of this provider.
  String get visitId;
}

class _VisitNotesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VisitNotes, List<NoteModel>>
    with VisitNotesRef {
  _VisitNotesProviderElement(super.provider);

  @override
  String get visitId => (origin as VisitNotesProvider).visitId;
}

String _$visitActionsHash() => r'9a107cce3a1bbf20717f07ad8504ca2b7421a00f';

/// Visit Actions Provider
///
/// Handles visit actions (start, pause, complete) with loading states.
///
/// Copied from [VisitActions].
@ProviderFor(VisitActions)
final visitActionsProvider =
    AutoDisposeAsyncNotifierProvider<VisitActions, void>.internal(
  VisitActions.new,
  name: r'visitActionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$visitActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VisitActions = AutoDisposeAsyncNotifier<void>;
String _$selectedVisitHash() => r'9d147add3eea403e682878d97d5e0f5005a7156a';

/// Selected Visit Provider
///
/// Tracks the currently selected visit ID.
///
/// Copied from [SelectedVisit].
@ProviderFor(SelectedVisit)
final selectedVisitProvider =
    AutoDisposeNotifierProvider<SelectedVisit, String?>.internal(
  SelectedVisit.new,
  name: r'selectedVisitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedVisitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedVisit = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

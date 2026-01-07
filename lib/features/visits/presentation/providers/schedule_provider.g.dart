// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleMonthHash() => r'484d0c2d485ceb17665a57b882b78199434c0bfc';

/// Schedule Month Provider
///
/// Provides the current month name for display.
///
/// Copied from [scheduleMonth].
@ProviderFor(scheduleMonth)
final scheduleMonthProvider = AutoDisposeProvider<String>.internal(
  scheduleMonth,
  name: r'scheduleMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduleMonthRef = AutoDisposeProviderRef<String>;
String _$scheduleVisitsForDateHash() =>
    r'd187d7241a32cd4f1ceab6889709d6906baab7d7';

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

/// Visits for Selected Date Provider
///
/// Provides visits filtered by the selected date.
///
/// Copied from [scheduleVisitsForDate].
@ProviderFor(scheduleVisitsForDate)
const scheduleVisitsForDateProvider = ScheduleVisitsForDateFamily();

/// Visits for Selected Date Provider
///
/// Provides visits filtered by the selected date.
///
/// Copied from [scheduleVisitsForDate].
class ScheduleVisitsForDateFamily extends Family<AsyncValue<List<VisitModel>>> {
  /// Visits for Selected Date Provider
  ///
  /// Provides visits filtered by the selected date.
  ///
  /// Copied from [scheduleVisitsForDate].
  const ScheduleVisitsForDateFamily();

  /// Visits for Selected Date Provider
  ///
  /// Provides visits filtered by the selected date.
  ///
  /// Copied from [scheduleVisitsForDate].
  ScheduleVisitsForDateProvider call(
    DateTime date,
  ) {
    return ScheduleVisitsForDateProvider(
      date,
    );
  }

  @override
  ScheduleVisitsForDateProvider getProviderOverride(
    covariant ScheduleVisitsForDateProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'scheduleVisitsForDateProvider';
}

/// Visits for Selected Date Provider
///
/// Provides visits filtered by the selected date.
///
/// Copied from [scheduleVisitsForDate].
class ScheduleVisitsForDateProvider
    extends AutoDisposeFutureProvider<List<VisitModel>> {
  /// Visits for Selected Date Provider
  ///
  /// Provides visits filtered by the selected date.
  ///
  /// Copied from [scheduleVisitsForDate].
  ScheduleVisitsForDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => scheduleVisitsForDate(
            ref as ScheduleVisitsForDateRef,
            date,
          ),
          from: scheduleVisitsForDateProvider,
          name: r'scheduleVisitsForDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scheduleVisitsForDateHash,
          dependencies: ScheduleVisitsForDateFamily._dependencies,
          allTransitiveDependencies:
              ScheduleVisitsForDateFamily._allTransitiveDependencies,
          date: date,
        );

  ScheduleVisitsForDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<List<VisitModel>> Function(ScheduleVisitsForDateRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScheduleVisitsForDateProvider._internal(
        (ref) => create(ref as ScheduleVisitsForDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<VisitModel>> createElement() {
    return _ScheduleVisitsForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleVisitsForDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScheduleVisitsForDateRef
    on AutoDisposeFutureProviderRef<List<VisitModel>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _ScheduleVisitsForDateProviderElement
    extends AutoDisposeFutureProviderElement<List<VisitModel>>
    with ScheduleVisitsForDateRef {
  _ScheduleVisitsForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as ScheduleVisitsForDateProvider).date;
}

String _$scheduleVisitsForDateRangeHash() =>
    r'd37944f6fe5538179094fefcc1a0c5f086187484';

/// Visits for Date Range Provider
///
/// Provides visits filtered by a date range (for week/month views).
///
/// Copied from [scheduleVisitsForDateRange].
@ProviderFor(scheduleVisitsForDateRange)
const scheduleVisitsForDateRangeProvider = ScheduleVisitsForDateRangeFamily();

/// Visits for Date Range Provider
///
/// Provides visits filtered by a date range (for week/month views).
///
/// Copied from [scheduleVisitsForDateRange].
class ScheduleVisitsForDateRangeFamily
    extends Family<AsyncValue<List<VisitModel>>> {
  /// Visits for Date Range Provider
  ///
  /// Provides visits filtered by a date range (for week/month views).
  ///
  /// Copied from [scheduleVisitsForDateRange].
  const ScheduleVisitsForDateRangeFamily();

  /// Visits for Date Range Provider
  ///
  /// Provides visits filtered by a date range (for week/month views).
  ///
  /// Copied from [scheduleVisitsForDateRange].
  ScheduleVisitsForDateRangeProvider call(
    ({DateTime end, DateTime start}) dateRange,
  ) {
    return ScheduleVisitsForDateRangeProvider(
      dateRange,
    );
  }

  @override
  ScheduleVisitsForDateRangeProvider getProviderOverride(
    covariant ScheduleVisitsForDateRangeProvider provider,
  ) {
    return call(
      provider.dateRange,
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
  String? get name => r'scheduleVisitsForDateRangeProvider';
}

/// Visits for Date Range Provider
///
/// Provides visits filtered by a date range (for week/month views).
///
/// Copied from [scheduleVisitsForDateRange].
class ScheduleVisitsForDateRangeProvider
    extends AutoDisposeFutureProvider<List<VisitModel>> {
  /// Visits for Date Range Provider
  ///
  /// Provides visits filtered by a date range (for week/month views).
  ///
  /// Copied from [scheduleVisitsForDateRange].
  ScheduleVisitsForDateRangeProvider(
    ({DateTime end, DateTime start}) dateRange,
  ) : this._internal(
          (ref) => scheduleVisitsForDateRange(
            ref as ScheduleVisitsForDateRangeRef,
            dateRange,
          ),
          from: scheduleVisitsForDateRangeProvider,
          name: r'scheduleVisitsForDateRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scheduleVisitsForDateRangeHash,
          dependencies: ScheduleVisitsForDateRangeFamily._dependencies,
          allTransitiveDependencies:
              ScheduleVisitsForDateRangeFamily._allTransitiveDependencies,
          dateRange: dateRange,
        );

  ScheduleVisitsForDateRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dateRange,
  }) : super.internal();

  final ({DateTime end, DateTime start}) dateRange;

  @override
  Override overrideWith(
    FutureOr<List<VisitModel>> Function(ScheduleVisitsForDateRangeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScheduleVisitsForDateRangeProvider._internal(
        (ref) => create(ref as ScheduleVisitsForDateRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<VisitModel>> createElement() {
    return _ScheduleVisitsForDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleVisitsForDateRangeProvider &&
        other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScheduleVisitsForDateRangeRef
    on AutoDisposeFutureProviderRef<List<VisitModel>> {
  /// The parameter `dateRange` of this provider.
  ({DateTime end, DateTime start}) get dateRange;
}

class _ScheduleVisitsForDateRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<VisitModel>>
    with ScheduleVisitsForDateRangeRef {
  _ScheduleVisitsForDateRangeProviderElement(super.provider);

  @override
  ({DateTime end, DateTime start}) get dateRange =>
      (origin as ScheduleVisitsForDateRangeProvider).dateRange;
}

String _$scheduleTabHash() => r'50cd462372d32f5e6d24daf0d33e4254d026f2ef';

/// Schedule Tab Provider
///
/// Manages the currently selected tab in the Schedule screen.
///
/// Copied from [ScheduleTab].
@ProviderFor(ScheduleTab)
final scheduleTabProvider =
    AutoDisposeNotifierProvider<ScheduleTab, int>.internal(
  ScheduleTab.new,
  name: r'scheduleTabProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scheduleTabHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleTab = AutoDisposeNotifier<int>;
String _$scheduleSelectedDateHash() =>
    r'1f29cba888db3d92ef1b1baab49df109d685755d';

/// Schedule Selected Date Provider
///
/// Manages the currently selected date in the Schedule screen.
///
/// Copied from [ScheduleSelectedDate].
@ProviderFor(ScheduleSelectedDate)
final scheduleSelectedDateProvider =
    AutoDisposeNotifierProvider<ScheduleSelectedDate, DateTime>.internal(
  ScheduleSelectedDate.new,
  name: r'scheduleSelectedDateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleSelectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleSelectedDate = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/visit_model.dart';
import '../../data/repositories/visit_repository.dart';

part 'completed_visits_provider.g.dart';

/// Completed Visits Provider
/// 
/// Provides a list of completed visits with optional date filtering.
@riverpod
Future<List<VisitModel>> completedVisits(
  CompletedVisitsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.read(visitRepositoryProvider);
  return repository.getCompletedVisits(
    startDate: startDate,
    endDate: endDate,
  );
}

/// Completed Visits Notifier
/// 
/// Manages state for completed visits with filtering capabilities.
@riverpod
class CompletedVisitsNotifier extends _$CompletedVisitsNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  @override
  Future<List<VisitModel>> build() async {
    return _loadVisits();
  }

  Future<List<VisitModel>> _loadVisits() async {
    final repository = ref.read(visitRepositoryProvider);
    final visits = await repository.getCompletedVisits(
      startDate: _startDate,
      endDate: _endDate,
    );

    // Apply search filter if query is not empty
    if (_searchQuery.isEmpty) {
      return visits;
    }

    return visits.where((visit) {
      final query = _searchQuery.toLowerCase();
      return visit.customerName?.toLowerCase().contains(query) == true ||
          visit.title?.toLowerCase().contains(query) == true ||
          visit.address?.toLowerCase().contains(query) == true;
    }).toList();
  }

  /// Set date filter
  void setDateFilter({DateTime? startDate, DateTime? endDate}) {
    _startDate = startDate;
    _endDate = endDate;
    ref.invalidateSelf();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    ref.invalidateSelf();
  }

  /// Refresh visits
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadVisits());
  }

  /// Clear filters
  void clearFilters() {
    _startDate = null;
    _endDate = null;
    _searchQuery = '';
    ref.invalidateSelf();
  }
}

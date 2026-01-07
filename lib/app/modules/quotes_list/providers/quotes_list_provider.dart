import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/quotes/data/models/quote_model.dart';

part 'quotes_list_provider.g.dart';

/// Quote Item Model
class QuoteItem {
  final String id;
  final String clientName;
  final String jobTitle;
  final double total;
  final DateTime date;
  final QuoteStatus status;

  QuoteItem({
    required this.id,
    required this.clientName,
    required this.jobTitle,
    required this.total,
    required this.date,
    required this.status,
  });
}

/// Quotes List Provider
/// 
/// Manages the list of quotes with loading and refresh states.
@riverpod
class QuotesList extends _$QuotesList {
  @override
  Future<List<QuoteItem>> build() async {
    // TODO: Replace with actual API call when backend is ready
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockQuotes();
  }

  /// Get mock quotes for development/UI testing
  List<QuoteItem> _getMockQuotes() {
    return [
      QuoteItem(
        id: 'Q-1001',
        clientName: 'John Doe',
        jobTitle: 'HVAC Tune-up',
        total: 378.98,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: QuoteStatus.finalized,
      ),
      QuoteItem(
        id: 'Q-1002',
        clientName: 'John Doe',
        jobTitle: 'Filter Replacement',
        total: 119.98,
        date: DateTime.now().subtract(const Duration(days: 7)),
        status: QuoteStatus.draft,
      ),
      QuoteItem(
        id: 'Q-1003',
        clientName: 'John Doe',
        jobTitle: 'Duct Repair',
        total: 564.50,
        date: DateTime.now().subtract(const Duration(days: 20)),
        status: QuoteStatus.invoiced,
      ),
    ];
  }

  /// Refresh quotes list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 600));
      return _getMockQuotes();
    });
  }
}


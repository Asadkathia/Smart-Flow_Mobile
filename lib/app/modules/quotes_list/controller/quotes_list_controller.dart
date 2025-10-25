import '../../../export/exports.dart';

class QuotesListController extends GetxController {
  final RxBool isLoading = false.obs;

  // Demo quotes; replace with API later
  final RxList<QuoteItem> quotes = <QuoteItem>[
    QuoteItem(id: 'Q-1001', clientName: 'John Doe', jobTitle: 'HVAC Tune-up', total: 378.98, date: DateTime.now().subtract(const Duration(days: 1)), status: QuoteStatus.sent),
    QuoteItem(id: 'Q-1002', clientName: 'John Doe', jobTitle: 'Filter Replacement', total: 119.98, date: DateTime.now().subtract(const Duration(days: 7)), status: QuoteStatus.draft),
    QuoteItem(id: 'Q-1003', clientName: 'John Doe', jobTitle: 'Duct Repair', total: 564.50, date: DateTime.now().subtract(const Duration(days: 20)), status: QuoteStatus.accepted),
  ].obs;

  void refreshQuotes() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
  }
}

enum QuoteStatus { draft, sent, accepted, declined }

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

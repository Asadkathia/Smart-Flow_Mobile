import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_details_provider.g.dart';

/// Provider for managing the selected tab in Job Details screen
@riverpod
class JobDetailsTab extends _$JobDetailsTab {
  @override
  int build() {
    return 0; // Default to Visit tab
  }

  void setTab(int index) {
    state = index;
  }
}

/// Provider for storing the current visit ID in Job Details screen
@riverpod
class SelectedVisitId extends _$SelectedVisitId {
  @override
  String? build() {
    return null;
  }

  void setVisitId(String visitId) {
    state = visitId;
  }

  void clear() {
    state = null;
  }
}


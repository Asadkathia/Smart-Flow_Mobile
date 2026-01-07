import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

/// Pagination Information Model
/// 
/// Represents pagination metadata for API responses.
@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required int page,
    required int pageSize,
    required int totalItems,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}

/// Paginated Response Model
/// 
/// Generic model for paginated API responses.
/// Note: For JSON serialization, use concrete types or manual serialization.
class PaginatedResponse<T> {
  final List<T> data;
  final PageInfo pageInfo;

  const PaginatedResponse({
    required this.data,
    required this.pageInfo,
  });

  /// Create from JSON with custom deserializer
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      pageInfo: PageInfo.fromJson(json['page_info'] as Map<String, dynamic>),
    );
  }

  /// Convert to JSON with custom serializer
  Map<String, dynamic> toJson(Object Function(T) toJsonT) {
    return {
      'data': data.map((item) => toJsonT(item)).toList(),
      'page_info': pageInfo.toJson(),
    };
  }
}

/// Pagination State
/// 
/// Manages pagination state for list views.
class PaginationState {
  final int currentPage;
  final int pageSize;
  final bool isLoading;
  final bool hasMore;
  final bool isLoadingMore;
  final String? error;

  const PaginationState({
    this.currentPage = 1,
    this.pageSize = 20,
    this.isLoading = false,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.error,
  });

  PaginationState copyWith({
    int? currentPage,
    int? pageSize,
    bool? isLoading,
    bool? hasMore,
    bool? isLoadingMore,
    String? error,
  }) {
    return PaginationState(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
    );
  }

  /// Reset pagination to initial state
  PaginationState reset() {
    return const PaginationState();
  }

  /// Move to next page
  PaginationState nextPage() {
    return copyWith(currentPage: currentPage + 1);
  }

  /// Check if can load more
  bool get canLoadMore => hasMore && !isLoadingMore && !isLoading;
}


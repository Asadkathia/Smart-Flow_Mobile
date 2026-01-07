// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotesListHash() => r'bb2d974d1e5c329899747815af4f6f396d661d18';

/// Quotes List Provider
///
/// Manages the list of quotes with loading and refresh states.
///
/// Copied from [QuotesList].
@ProviderFor(QuotesList)
final quotesListProvider =
    AutoDisposeAsyncNotifierProvider<QuotesList, List<QuoteItem>>.internal(
  QuotesList.new,
  name: r'quotesListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$quotesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuotesList = AutoDisposeAsyncNotifier<List<QuoteItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

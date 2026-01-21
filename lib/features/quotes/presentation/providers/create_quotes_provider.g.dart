// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_quotes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createQuotesHash() => r'c75ba31b2c64861ff2c072de8353f2ec83d50876';

/// Create Quotes Provider
///
/// Manages quote creation state including services, materials, tax, and message.
/// Automatically adds and locks service call fee per PRD requirements.
///
/// Copied from [CreateQuotes].
@ProviderFor(CreateQuotes)
final createQuotesProvider =
    AutoDisposeNotifierProvider<CreateQuotes, CreateQuotesState>.internal(
  CreateQuotes.new,
  name: r'createQuotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$createQuotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateQuotes = AutoDisposeNotifier<CreateQuotesState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

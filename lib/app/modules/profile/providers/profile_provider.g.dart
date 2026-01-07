// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileEditingHash() => r'93d5b9de4c70c2626f0931c666288cfa1962a6fa';

/// Profile Editing State Provider
///
/// Manages whether the profile is in edit mode.
///
/// Copied from [ProfileEditing].
@ProviderFor(ProfileEditing)
final profileEditingProvider =
    AutoDisposeNotifierProvider<ProfileEditing, bool>.internal(
  ProfileEditing.new,
  name: r'profileEditingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileEditingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileEditing = AutoDisposeNotifier<bool>;
String _$profileHash() => r'e413e563f00d83301718df4c83c742d827341634';

/// Profile Provider
///
/// Manages profile updates and operations.
///
/// Copied from [Profile].
@ProviderFor(Profile)
final profileProvider =
    AutoDisposeAsyncNotifierProvider<Profile, void>.internal(
  Profile.new,
  name: r'profileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Profile = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Role Enum
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('manager')
  manager,
  @JsonValue('technician')
  technician,
  @JsonValue('dispatcher')
  dispatcher,
}

/// User Status Enum (PRD Section 3.2)
enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('suspended')
  suspended,
  @JsonValue('deactivated')
  deactivated,
}

/// User Model (PRD Section 3.2)
/// 
/// Represents a user in the system.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    String? phone,
    String? avatar,
    required UserRole role,
    @Default(UserStatus.active)
    @JsonKey(
      name: 'status',
      fromJson: UserModel.statusFromJson,
      toJson: UserModel.statusToJson,
    )
    UserStatus status,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle backward compatibility: if status is not present but is_active is, derive status
    final jsonCopy = Map<String, dynamic>.from(json);
    if (!jsonCopy.containsKey('status') && jsonCopy.containsKey('is_active')) {
      final isActive = jsonCopy['is_active'] as bool? ?? true;
      jsonCopy['status'] = isActive ? 'active' : 'deactivated';
    }
    // Manually construct UserModel since json_serializable doesn't generate fromJson when we override it
    return UserModel(
      id: jsonCopy['id'] as String,
      orgId: jsonCopy['org_id'] as String,
      email: jsonCopy['email'] as String,
      firstName: jsonCopy['first_name'] as String,
      lastName: jsonCopy['last_name'] as String,
      phone: jsonCopy['phone'] as String?,
      avatar: jsonCopy['avatar'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == jsonCopy['role'] || 
               (jsonCopy['role'] is String && 
                jsonCopy['role'].toString().toLowerCase() == e.name),
        orElse: () => UserRole.technician,
      ),
      status: UserModel.statusFromJson(jsonCopy['status']),
      isActive: jsonCopy['is_active'] as bool? ?? true,
      lastLoginAt: jsonCopy['last_login_at'] != null
          ? DateTime.parse(jsonCopy['last_login_at'] as String)
          : null,
      createdAt: DateTime.parse(jsonCopy['created_at'] as String),
      updatedAt: DateTime.parse(jsonCopy['updated_at'] as String),
    );
  }

  // Helper methods for status JSON conversion
  static UserStatus statusFromJson(dynamic json) {
    if (json == null) return UserStatus.active;
    if (json is String) {
      switch (json) {
        case 'active':
          return UserStatus.active;
        case 'suspended':
          return UserStatus.suspended;
        case 'deactivated':
          return UserStatus.deactivated;
        default:
          return UserStatus.active;
      }
    }
    return UserStatus.active;
  }

  static String statusToJson(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return 'active';
      case UserStatus.suspended:
        return 'suspended';
      case UserStatus.deactivated:
        return 'deactivated';
    }
  }
}

// Top-level helper function for JsonKey toJson callback
Map<String, dynamic> _userModelToJson(UserModel user) => <String, dynamic>{
      'id': user.id,
      'org_id': user.orgId,
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'phone': user.phone,
      'avatar': user.avatar,
      'role': user.role.name,
      'status': UserModel.statusToJson(user.status),
      'is_active': user.isActive,
      'last_login_at': user.lastLoginAt?.toIso8601String(),
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    };

/// Extension methods for UserModel
extension UserModelX on UserModel {
  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get initials
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Get role display text
  String get roleText {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.manager:
        return 'Manager';
      case UserRole.technician:
        return 'Technician';
      case UserRole.dispatcher:
        return 'Dispatcher';
    }
  }

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is technician
  bool get isTechnician => role == UserRole.technician;

  /// Check if user can manage users
  bool get canManageUsers => role == UserRole.admin || role == UserRole.manager;

  /// Check if user is active (status-based check)
  bool get isActiveFromStatus => status == UserStatus.active;

  /// Get status display text
  String get statusText {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.deactivated:
        return 'Deactivated';
    }
  }
}

/// Auth Response Model
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(toJson: _userModelToJson) required UserModel user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// Login Request Model
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Signup Request Model
@freezed
class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    required String email,
    required String password,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    String? phone,
    @JsonKey(name: 'org_name') String? orgName,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}


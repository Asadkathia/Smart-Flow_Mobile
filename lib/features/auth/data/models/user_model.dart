import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Role Enum (PRD Section 3.2)
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('dispatcher')
  dispatcher,
  @JsonValue('accountant')
  accountant,
  @JsonValue('technician')
  technician,
  // Remove 'manager' - not in PRD
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
    required String email, // Must be valid email format, unique per org
    @JsonKey(name: 'full_name') required String fullName, // PRD: full_name (not first_name/last_name)
    String? phone, // E.164 format recommended
    required UserRole role, // admin, dispatcher, accountant, technician
    @Default(UserStatus.active)
    @JsonKey(
      name: 'status',
      fromJson: UserModel.statusFromJson,
      toJson: UserModel.statusToJson,
    )
    UserStatus status, // active, suspended, deactivated
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Remove: avatar, is_active (not in PRD)
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle backward compatibility: if full_name not present, construct from first_name/last_name
    final jsonCopy = Map<String, dynamic>.from(json);
    if (!jsonCopy.containsKey('full_name')) {
      final firstName = jsonCopy['first_name'] as String? ?? '';
      final lastName = jsonCopy['last_name'] as String? ?? '';
      jsonCopy['full_name'] = '$firstName $lastName'.trim();
    }
    // Handle backward compatibility: if status is not present but is_active is, derive status
    if (!jsonCopy.containsKey('status') && jsonCopy.containsKey('is_active')) {
      final isActive = jsonCopy['is_active'] as bool? ?? true;
      jsonCopy['status'] = isActive ? 'active' : 'deactivated';
    }
    // Manually construct UserModel since json_serializable doesn't generate fromJson when we override it
    return UserModel(
      id: jsonCopy['id'] as String,
      orgId: jsonCopy['org_id'] as String,
      email: jsonCopy['email'] as String,
      fullName: jsonCopy['full_name'] as String,
      phone: jsonCopy['phone'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == jsonCopy['role'] || 
               (jsonCopy['role'] is String && 
                jsonCopy['role'].toString().toLowerCase() == e.name),
        orElse: () => UserRole.technician,
      ),
      status: UserModel.statusFromJson(jsonCopy['status']),
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
      'full_name': user.fullName,
      'phone': user.phone,
      'role': user.role.name,
      'status': UserModel.statusToJson(user.status),
      'last_login_at': user.lastLoginAt?.toIso8601String(),
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    };

/// Extension methods for UserModel
extension UserModelX on UserModel {
  /// Get first name (derived from full_name for backward compatibility)
  String get firstName {
    final parts = fullName.split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  /// Get last name (derived from full_name for backward compatibility)
  String get lastName {
    final parts = fullName.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  /// Get initials
  String get initials {
    final parts = fullName.split(' ');
    if (parts.isEmpty) return '';
    final first = parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '';
    final last = parts.length > 1 && parts.last.isNotEmpty 
        ? parts.last[0].toUpperCase() 
        : '';
    return '$first$last';
  }

  /// Get role display text
  String get roleText {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.dispatcher:
        return 'Dispatcher';
      case UserRole.accountant:
        return 'Accountant';
      case UserRole.technician:
        return 'Technician';
    }
  }

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is technician
  bool get isTechnician => role == UserRole.technician;

  /// Check if user can manage users
  bool get canManageUsers => role == UserRole.admin;

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


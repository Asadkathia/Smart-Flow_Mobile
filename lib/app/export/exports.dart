// Flutter Core
export 'dart:async';
export 'dart:convert';
export 'dart:io';
export 'dart:math';

// Flutter Framework
export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter/services.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/gestures.dart';

// Third-party packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:table_calendar/table_calendar.dart';

export 'package:cached_network_image/cached_network_image.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:app_settings/app_settings.dart';

// Data Layer (Legacy - kept for backward compatibility)
// Note: exceptions.dart removed - use core/errors/app_exceptions.dart instead
export '../data/response/api_response.dart';
export '../data/response/status.dart';

// Network Layer (Legacy - DEPRECATED)
// @deprecated Use Dio from lib/shared/data/remote/api_client.dart instead
// export '../network/base_api_services.dart';
// export '../network/network_api_services.dart';

// Core Errors
export '../../core/errors/app_exceptions.dart';
export '../../core/errors/error_handler.dart';

// Core Theme & Constants
export '../../core/theme/app_colors.dart';
export '../../core/theme/app_text_styles.dart';
export '../../core/constants/api_endpoints.dart';

// Shared Widgets
export '../../shared/presentation/widgets/standard_states.dart';
export '../../shared/presentation/widgets/conflict_banner.dart';
export '../../shared/presentation/widgets/loading_skeleton.dart';
export '../../shared/presentation/widgets/media_gallery_widget.dart';
export '../../shared/presentation/widgets/error_boundary.dart';

// Utils (Legacy - kept for backward compatibility)
export '../utils/app_theme/app_theme.dart';
export '../utils/toasts/toasts.dart';
export '../utils/assets/app_images.dart';
export '../utils/assets/app_vectors.dart';

// Routes (Using GoRouter - see lib/router/app_router.dart)

// Controllers (Using Riverpod providers)
// See: lib/features/*/presentation/providers/
// Note: MapController removed - use VisitsMapWidget instead

// Models
// Note: Legacy models migrated to feature-based structure:
// - Job -> VisitModel (features/visits/data/models/)
// - Quote items -> features/quotes/data/models/create_quotes/

// Repositories

// Services

// Views (renamed to screens)
// All screens migrated to feature-based structure:
// - Home -> features/visits/presentation/screens/home_screen.dart ✓
// - Schedule -> features/visits/presentation/screens/schedule_screen.dart ✓
// - Job Details -> features/visits/presentation/screens/job_details_screen.dart ✓
// - Main Navigation -> shared/navigation/screens/main_navigation_screen.dart ✓
// - More -> features/settings/presentation/screens/more_screen.dart ✓
// - Create Quotes -> features/quotes/presentation/screens/create_quotes_screen.dart ✓


// Widgets (moved to shared/presentation/widgets/)
export '../../shared/presentation/widgets/internet_exceptions.dart';
export '../../shared/presentation/widgets/custom_app_bar.dart';
export '../../shared/presentation/widgets/cached_network_image_widget.dart';
export '../../shared/presentation/widgets/build_basic_button.dart';
export '../../shared/presentation/widgets/build_form_field.dart';
// Note: Legacy widgets migrated to feature-based structure:
// - Home -> features/visits/presentation/widgets/
// - Navigation -> shared/navigation/
// - Schedule -> features/visits/presentation/widgets/schedule/
// - Job details -> features/visits/presentation/widgets/job_details/
// - Quote creation -> features/quotes/presentation/widgets/create_quotes/
export '../../shared/presentation/widgets/auth_base_layout.dart';

// Intl
export 'package:intl/intl.dart' hide TextDirection;

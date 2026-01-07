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

// TODO(migration): MapController removed - use VisitsMapWidget instead
// export '../modules/Home/controller/map_controller.dart';



// Models

// TODO(migration): Job model removed - use VisitModel instead
// export '../modules/Home/models/job.dart';
// TODO(migration): create_quotes models migrated to features/quotes/data/models/create_quotes/
// export '../modules/create_quotes/models/material_item.dart';
// export '../modules/create_quotes/models/material_line.dart';
// export '../modules/create_quotes/models/service_item.dart';
// export '../modules/create_quotes/models/service_line.dart';

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
// TODO(migration): Home widgets removed - use features/visits widgets instead
// export '../modules/Home/widgets/job_card_widget.dart';
// export '../modules/Home/widgets/map_widget.dart';
// TODO(migration): Navigation widgets migrated to shared/navigation/
// export '../modules/main_navigation/view/custom_bottom_nav_bar.dart';
// TODO(migration): Schedule widgets migrated to features/visits/presentation/widgets/schedule/
// export '../modules/schedule/widgets/custom_tab_bar_widget.dart';
// export '../modules/schedule/widgets/timeline_view_widget.dart';
// export '../modules/schedule/widgets/day_view_widget.dart';
// export '../modules/schedule/widgets/list_view_widget.dart';
// export '../modules/schedule/widgets/map_view_widget.dart';
// export '../modules/schedule/widgets/user_stats_widget.dart';
// TODO(migration): Job details widgets migrated to features/visits/presentation/widgets/job_details/
// export '../modules/job_details/widgets/job_details_header.dart';
// export '../modules/job_details/widgets/job_details_schedule_widget.dart';
// export '../modules/job_details/widgets/job_details_details_tab.dart';
// export '../modules/job_details/widgets/job_details_visit_tab.dart';
// export '../modules/job_details/widgets/job_details_notes_tab.dart';
// TODO(migration): create_quotes widgets migrated to features/quotes/presentation/widgets/create_quotes/
// export '../modules/create_quotes/widgets/create_quotes_add_button.dart';
// export '../modules/create_quotes/widgets/create_quotes_edit_service_dialog.dart';
// export '../modules/create_quotes/widgets/create_quotes_line_item.dart';
// export '../modules/create_quotes/widgets/create_quotes_material_picker_dialog.dart';
// export '../modules/create_quotes/widgets/create_quotes_material_quantity_editor_dialog.dart';
// export '../modules/create_quotes/widgets/create_quotes_message_editor_dialog.dart';
// export '../modules/create_quotes/widgets/create_quotes_message_row.dart';
// export '../modules/create_quotes/widgets/create_quotes_section_header.dart';
// export '../modules/create_quotes/widgets/create_quotes_service_picker_dialog.dart';
// export '../modules/create_quotes/widgets/create_quotes_service_quantity_editor_dialog.dart';
// export '../modules/create_quotes/widgets/create_quotes_summary_row.dart';
// export '../modules/create_quotes/widgets/create_quotes_taxable_row.dart';
export '../../shared/presentation/widgets/auth_base_layout.dart';

// Intl
export 'package:intl/intl.dart' hide TextDirection;

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/job.dart';
import '../../../utils/app_theme/app_colors.dart';

/// Map Controller for managing Google Maps state
/// 
/// Manages markers, camera position, and map interactions.
/// Uses ChangeNotifier pattern for state management.
class MapController extends ChangeNotifier {
  // State
  bool _hasError = false;
  bool get hasError => _hasError;
  
  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  // Center coordinates for Phoenix, AZ area
  final LatLng center = const LatLng(33.4734, -112.0362);

  GoogleMapController? mapController;
  List<Job> _jobs = const [];

  // Cache rendered icons by time string
  final Map<String, _MarkerIconData> _iconCache = {};

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _hasError = false;
    notifyListeners();
  }

  void setJobs(List<Job> jobs) {
    _jobs = jobs;
    _createMarkers();
  }

  void setError(bool value) {
    _hasError = value;
    notifyListeners();
  }

  void retry() {
    _hasError = false;
    _createMarkers();
    notifyListeners();
  }

  Future<void> _createMarkers() async {
    final Set<Marker> newMarkers = {};
    debugPrint('Creating markers for "${_jobs.length}" jobs');

    // Build all marker futures in parallel
    final futures = _jobs.map((job) async {
      final time = _extractStartTime(job.timeRange);
      final iconData = await _getOrBuildTimePinIcon(time);
      return Marker(
        markerId: MarkerId(job.id),
        position: LatLng(job.latitude, job.longitude),
        icon: iconData.icon,
        anchor: iconData.anchor,
        infoWindow: InfoWindow(
          title: job.jobTitle,
          snippet: '${job.companyName}\n${job.timeRange}',
        ),
      );
    }).toList();

    final built = await Future.wait(futures);
    newMarkers.addAll(built);

    // Optional: center reference marker
    newMarkers.add(
      Marker(
        markerId: const MarkerId('center'),
        position: center,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Phoenix Area'),
      ),
    );

    debugPrint('Total markers created: ${newMarkers.length}');
    _markers = newMarkers;
    notifyListeners();
  }

  String _extractStartTime(String timeRange) {
    final parts = timeRange.split('-');
    return parts.isNotEmpty ? parts[0].trim() : '';
  }

  Future<_MarkerIconData> _getOrBuildTimePinIcon(String time) async {
    if (_iconCache.containsKey(time)) {
      return _iconCache[time]!;
    }
    final iconData = await _buildTimePinIcon(time);
    _iconCache[time] = iconData;
    return iconData;
  }

  Future<_MarkerIconData> _buildTimePinIcon(String time) async {
    const double pinWidth = 70;
    const double pinHeight = 90;
    const double textOffset = 22;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Draw pin body
    final Paint pinPaint = Paint()..color = AppColors.darkGrey;
    final Path pinPath = Path()
      ..moveTo(pinWidth / 2, pinHeight)
      ..lineTo(pinWidth * 0.25, pinHeight * 0.55)
      ..quadraticBezierTo(0, pinHeight * 0.4, 0, pinHeight * 0.3)
      ..arcToPoint(
        Offset(pinWidth, pinHeight * 0.3),
        radius: Radius.circular(pinWidth / 2),
        clockwise: true,
      )
      ..quadraticBezierTo(pinWidth, pinHeight * 0.4, pinWidth * 0.75, pinHeight * 0.55)
      ..close();
    canvas.drawPath(pinPath, pinPaint);

    // Draw white circle
    final Paint circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(pinWidth / 2, pinHeight * 0.3),
      pinWidth / 3,
      circlePaint,
    );

    // Draw time text
    final textPainter = TextPainter(
      text: TextSpan(
        text: time,
        style: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        (pinWidth - textPainter.width) / 2,
        textOffset,
      ),
    );

    final ui.Image image = await recorder
        .endRecording()
        .toImage(pinWidth.toInt(), pinHeight.toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    return _MarkerIconData(
      icon: BitmapDescriptor.bytes(data!.buffer.asUint8List()),
      anchor: const Offset(0.5, 1.0),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

class _MarkerIconData {
  final BitmapDescriptor icon;
  final Offset anchor;
  _MarkerIconData({required this.icon, required this.anchor});
}

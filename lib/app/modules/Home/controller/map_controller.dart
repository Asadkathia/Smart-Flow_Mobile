import 'dart:ui' as ui;

import '../../../export/exports.dart';


class MapController extends GetxController {
  // Reactive state
  final RxBool hasError = false.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;

  // Center coordinates for Phoenix, AZ area
  final LatLng center = const LatLng(33.4734, -112.0362);

  GoogleMapController? mapController;
  List<Job> _jobs = const [];

  // Cache rendered icons by time string
  final Map<String, _MarkerIconData> _iconCache = {};

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    hasError.value = false;
  }

  void setJobs(List<Job> jobs) {
    _jobs = jobs;
    _createMarkers();
  }

  void retry() {
    hasError.value = false;
    _createMarkers();
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
        anchor: iconData.anchor, // keep the pin tip aligned to LatLng
        infoWindow: InfoWindow(
          title: job.jobTitle,
          snippet: '${job.companyName}\n${job.timeRange}',
        ),
        onTap: () => onMarkerTapped(job),
      );
    }).toList();

    final built = await Future.wait(futures);
    newMarkers.addAll(built);

    // Optional: center reference marker (keep default icon)
    newMarkers.add(
      Marker(
        markerId: const MarkerId('center'),
        position: center,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Phoenix Area'),
      ),
    );

    debugPrint('Total markers created: ${newMarkers.length}');
    markers
      ..clear()
      ..addAll(newMarkers);
  }

  // UI action moved here using Get.bottomSheet (no BuildContext required)
  void onMarkerTapped(Job job) {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.jobTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.companyName,
              style: TextStyle(fontSize: 16, color: AppColors.greyColor),
            ),
            const SizedBox(height: 8),
            Text(
              job.address,
              style: TextStyle(fontSize: 14, color: AppColors.greyColor),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.timeRange,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(job.statusLabel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    job.statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  // Helpers
  String _extractStartTime(String timeRange) {
    // Expect formats like "9:00 AM - 12:00 PM" or "09:00 AM"
    final regex = RegExp(r'\b(\d{1,2}:\d{2}\s*[AP]M)\b', caseSensitive: false);
    final match = regex.firstMatch(timeRange);
    final raw = match?.group(1) ?? timeRange.trim();
    // Normalize to zero-padded hour (e.g., 09:00 AM)
    final hm = RegExp(r'^(\d{1,2}):(\d{2})\s*([AP]M)$', caseSensitive: false);
    final m2 = hm.firstMatch(raw);
    if (m2 != null) {
      final h = m2.group(1)!;
      final mm = m2.group(2)!;
      final ampm = m2.group(3)!.toUpperCase();
      final hh = h.length == 1 ? '0$h' : h;
      return '$hh:$mm $ampm';
    }
    return raw;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return Colors.amber;
      default:
        return AppColors.greyColor;
    }
  }

  Future<_MarkerIconData> _getOrBuildTimePinIcon(String time) async {
    final cached = _iconCache[time];
    if (cached != null) return cached;
    final built = await _buildTimePinIcon(time);
    _iconCache[time] = built;
    return built;
  }

  Future<_MarkerIconData> _buildTimePinIcon(String time) async {
    // Sizes in logical pixels
    const double padding = 8;
    const double pinRadius = 18;
    const double pointerHeight = 16;
    const double gap = 10; // gap between pin and label

    // Prepare text painter
    final textStyle = TextStyle(
      color: const Color(0xFF0A2E5D),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
    );
    final tp = TextPainter(
      text: TextSpan(text: time, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final double labelHPad = 10;
    final double labelVPad = 6;
    final double labelWidth = tp.width + 2 * labelHPad;
    final double labelHeight = tp.height + 2 * labelVPad;

    final double height =
        mathMax(pinRadius * 2 + pointerHeight, labelHeight) + 2 * padding;
    final double pinCenterX = padding + pinRadius; // keep pin at left
    final double pinCenterY = padding + pinRadius;
    final double tipX = pinCenterX;
    final double tipY = height - padding; // bottom inside padding

    final double labelLeft = pinCenterX + pinRadius + gap;
    final double labelTop = (height - labelHeight) / 2;
    final double width = labelLeft + labelWidth + padding;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Device pixel ratio for crisp output
    final dpr =
        ui.PlatformDispatcher.instance.implicitView?.devicePixelRatio ?? 3.0;
    canvas.scale(dpr, dpr);

    // Gradient paint for pin
    final gradient = ui.Gradient.linear(
      Offset(pinCenterX, pinCenterY - pinRadius),
      Offset(pinCenterX, tipY),
      const [Color(0xFF0072B5), Color(0xFF40C4FF)],
    );
    final pinPaint = Paint()..shader = gradient;

    // Draw pin circle
    canvas.drawCircle(Offset(pinCenterX, pinCenterY), pinRadius, pinPaint);

    // Draw pointer triangle
    final tri = Path()
      ..moveTo(pinCenterX - pinRadius * 0.5, pinCenterY + pinRadius * 0.6)
      ..lineTo(pinCenterX + pinRadius * 0.5, pinCenterY + pinRadius * 0.6)
      ..lineTo(tipX, tipY)
      ..close();
    canvas.drawPath(tri, pinPaint);

    // White inner cutout
    final innerR = pinRadius * 0.5;
    canvas.drawCircle(
      Offset(pinCenterX, pinCenterY - 4),
      innerR,
      Paint()..color = Colors.white,
    );

    // Label background (white rounded pill)
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(labelLeft, labelTop, labelWidth, labelHeight),
      const Radius.circular(12),
    );
    final labelBg = Paint()..color = Colors.white;
    // Optional subtle border for contrast
    final labelBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x14000000);
    canvas.drawRRect(rrect, labelBg);
    canvas.drawRRect(rrect, labelBorder);

    // Draw time text
    tp.paint(canvas, Offset(labelLeft + labelHPad, labelTop + labelVPad));

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      (width * dpr).toInt(),
      (height * dpr).toInt(),
    );
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final icon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());

    // Anchor so that the pin tip points to the LatLng
    final anchor = Offset(tipX / width, tipY / height);
    return _MarkerIconData(icon, anchor);
  }
}

class _MarkerIconData {
  final BitmapDescriptor icon;
  final Offset anchor; // fraction values (0..1)
  _MarkerIconData(this.icon, this.anchor);
}

// Local helper since dart:math not explicitly imported above
double mathMax(double a, double b) => a > b ? a : b;

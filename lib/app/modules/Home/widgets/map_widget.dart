import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/app_theme/app_colors.dart';
import '../controller/map_controller.dart';
import '../models/job.dart';

/// Map Widget for displaying jobs on Google Maps
/// 
/// Displays job locations as markers on an interactive map.
/// Uses ChangeNotifier pattern for state management.
class MapWidget extends StatefulWidget {
  final List<Job> jobs;

  const MapWidget({super.key, this.jobs = const []});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MapController();
    _controller.setJobs(widget.jobs);
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.jobs, widget.jobs)) {
      _controller.setJobs(widget.jobs);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _controller.hasError ? _buildFallbackMap() : _buildGoogleMap(),
    );
  }

  Widget _buildGoogleMap() {
    try {
      return GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.onMapCreated(controller);
          debugPrint(
            'Map created successfully with ${_controller.markers.length} markers',
          );
        },
        initialCameraPosition: CameraPosition(
          target: _controller.center,
          zoom: 11.0,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        markers: Set<Marker>.from(_controller.markers),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() => ScaleGestureRecognizer()),
        },
      );
    } catch (e) {
      debugPrint('Error creating GoogleMap: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.setError(true);
      });
      return _buildFallbackMap();
    }
  }

  Widget _buildFallbackMap() {
    return Container(
      color: AppColors.lightBeige,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 80, color: AppColors.greyColor),
            const SizedBox(height: 16),
            Text(
              'Map Unavailable',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.jobs.length} job${widget.jobs.length != 1 ? 's' : ''} scheduled',
              style: TextStyle(fontSize: 14, color: AppColors.greyColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _controller.retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGrey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

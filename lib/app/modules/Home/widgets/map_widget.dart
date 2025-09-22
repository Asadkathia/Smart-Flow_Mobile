


import '../../../export/exports.dart';


class MapWidget extends StatefulWidget {
  final List<Job> jobs;

  const MapWidget({Key? key, this.jobs = const []}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    // Get or create controller
    _controller = Get.isRegistered<MapController>()
        ? Get.find<MapController>()
        : Get.put(MapController());
    _controller.setJobs(widget.jobs);
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.jobs, widget.jobs)) {
      _controller.setJobs(widget.jobs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError = _controller.hasError.value;
      return SizedBox.expand(
        child: hasError ? _buildFallbackMap() : _buildGoogleMap(),
      );
    });
  }

  Widget _buildGoogleMap() {
    try {
      return GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.onMapCreated(controller);
          debugPrint(
            'Map created successfully with ${_controller.markers.length} markers',
          );
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              debugPrint('Map should be loaded by now');
            }
          });
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
        _controller.hasError.value = true;
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
              'Unable to load map\nCheck your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.greyColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _controller.retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGrey,
                foregroundColor: AppColors.whiteColor,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartflowpro/core/constants/app_constants.dart';
import '../../data/models/visit_model.dart';

/// Visits Map Widget
/// 
/// Displays a Google Map with markers for each visit location.
class VisitsMapWidget extends StatefulWidget {
  final List<VisitModel> visits;
  final Function(VisitModel)? onMarkerTap;

  const VisitsMapWidget({
    super.key,
    required this.visits,
    this.onMarkerTap,
  });

  @override
  State<VisitsMapWidget> createState() => _VisitsMapWidgetState();
}

class _VisitsMapWidgetState extends State<VisitsMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(VisitsMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visits != widget.visits) {
      _buildMarkers();
    }
  }

  void _buildMarkers() {
    final markers = <Marker>{};

    for (final visit in widget.visits) {
      if (visit.latitude != null && visit.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId(visit.id),
            position: LatLng(visit.latitude!, visit.longitude!),
            infoWindow: InfoWindow(
              title: visit.title ?? 'Visit',
              snippet: visit.customerName,
            ),
            icon: _getMarkerIcon(visit.status),
            onTap: () {
              widget.onMarkerTap?.call(visit);
            },
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });

    // Fit bounds to show all markers
    if (_mapController != null && markers.isNotEmpty) {
      _fitBounds();
    }
  }

  BitmapDescriptor _getMarkerIcon(VisitStatus status) {
    switch (status) {
      case VisitStatus.inProgress:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case VisitStatus.completed:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case VisitStatus.cancelled:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case VisitStatus.paused:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _fitBounds() {
    if (_markers.isEmpty) return;

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (final marker in _markers) {
      if (marker.position.latitude < minLat) {
        minLat = marker.position.latitude;
      }
      if (marker.position.latitude > maxLat) {
        maxLat = marker.position.latitude;
      }
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          AppConstants.defaultLatitude,
          AppConstants.defaultLongitude,
        ),
        zoom: AppConstants.defaultZoom,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
        if (_markers.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500), _fitBounds);
        }
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}




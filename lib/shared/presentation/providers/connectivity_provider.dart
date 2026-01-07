import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity State
enum ConnectivityState {
  connected,
  disconnected,
  unknown,
}

/// Connectivity Status with details
class ConnectivityStatus {
  final ConnectivityState state;
  final List<ConnectivityResult> results;
  final DateTime lastChecked;

  const ConnectivityStatus({
    required this.state,
    required this.results,
    required this.lastChecked,
  });

  /// Check if connected
  bool get isConnected => state == ConnectivityState.connected;

  /// Check if disconnected
  bool get isDisconnected => state == ConnectivityState.disconnected;

  /// Check if on WiFi
  bool get isWifi => results.contains(ConnectivityResult.wifi);

  /// Check if on mobile data
  bool get isMobile => results.contains(ConnectivityResult.mobile);

  /// Check if on ethernet
  bool get isEthernet => results.contains(ConnectivityResult.ethernet);

  /// Get connection type string
  String get connectionType {
    if (isWifi) return 'WiFi';
    if (isMobile) return 'Mobile Data';
    if (isEthernet) return 'Ethernet';
    if (isDisconnected) return 'No Connection';
    return 'Unknown';
  }

  /// Create initial unknown state
  factory ConnectivityStatus.unknown() => ConnectivityStatus(
    state: ConnectivityState.unknown,
    results: [],
    lastChecked: DateTime.now(),
  );

  /// Create connected state
  factory ConnectivityStatus.connected(List<ConnectivityResult> results) => ConnectivityStatus(
    state: ConnectivityState.connected,
    results: results,
    lastChecked: DateTime.now(),
  );

  /// Create disconnected state
  factory ConnectivityStatus.disconnected() => ConnectivityStatus(
    state: ConnectivityState.disconnected,
    results: [ConnectivityResult.none],
    lastChecked: DateTime.now(),
  );
}

/// Connectivity Notifier
/// 
/// Manages connectivity state and provides real-time updates.
class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityNotifier() 
      : _connectivity = Connectivity(),
        super(ConnectivityStatus.unknown()) {
    _init();
  }

  /// Initialize connectivity monitoring
  Future<void> _init() async {
    // Get initial state
    await checkConnectivity();
    
    // Listen for changes
    // Note: connectivity_plus 5.x onConnectivityChanged returns Stream<ConnectivityResult>
    // but we need List<ConnectivityResult>, so we map it
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _handleConnectivityChange([result]);
    });
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      state = ConnectivityStatus.disconnected();
    } else {
      state = ConnectivityStatus.connected(results);
    }
  }

  /// Check current connectivity
  Future<void> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      // connectivity_plus 5.x returns ConnectivityResult, convert to List
      _handleConnectivityChange([result]);
    } catch (e) {
      state = ConnectivityStatus.unknown();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Connectivity Provider
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>((ref) {
  return ConnectivityNotifier();
});

/// Is Online Provider
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityProvider);
  return status.isConnected;
});

/// Is Offline Provider
final isOfflineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityProvider);
  return status.isDisconnected;
});

/// Connection Type Provider
final connectionTypeProvider = Provider<String>((ref) {
  final status = ref.watch(connectivityProvider);
  return status.connectionType;
});

/// Connectivity Stream Provider (alternative)
/// Note: This provider is not currently used. Use connectivityProvider instead.
/// If needed in the future, ensure connectivity_plus version compatibility.
// final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
//   return Connectivity().onConnectivityChanged;
// });


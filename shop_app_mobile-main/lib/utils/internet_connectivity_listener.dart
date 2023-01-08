import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'logger.dart';

class InternetConnectivity {
  factory InternetConnectivity() => _this ??= InternetConnectivity._();

  static InternetConnectivity? _this;
  final log = getLogger('internet_connectivity_listener');

  InternetConnectivity._() {
    _statusController.onListen = () {
      log.d('internet connectivity listener initialised');
      _initialiseNetworkListener();
    };
    // stop sending status updates when no one is listening
    _statusController.onCancel = () {
      log.e('internet connectivity listener canceled');
      _timer?.cancel();
      _lastInternetStatus = null; // reset last status
      _connectivityListener?.cancel();
    };
  }

  Stream<bool> get onStatusChange => _statusController.stream;

  StreamController<bool> _statusController = StreamController.broadcast();

  bool? _lastInternetStatus;
  bool isNetworkAvailable = true; //doesn't refer to internet
  Timer? _timer;
  StreamSubscription<ConnectivityResult>? _connectivityListener;

  Future<void> _initialiseNetworkListener() async {
    ConnectivityResult initialResult = await Connectivity().checkConnectivity();
    if (initialResult == ConnectivityResult.none) {
      _pushUpdateIfAny(false);
    }
    _connectivityListener = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        log.e("network not available", "initialiseNetworkListener");
        isNetworkAvailable = false;
        _pushUpdateIfAny(false);
      } else {
        log.v("network available", "initialiseNetworkListener");
        isNetworkAvailable = true;
        _checkInternetAvailability();
      }
    });
  }

  _checkInternetAvailability() async {
    // cancel the old timer to avoid repetitive network calls
    _timer?.cancel();
    log.v('checking network connection $isNetworkAvailable');
    if (!isNetworkAvailable) return;
    bool currentStatus = await isHostReachable();

    _pushUpdateIfAny(currentStatus);

    // start new timer only if there are listeners
    if (!_statusController.hasListener) return;
    _timer = Timer(const Duration(seconds: 10), _checkInternetAvailability);
  }

  Future<bool> isHostReachable() async {
    Socket? sock;
    try {
      log.v('started connecting to a socket');
      sock = await Socket.connect(
        '1.1.1.1',
        53,
        timeout: Duration(seconds: 5),
      );
      log.v('internet available');
      sock.destroy();
      return true;
    } catch (e) {
      log.e('no internet');
      sock?.destroy();
      return false;
    }
  }

  _pushUpdateIfAny(bool currentStatus) {
    if (_lastInternetStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }
    _lastInternetStatus = currentStatus;
  }
}

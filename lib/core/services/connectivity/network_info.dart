import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(connectivity: Connectivity());
});

class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo({required Connectivity connectivity})
      : _connectivity = connectivity;

  @override

  Future<bool> get isConnected async {
    //
    final result = await _connectivity
        .checkConnectivity(); // is the internet or data is on or not
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    // for checking actual internet connection
    return _checkNetworkConn();

    // return true; // for checking locally
  }

  Future<bool> _checkNetworkConn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

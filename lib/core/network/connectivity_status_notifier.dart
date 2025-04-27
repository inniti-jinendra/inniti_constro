// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Enum to represent connectivity status
// enum ConnectivityStatus { NotDetermined, isConnected, isDisconnected }
//
// class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
//   ConnectivityStatus? lastResult;
//   ConnectivityStatus? previousStatus;
//
//   ConnectivityStatusNotifier() : super(ConnectivityStatus.NotDetermined) {
//     lastResult = ConnectivityStatus.NotDetermined;
//     previousStatus = ConnectivityStatus.NotDetermined;
//
//     // Start listening to the connectivity status change
//     Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
//       ConnectivityStatus newState;
//
//       // Assuming you want to detect any connectivity from the list of results
//       // If any of the connectivity results is connected, treat it as connected
//       if (results.contains(ConnectivityResult.mobile) ||
//           results.contains(ConnectivityResult.wifi)) {
//         newState = ConnectivityStatus.isConnected;
//       } else if (results.contains(ConnectivityResult.none)) {
//         newState = ConnectivityStatus.isDisconnected;
//       } else if (results.contains(ConnectivityResult.bluetooth)) {
//         newState = ConnectivityStatus.isDisconnected;
//       } else if (results.contains(ConnectivityResult.ethernet)) {
//         newState = ConnectivityStatus.isConnected;
//       } else {
//         newState = ConnectivityStatus.isDisconnected; // Default to disconnected if unrecognized
//       }
//
//       // Update the state only if there's a change in connectivity
//       if (newState != lastResult) {
//         state = newState;
//         lastResult = newState;
//       }
//     });
//   }
//
//   // Add method to update previous connectivity status
//   void updatePreviousStatus(ConnectivityStatus status) {
//     previousStatus = status;
//   }
// }
//
// // Create the provider that will make the ConnectivityStatusNotifier available globally
// final connectivityStatusProvider = StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
//   return ConnectivityStatusNotifier();
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ✅ Enum for connectivity status
enum ConnectivityStatus { NotDetermined, isConnected, isDisconnected }

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectivityStatusNotifier() : super(ConnectivityStatus.NotDetermined) {
    _checkInitialConnection();
    _monitorConnectivity();
  }

  /// ✅ Check the initial connection when the app starts
  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    state = _mapConnectivityResult(result as ConnectivityResult);
  }

  /// ✅ Monitor connectivity changes
  void _monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((dynamic result) {
      ConnectivityResult connectivityResult;

      // 🔹 Handle versions where a list is returned
      if (result is List<ConnectivityResult> && result.isNotEmpty) {
        connectivityResult = result.first;
      } else if (result is ConnectivityResult) {
        connectivityResult = result;
      } else {
        connectivityResult = ConnectivityResult.none;
      }

      final newStatus = _mapConnectivityResult(connectivityResult);
      if (state != newStatus) { // ✅ Only update state if it actually changes
        print("🛠 DEBUG: Connectivity Status Updated to: $newStatus");
        state = newStatus;
      }
    });
  }

  /// ✅ Convert `ConnectivityResult` to `ConnectivityStatus`
  ConnectivityStatus _mapConnectivityResult(ConnectivityResult result) {
    return result == ConnectivityResult.none
        ? ConnectivityStatus.isDisconnected
        : ConnectivityStatus.isConnected;
  }

  /// ✅ Manually check the connection
  Future<void> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    state = _mapConnectivityResult(result as ConnectivityResult);
  }
}

// ✅ Riverpod Provider for global access
final connectivityStatusProvider = StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
  return ConnectivityStatusNotifier();
});



// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// // ✅ Enum for connectivity status
// enum ConnectivityStatus { NotDetermined, isConnected, isDisconnected }
//
// class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
//   ConnectivityStatusNotifier() : super(ConnectivityStatus.NotDetermined) {
//     _checkInitialConnection();
//     _startListening();
//
//   }
//
//   // ✅ Check the initial connection when the app starts
//   Future<void> _checkInitialConnection() async {
//     final results = await Connectivity().checkConnectivity();
//
//     // Extract the first result or fallback to 'none'
//     final result = (results.isNotEmpty) ? results.first : ConnectivityResult.none;
//
//     _updateConnectivityStatus(result);
//   }
//
//   // ✅ Listen for connectivity changes
//   void _startListening() {
//     Connectivity().onConnectivityChanged.listen((results) {
//       // Handle the list by extracting the first result or using 'none'
//       final result = (results.isNotEmpty) ? results.first : ConnectivityResult.none;
//       _updateConnectivityStatus(result);
//     });
//   }
//
//   // ✅ Update the connectivity status
//   void _updateConnectivityStatus(ConnectivityResult result) {
//     if (result == ConnectivityResult.mobile ||
//         result == ConnectivityResult.wifi ||
//         result == ConnectivityResult.ethernet) {
//       state = ConnectivityStatus.isConnected;
//     } else {
//       state = ConnectivityStatus.isDisconnected;
//     }
//   }
//
//   // ✅ Manually check the connection
//   Future<void> checkConnection() async {
//     final results = await Connectivity().checkConnectivity();
//     final result = (results.isNotEmpty) ? results.first : ConnectivityResult.none;
//     _updateConnectivityStatus(result);
//   }
// }
//
// // ✅ Provider for the connectivity status
// final connectivityStatusProvider = StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
//   return ConnectivityStatusNotifier();
// });

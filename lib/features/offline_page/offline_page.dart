import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../core/network/connectivity_status_notifier.dart';

class OfflinePage extends ConsumerStatefulWidget {
  const OfflinePage({super.key});

  @override
  ConsumerState<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends ConsumerState<OfflinePage> {
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkConnectivityAndNavigate();
  }

  void _checkConnectivityAndNavigate() {
    final connectionStatus = ref.watch(connectivityStatusProvider);

    if (connectionStatus == ConnectivityStatus.isConnected) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, "/"); // ✅ Redirect to home
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(connectivityStatusProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Connectivity Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (connectionStatus == ConnectivityStatus.isDisconnected)
              Lottie.asset(
                'assets/loti/no-internet/no-internet-cloude.json',
                repeat: true,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            Text(
              connectionStatus == ConnectivityStatus.isConnected
                  ? 'You are connected!'
                  : 'You are offline.\n Please check your internet connection.',
              style: TextStyle(
                fontSize: 18,
                color: connectionStatus == ConnectivityStatus.isConnected
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkConnection() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    ref.read(connectivityStatusProvider.notifier).checkConnection();
    setState(() => _isLoading = false);
  }
}

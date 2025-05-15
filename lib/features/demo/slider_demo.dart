import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SwipeInOutPage(),
    );
  }
}

class SwipeInOutPage extends StatefulWidget {
  const SwipeInOutPage({super.key});

  @override
  State<SwipeInOutPage> createState() => _SwipeInOutPageState();
}

class _SwipeInOutPageState extends State<SwipeInOutPage> {
  double position = 0.0;
  final double threshold = 100.0;

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      position += details.delta.dx;
      position = position.clamp(-150.0, 150.0);
    });
  }

  void onDragEnd(DragEndDetails details) {
    if (position > threshold) {
      // Swiped Right → Check-In
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ConfirmationPage(type: 'Check-In'),
        ),
      );
    } else if (position < -threshold) {
      // Swiped Left → Check-Out
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ConfirmationPage(type: 'Check-Out'),
        ),
      );
    }

    // Reset button position
    setState(() {
      position = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '← Swipe Check-Out | Check-In →',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),
            GestureDetector(
              onHorizontalDragUpdate: onDragUpdate,
              onHorizontalDragEnd: onDragEnd,
              child: Transform.translate(
                offset: Offset(position, 0),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.swap_horiz, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatefulWidget {
  final String type;
  const ConfirmationPage({super.key, required this.type});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/Images/check.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.type} Successful!',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

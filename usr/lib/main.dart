import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth or Dare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SpinWheelScreen(),
    );
  }
}

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  bool _isSpinning = false;
  String _result = '';
  
  // Truth and Dare questions
  final List<String> _truths = [
    "What's your biggest secret?",
    "Who was your first crush?",
    "What's the most embarrassing thing you've done?",
    "Have you ever lied to your best friend?",
    "What's your biggest fear?",
    "What's the most childish thing you still do?",
    "Have you ever cheated on a test?",
    "What's your guilty pleasure?",
    "Who do you have a crush on right now?",
    "What's the worst thing you've ever said to someone?",
  ];

  final List<String> _dares = [
    "Do 20 push-ups right now!",
    "Call a random contact and sing to them!",
    "Dance with no music for 1 minute!",
    "Speak in an accent for the next 3 rounds!",
    "Let someone tickle you for 30 seconds!",
    "Post an embarrassing photo on social media!",
    "Eat a spoonful of hot sauce!",
    "Do your best impression of someone in the room!",
    "Let someone give you a new hairstyle!",
    "Text your crush and say something funny!",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
          // Determine if it's truth or dare based on the final rotation
          bool isTruth = _random.nextBool();
          if (isTruth) {
            _result = 'TRUTH\n\n${_truths[_random.nextInt(_truths.length)]}';
          } else {
            _result = 'DARE\n\n${_dares[_random.nextInt(_dares.length)]}';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (!_isSpinning) {
      setState(() {
        _isSpinning = true;
        _result = '';
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.purple.shade600,
              Colors.pink.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TRUTH OR DARE',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              
              // Spinning Wheel
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * pi * 5, // 5 full rotations
                    child: child,
                  );
                },
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: WheelPainter(),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Spin Button
              ElevatedButton(
                onPressed: _isSpinning ? null : _spinWheel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: Text(
                  _isSpinning ? 'SPINNING...' : 'SPIN THE WHEEL',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Result Display
              if (_result.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw 8 segments alternating between truth (blue) and dare (red)
    for (int i = 0; i < 8; i++) {
      paint.color = i.isEven ? Colors.blue.shade600 : Colors.red.shade600;
      
      final startAngle = (i * pi / 4) - pi / 2;
      final sweepAngle = pi / 4;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }
    
    // Draw text labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4);
      final text = i.isEven ? 'TRUTH' : 'DARE';
      
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      
      textPainter.layout();
      
      final x = center.dx + cos(angle) * (radius * 0.65) - textPainter.width / 2;
      final y = center.dy + sin(angle) * (radius * 0.65) - textPainter.height / 2;
      
      canvas.save();
      canvas.translate(x + textPainter.width / 2, y + textPainter.height / 2);
      canvas.rotate(angle + pi / 2);
      canvas.translate(-(textPainter.width / 2), -(textPainter.height / 2));
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
    
    // Draw center circle
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.2, paint);
    
    // Draw outer border
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    paint.color = Colors.white;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

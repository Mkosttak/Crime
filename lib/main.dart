import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'screens/welcome_screen.dart';
import 'theme/game_theme.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Sistem UI ayarları
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: GameColors.primaryDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const DetectiveBureauApp());
}

class DetectiveBureauApp extends StatelessWidget {
  const DetectiveBureauApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Detective Bureau - İnteraktif Suç Dosyası',
        debugShowCheckedModeBanner: false,
        theme: GameTheme.lightTheme,
        darkTheme: GameTheme.darkTheme,
        themeMode: ThemeMode.dark, // Modern oyunlar genellikle dark theme kullanır
        home: const SplashScreen(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    _rotateController.forward();
    
    // 3 saniye bekle, sonra WelcomeScreen'e geç
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, _) => const WelcomeScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              GameColors.primaryLight,
              GameColors.primaryDark,
              Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Arka plan efektleri
            ...List.generate(30, (index) {
              return Positioned(
                left: (index * 43) % MediaQuery.of(context).size.width,
                top: (index * 67) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _rotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value * 2 * math.pi + (index * 0.3),
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: GameColors.accent.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            
            // Ana içerik
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value * 0.5,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  GameColors.accent,
                                  GameColors.accent.withOpacity(0.7),
                                  GameColors.accentSecondary,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: GameColors.accent.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.gavel,
                              size: 70,
                              color: GameColors.primaryDark,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Başlık
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [GameColors.accent, GameColors.accentSecondary],
                      ).createShader(bounds),
                      child: Text(
                        'DETECTIVE BUREAU',
                        style: GoogleFonts.orbitron(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'İnteraktif Suç Dosyası',
                      style: GoogleFonts.crimsonText(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: GameColors.accent.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Yükleme animasyonu
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          GameColors.accent.withOpacity(0.7),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'Yükleniyor...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: GameColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotateController.dispose();
    super.dispose();
  }
}

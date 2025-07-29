import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../theme/game_theme.dart';
import '../screens/home_screen.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animasyon kontrolcülerini başlat
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));
    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Animasyonları başlat
    _fadeController.forward();
    _slideController.forward();
    _rotateController.repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingDetective();
    });
  }

  Future<void> _checkExistingDetective() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.initialize();
    
    if (gameProvider.detective != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(detective: gameProvider.detective!),
        ),
      );
    }
  }

  Future<void> _createDetective() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen isminizi girin'),
          backgroundColor: GameColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.createDetective(_nameController.text.trim());
    await gameProvider.initialize();

    setState(() {
      _isLoading = false;
    });

    if (mounted && gameProvider.detective != null) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, _) => HomeScreen(detective: gameProvider.detective!),
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
            center: Alignment.topLeft,
            radius: 1.5,
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
            ...List.generate(50, (index) {
              return Positioned(
                left: (index * 37) % MediaQuery.of(context).size.width,
                top: (index * 47) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value * 2 * math.pi + (index * 0.5),
                      child: Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          color: GameColors.accent.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            
            // Ana içerik
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo ve başlık
                        _buildLogo(),
                        const SizedBox(height: 40),
                        _buildTitle(),
                        const SizedBox(height: 60),
                        _buildLoginCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnimation.value * 0.1,
          child: Container(
            width: 120,
            height: 120,
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
                  color: GameColors.accent.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.gavel,
              size: 60,
              color: GameColors.primaryDark,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [GameColors.accent, GameColors.accentSecondary],
          ).createShader(bounds),
          child: Text(
            'DETECTIVE BUREAU',
            style: GoogleFonts.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'İNTERAKTİF SUÇ DOSYASI',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: GameColors.onSurfaceVariant,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          '\"Zeka En Güçlü Silahtır\"',
          style: GoogleFonts.crimsonText(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: GameColors.accent.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GameColors.surface.withOpacity(0.9),
            GameColors.surfaceVariant.withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: GameColors.accent.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dedektif Kimliğinizi Oluşturun',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: GameColors.accent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildNameInput(),
            const SizedBox(height: 32),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      style: GoogleFonts.poppins(
        color: GameColors.onSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Örn: Sherlock Holmes',
        hintStyle: TextStyle(
          color: GameColors.onSurfaceVariant.withOpacity(0.6),
        ),
        prefixIcon: const Icon(
          Icons.person_outline,
          color: GameColors.accent,
        ),
        filled: true,
        fillColor: GameColors.primaryDark.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: GameColors.accent.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: GameColors.accent.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: GameColors.accent,
            width: 2,
          ),
        ),
      ),
      onFieldSubmitted: (_) => _createDetective(),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createDetective,
        style: ElevatedButton.styleFrom(
          backgroundColor: GameColors.accent,
          foregroundColor: GameColors.primaryDark,
          elevation: 8,
          shadowColor: GameColors.accent.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: GameColors.primaryDark,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'MACERAYA BAŞLA',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }
}

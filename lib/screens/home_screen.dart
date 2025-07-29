import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../models/detective.dart';
import '../models/game_case.dart';
import '../theme/game_theme.dart';
import 'case_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Detective detective;
  
  const HomeScreen({
    super.key,
    required this.detective,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAvailableCasesTab(gameProvider),
              _buildActiveCasesTab(gameProvider),
              _buildProfileTab(gameProvider),
            ],
          ),
          bottomNavigationBar: _buildBottomTabBar(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoş Geldin, ${widget.detective.name}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Seviye ${widget.detective.level} Dedektif',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: GameColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        _buildFocusPointsIndicator(),
        const SizedBox(width: 16),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Mevcut Davalar'),
          Tab(text: 'Aktif Davalar'),
          Tab(text: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildFocusPointsIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: GameColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: GameColors.accent.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.psychology,
            color: GameColors.accent,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.detective.focusPoints}',
            style: GoogleFonts.poppins(
              color: GameColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: GameColors.borderColor.withOpacity(0.3),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.folder_open),
            text: 'Davalar',
          ),
          Tab(
            icon: Icon(Icons.work),
            text: 'Aktif',
          ),
          Tab(
            icon: Icon(Icons.person),
            text: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCasesTab(GameProvider gameProvider) {
    final availableCases = gameProvider.availableCases;
    
    if (availableCases.isEmpty) {
      return _buildEmptyState(
        'Henüz dava yok',
        'Yeni davalar yakında eklenecek!',
        Icons.folder_open_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableCases.length,
      itemBuilder: (context, index) {
        final caseItem = availableCases[index];
        return _buildCaseCard(caseItem, gameProvider);
      },
    );
  }

  Widget _buildActiveCasesTab(GameProvider gameProvider) {
    final activeCases = gameProvider.activeCases;
    
    if (activeCases.isEmpty) {
      return _buildEmptyState(
        'Aktif dava yok',
        'Yeni bir dava kabul ederek başlayın!',
        Icons.work_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeCases.length,
      itemBuilder: (context, index) {
        final caseItem = activeCases[index];
        return _buildActiveCaseCard(caseItem, gameProvider);
      },
    );
  }

  Widget _buildProfileTab(GameProvider gameProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildStatsSection(),
          const SizedBox(height: 24),
          _buildAchievementsSection(),
          const SizedBox(height: 24),
          _buildSettingsSection(gameProvider),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: GameColors.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: GameColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: GameColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard(GameCase caseItem, GameProvider gameProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildDifficultyBadge(caseItem.difficulty),
                const Spacer(),
                _buildRequiredFocusPoints(caseItem.requiredFocusPoints),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              caseItem.title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: GameColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              caseItem.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: GameColors.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: GameColors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  caseItem.location,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: GameColors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  '+${caseItem.rewardExperience} XP',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: GameColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _acceptCase(caseItem, gameProvider),
                child: Text('Davayı Kabul Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCaseCard(GameCase caseItem, GameProvider gameProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              caseItem.title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: GameColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: caseItem.progressPercentage,
              backgroundColor: GameColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(GameColors.accent),
            ),
            const SizedBox(height: 8),
            Text(
              'İlerleme: ${(caseItem.progressPercentage * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: GameColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
        onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => CaseDetailScreen(gameCase: caseItem),
                   ),
                 );
               },
                child: Text('Davaya Devam Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(CaseDifficulty difficulty) {
    Color color;
    String text;
    
    switch (difficulty) {
      case CaseDifficulty.easy:
        color = GameColors.success;
        text = 'Kolay';
        break;
      case CaseDifficulty.medium:
        color = GameColors.warning;
        text = 'Orta';
        break;
      case CaseDifficulty.hard:
        color = GameColors.error;
        text = 'Zor';
        break;
      case CaseDifficulty.expert:
        color = GameColors.accentSecondary;
        text = 'Uzman';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildRequiredFocusPoints(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: GameColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GameColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.psychology,
            size: 12,
            color: GameColors.accent,
          ),
          const SizedBox(width: 4),
          Text(
            '$points',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: GameColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: GameColors.accent,
              child: Text(
                widget.detective.name.substring(0, 1).toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GameColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.detective.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Seviye ${widget.detective.level} Dedektif',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: GameColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (widget.detective.experience % 100) / 100,
                    backgroundColor: GameColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(GameColors.accent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.detective.experience % 100}/100 XP',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: GameColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İstatistikler',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Çözülen Davalar',
                    '${widget.detective.casesCompleted}',
                    Icons.check_circle_outline,
                    GameColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Doğruluk Oranı',
                    '${(widget.detective.accuracy * 100).toInt()}%',
                    Icons.track_changes,
                    GameColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: GameColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Başarımlar',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Yakında eklenecek...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: GameColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(GameProvider gameProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ayarlar',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.refresh, color: GameColors.accent),
              title: Text('Oyunu Sıfırla'),
              subtitle: Text('Tüm ilerleme silinecek'),
              onTap: () => _showResetDialog(gameProvider),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptCase(GameCase caseItem, GameProvider gameProvider) async {
    if (widget.detective.focusPoints < caseItem.requiredFocusPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yeterli fokus puanınız yok!'),
          backgroundColor: GameColors.error,
        ),
      );
      return;
    }

    await gameProvider.acceptCase(caseItem.id);
    
    if (gameProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gameProvider.error!),
          backgroundColor: GameColors.error,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dava kabul edildi!'),
          backgroundColor: GameColors.success,
        ),
      );
    }
  }

  void _continueCase(GameCase caseItem) {
    // TODO: Navigate to case detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dava detay ekranı yakında eklenecek'),
      ),
    );
  }

  void _showResetDialog(GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Oyunu Sıfırla'),
        content: Text('Tüm ilerlemenizi kaybedeceksiniz. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await gameProvider.resetGame();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            child: Text('Sıfırla'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_case.dart';
import '../theme/game_theme.dart';

class CaseDetailScreen extends StatefulWidget {
  final GameCase gameCase;

  const CaseDetailScreen({Key? key, required this.gameCase}) : super(key: key);

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Set<String> _unlockedEvidence = {};
  Set<String> _questionedSuspects = {};
  Map<String, String> _deductions = {};
  int _focusPointsUsed = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.surface,
      appBar: _buildMysteriousAppBar(),
      body: Column(
        children: [
          _buildStatusBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCaseOverview(),
                _buildEvidenceBoard(),
                _buildSuspectProfiles(),
                _buildWitnessStatements(),
                _buildDeductionBoard(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomTabBar(),
    );
  }

  PreferredSizeWidget _buildMysteriousAppBar() {
    return AppBar(
      title: Text(
        widget.gameCase.title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: GameColors.onPrimary,
        ),
      ),
      backgroundColor: GameColors.primaryDark,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: GameColors.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.psychology, size: 16, color: GameColors.accent),
              const SizedBox(width: 4),
              Text(
                '${widget.gameCase.requiredFocusPoints - _focusPointsUsed}',
                style: GoogleFonts.poppins(
                  color: GameColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    final progress = (_unlockedEvidence.length + _questionedSuspects.length) / 
                   (widget.gameCase.evidence.length + widget.gameCase.suspects.length);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [GameColors.primaryDark, GameColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Çözüm İlerlemeni',
                      style: GoogleFonts.poppins(
                        color: GameColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: GameColors.onPrimary.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(GameColors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  color: GameColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: GameColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.description), text: 'Genel'),
          Tab(icon: Icon(Icons.search), text: 'Kanıtlar'),
          Tab(icon: Icon(Icons.people), text: 'Şüpheliler'),
          Tab(icon: Icon(Icons.record_voice_over), text: 'Şahitler'),
          Tab(icon: Icon(Icons.lightbulb), text: 'Çıkarımlar'),
        ],
      ),
    );
  }

  Widget _buildCaseOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMysteriousCard(
            'Dava Dosyası',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.gameCase.description,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.5,
                    color: GameColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Lokasyon', widget.gameCase.location, Icons.location_on),
                _buildInfoRow('Zorluk', _getDifficultyText(), Icons.trending_up),
                _buildInfoRow('Ödül', '+${widget.gameCase.rewardExperience} XP', Icons.star),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildMysteriousCard(
            'Olay Yeri Raporu',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.gameCase.crimeSceneReport?.observations ?? 'Bilgi yok',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: GameColors.onSurface,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bulunan Eşyalar:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: GameColors.accent,
                  ),
                ),
                ...(widget.gameCase.crimeSceneReport?.foundItems ?? []).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text(
                      '• $item',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: GameColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceBoard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kanıt Panosu',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: GameColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Her kanıtı incele ve bağlantıları keşfet...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: GameColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.gameCase.evidence.map((evidence) => _buildEvidenceCard(evidence)),
        ],
      ),
    );
  }

  Widget _buildSuspectProfiles() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Şüpheli Profilleri',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: GameColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Her şüpheliyi sorgula ve motiflerini keşfet...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: GameColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.gameCase.suspects.map((suspect) => _buildSuspectCard(suspect)),
        ],
      ),
    );
  }

  Widget _buildWitnessStatements() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Şahit İfadeleri',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: GameColors.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Şahitlerin söylediklerini dikkatle dinle...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: GameColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.gameCase.witnesses.map((witness) => _buildWitnessCard(witness)),
        ],
      ),
    );
  }

  Widget _buildDeductionBoard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Çıkarım Panosu',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: GameColors.accentSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İpuçlarını birleştir ve gerçeği keşfet...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: GameColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          _buildDeductionInterface(),
          const SizedBox(height: 24),
          if (_deductions.isNotEmpty) _buildCurrentDeductions(),
        ],
      ),
    );
  }

  Widget _buildMysteriousCard(String title, Widget content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: GameColors.cardBackground,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_special,
                  color: GameColors.accent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GameColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: GameColors.accent,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: GameColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: GameColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText() {
    switch (widget.gameCase.difficulty) {
      case CaseDifficulty.easy:
        return 'Kolay';
      case CaseDifficulty.medium:
        return 'Orta';
      case CaseDifficulty.hard:
        return 'Zor';
      case CaseDifficulty.expert:
        return 'Uzman';
    }
  }

  Widget _buildEvidenceCard(Evidence evidence) {
    final isUnlocked = _unlockedEvidence.contains(evidence.name);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUnlocked ? GameColors.accent.withOpacity(0.1) : GameColors.cardBackground,
      child: ListTile(
        leading: Icon(
          isUnlocked ? Icons.lock_open : Icons.lock,
          color: isUnlocked ? GameColors.accent : GameColors.onSurfaceVariant,
        ),
        title: Text(
          evidence.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isUnlocked ? GameColors.accent : GameColors.onSurface,
          ),
        ),
        subtitle: Text(
          isUnlocked ? evidence.description : '🔍 İncelemek için tıklayın',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: GameColors.onSurfaceVariant,
            fontStyle: isUnlocked ? FontStyle.normal : FontStyle.italic,
          ),
        ),
        onTap: () => _analyzeEvidence(evidence),
      ),
    );
  }

  Widget _buildSuspectCard(Suspect suspect) {
    final isQuestioned = _questionedSuspects.contains(suspect.name);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isQuestioned ? GameColors.error.withOpacity(0.1) : GameColors.cardBackground,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isQuestioned ? GameColors.error : GameColors.onSurfaceVariant,
          child: Text(
            suspect.name.substring(0, 1),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: GameColors.surface,
            ),
          ),
        ),
        title: Text(
          suspect.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isQuestioned ? GameColors.error : GameColors.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İlişki: ${suspect.relationship}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: GameColors.onSurfaceVariant,
              ),
            ),
            if (isQuestioned)
              Text(
                'Motif: ${suspect.motive}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: GameColors.error,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Text(
                '❓ Sorgulamak için tıklayın',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: GameColors.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        onTap: () => _questionSuspect(suspect),
      ),
    );
  }

Widget _buildWitnessCard(Witness witness) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: GameColors.success.withOpacity(0.1),
      child: ExpansionTile(
        leading: Icon(
          Icons.record_voice_over,
          color: GameColors.success,
        ),
        title: Text(
          witness.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: GameColors.success,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GameColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: GameColors.success.withOpacity(0.3),
            ),
          ),
          child: Text(
            '"${witness.statement}"',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: GameColors.onSurface,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '💬 Şahitle Konuş',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GameColors.success,
                  ),
                ),
                const SizedBox(height: 12),
                ...(_getWitnessDialogOptions(witness).map((option) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                      onPressed: () => _showWitnessDialog(witness, option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GameColors.success.withOpacity(0.8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionInterface() {
    return Card(
      color: GameColors.accentSecondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🧠 Çıkarım Yap',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GameColors.accentSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Topladığın kanıtları ve ifadeleri birleştirerek çıkarımlarını yap.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: GameColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _unlockedEvidence.isNotEmpty || _questionedSuspects.isNotEmpty
                  ? () => _makeDeduction()
                  : null,
              icon: const Icon(Icons.lightbulb_outline),
              label: Text('Yeni Çıkarım Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GameColors.accentSecondary,
                foregroundColor: GameColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentDeductions() {
    return Card(
      color: GameColors.accentSecondary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Çıkarımların',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GameColors.accentSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ..._deductions.entries.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GameColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: GameColors.accentSecondary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: GameColors.accentSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: GameColors.onSurface,
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

  void _analyzeEvidence(Evidence evidence) {
    if (_focusPointsUsed >= widget.gameCase.requiredFocusPoints) {
      _showMessage('Fokus puanın tükendi!');
      return;
    }

    setState(() {
      _unlockedEvidence.add(evidence.name);
      _focusPointsUsed += 1;
    });

    _showMessage('${evidence.name} analiz edildi!');
  }

  void _questionSuspect(Suspect suspect) {
    if (_focusPointsUsed >= widget.gameCase.requiredFocusPoints) {
      _showMessage('Fokus puanın tükendi!');
      return;
    }

    setState(() {
      _questionedSuspects.add(suspect.name);
      _focusPointsUsed += 2;
    });

    _showMessage('${suspect.name} sorgulandı!');
  }

  void _makeDeduction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Çıkarım'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Çıkarım Başlığı',
                hintText: 'Örn: Şüphelinin Motifi',
              ),
              onChanged: (value) {
                // Handle title input
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Çıkarım Detayı',
                hintText: 'Kanıtlardan çıkardığın sonuç...',
              ),
              maxLines: 3,
              onChanged: (value) {
                // Handle detail input
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add deduction logic here
              Navigator.of(context).pop();
              _showMessage('Çıkarım eklendi!');
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

List<String> _getWitnessDialogOptions(Witness witness) {
    return witness.dialogOptions.map((option) => option.text).toList();
  }

  void _showWitnessDialog(Witness witness, String option) {
  String response = witness.dialogOptions.firstWhere((element) => element.text == option).response;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(witness.name),
        content: Text(response),
        actions: [
          TextButton(
            child: Text("Tamam"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

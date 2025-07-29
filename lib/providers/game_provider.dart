import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/detective.dart';
import '../models/game_case.dart';
import '../services/case_service.dart';
import '../services/storage_service.dart';

class GameProvider with ChangeNotifier {
  Detective? _detective;
  List<GameCase> _cases = [];
  GameCase? _currentCase;
  bool _isLoading = false;
  String? _error;
  
  final CaseService _caseService = CaseService();
  final StorageService _storageService = StorageService();

  // Getters
  Detective? get detective => _detective;
  List<GameCase> get cases => _cases;
  GameCase? get currentCase => _currentCase;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<GameCase> get availableCases => _cases.where((c) => c.status == CaseStatus.available).toList();
  List<GameCase> get activeCases => _cases.where((c) => c.isActive).toList();
  List<GameCase> get completedCases => _cases.where((c) => c.isCompleted).toList();

  // İlk başlatma
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await loadDetective();
      await loadCases();
      if (_cases.isEmpty) {
        loadSampleCases();
        await saveCases();
      }
      _setError(null);
    } catch (e) {
      _setError('Başlatma hatası: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Loading state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Dedektif işlemleri
  Future<void> createDetective(String name) async {
    _setLoading(true);
    try {
      final now = DateTime.now();
      _detective = Detective(
        id: _generateId(),
        name: name,
        createdAt: now,
        lastLoginAt: now,
      );
      
      await _storageService.saveDetective(_detective!);
      _setError(null);
    } catch (e) {
      _setError('Dedektif oluşturulurken hata: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadDetective() async {
    try {
      _detective = await _storageService.loadDetective();
      if (_detective != null) {
        // Son login zamanını güncelle
        _detective = _detective!.copyWith(lastLoginAt: DateTime.now());
        await _storageService.saveDetective(_detective!);
      }
    } catch (e) {
      _setError('Dedektif yüklenirken hata: $e');
    }
  }

  // Deneyim ve seviye işlemleri
  Future<void> addExperience(int exp) async {
    if (_detective == null) return;
    
    try {
      final newExp = _detective!.experience + exp;
      final newLevel = _calculateLevel(newExp);
      
      _detective = _detective!.copyWith(
        experience: newExp,
        level: newLevel,
      );
      
      await _storageService.saveDetective(_detective!);
      notifyListeners();
    } catch (e) {
      _setError('Deneyim eklenirken hata: $e');
    }
  }

  int _calculateLevel(int experience) {
    return (experience ~/ 100) + 1;
  }

  // Fokus puanı işlemleri
  Future<bool> useFocusPoints(int points) async {
    if (_detective == null || _detective!.focusPoints < points) {
      return false;
    }
    
    try {
      _detective = _detective!.copyWith(
        focusPoints: _detective!.focusPoints - points,
      );
      
      await _storageService.saveDetective(_detective!);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Fokus puanı kullanılırken hata: $e');
      return false;
    }
  }

  Future<void> refreshFocusPoints() async {
    if (_detective == null) return;
    
    try {
      _detective = _detective!.copyWith(
        focusPoints: _detective!.maxFocusPoints,
      );
      
      await _storageService.saveDetective(_detective!);
      notifyListeners();
    } catch (e) {
      _setError('Fokus puanı yenilenirken hata: $e');
    }
  }

  // Dava işlemleri
  void loadSampleCases() {
    _cases = _caseService.getSampleCases();
    notifyListeners();
  }

  Future<void> saveCases() async {
    try {
      await _storageService.saveCases(_cases);
    } catch (e) {
      _setError('Davalar kaydedilirken hata: $e');
    }
  }

  Future<void> loadCases() async {
    try {
      _cases = await _storageService.loadCases();
      
      // Aktif davayı bul
      final activeCaseIndex = _cases.indexWhere((c) => c.isActive);
      if (activeCaseIndex != -1) {
        _currentCase = _cases[activeCaseIndex];
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Davalar yüklenirken hata: $e');
    }
  }

  Future<void> acceptCase(String caseId) async {
    if (_detective == null) return;
    
    try {
      final caseIndex = _cases.indexWhere((c) => c.id == caseId);
      if (caseIndex == -1) return;
      
      final gameCase = _cases[caseIndex];
      
      // Fokus puanı kontrolü
      if (!await useFocusPoints(gameCase.requiredFocusPoints)) {
        _setError('Yeterli fokus puanınız yok');
        return;
      }
      
      // Davayı kabul et
      _cases[caseIndex] = gameCase.copyWith(
        status: CaseStatus.accepted,
      );
      
      _currentCase = _cases[caseIndex];
      
      await saveCases();
      _setError(null);
    } catch (e) {
      _setError('Dava kabul edilirken hata: $e');
    }
  }

  Future<void> updateCaseStatus(String caseId, CaseStatus newStatus) async {
    try {
      final caseIndex = _cases.indexWhere((c) => c.id == caseId);
      if (caseIndex == -1) return;
      
      _cases[caseIndex] = _cases[caseIndex].copyWith(status: newStatus);
      
      // Eğer dava tamamlandıysa deneyim ver
      if (newStatus == CaseStatus.completed) {
        await addExperience(_cases[caseIndex].rewardExperience);
        await _updateStats('cases_completed', 1);
        _currentCase = null;
      }
      
      await saveCases();
      notifyListeners();
    } catch (e) {
      _setError('Dava durumu güncellenirken hata: $e');
    }
  }

  Future<void> updateCaseProgress(String caseId, Map<String, dynamic> gameData) async {
    try {
      final caseIndex = _cases.indexWhere((c) => c.id == caseId);
      if (caseIndex == -1) return;
      
      _cases[caseIndex] = _cases[caseIndex].copyWith(gameData: gameData);
      await saveCases();
      notifyListeners();
    } catch (e) {
      _setError('Dava ilerlemesi güncellenirken hata: $e');
    }
  }

  // Delil analizi
  Future<void> analyzeEvidence(String caseId, String evidenceId) async {
    try {
      final caseIndex = _cases.indexWhere((c) => c.id == caseId);
      if (caseIndex == -1) return;
      
      final gameCase = _cases[caseIndex];
      final evidenceIndex = gameCase.evidence.indexWhere((e) => e.id == evidenceId);
      if (evidenceIndex == -1) return;
      
      // Delil analizi simülasyonu
      final evidence = gameCase.evidence[evidenceIndex];
      final analyzedEvidence = evidence.copyWith(
        isAnalyzed: true,
        analysisResult: _generateAnalysisResult(evidence),
      );
      
      final updatedEvidence = List<Evidence>.from(gameCase.evidence);
      updatedEvidence[evidenceIndex] = analyzedEvidence;
      
      _cases[caseIndex] = gameCase.copyWith(evidence: updatedEvidence);
      
      await saveCases();
      notifyListeners();
    } catch (e) {
      _setError('Delil analiz edilirken hata: $e');
    }
  }

  String _generateAnalysisResult(Evidence evidence) {
    // Basit analiz sonucu üretici
    switch (evidence.type.toLowerCase()) {
      case 'silah':
        return 'Parmak izi tespit edildi. DNA analizi devam ediyor.';
      case 'kan':
        return 'A+ kan grubu tespit edildi. Kuruma süresi 2-3 saat.';
      case 'ayak izi':
        return '42 numara erkek ayakkabısı izi. Marka: Nike';
      default:
        return 'Analiz tamamlandı. Detaylar raporda mevcut.';
    }
  }

  // İstatistik güncelleme
  Future<void> _updateStats(String key, int increment) async {
    if (_detective == null) return;
    
    final currentStats = Map<String, dynamic>.from(_detective!.stats);
    currentStats[key] = (currentStats[key] ?? 0) + increment;
    
    _detective = _detective!.copyWith(stats: currentStats);
    await _storageService.saveDetective(_detective!);
  }

  // Yardımcı fonksiyonlar
  String _generateId() {
    final random = Random();
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           random.nextInt(1000).toString();
  }

  GameCase? getCaseById(String caseId) {
    try {
      return _cases.firstWhere((c) => c.id == caseId);
    } catch (e) {
      return null;
    }
  }

  // Reset (test için)
  Future<void> resetGame() async {
    try {
      await _storageService.clearAll();
      _detective = null;
      _cases = [];
      _currentCase = null;
      _setError(null);
      notifyListeners();
    } catch (e) {
      _setError('Oyun sıfırlanırken hata: $e');
    }
  }
}

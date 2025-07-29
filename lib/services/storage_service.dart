import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/detective.dart';
import '../models/game_case.dart';

class StorageService {
  static const String _detectiveKey = 'detective';
  static const String _casesKey = 'cases';
  static const String _settingsKey = 'settings';

  // Dedektif kaydetme ve yükleme
  Future<void> saveDetective(Detective detective) async {
    final prefs = await SharedPreferences.getInstance();
    final detectiveJson = json.encode(detective.toJson());
    await prefs.setString(_detectiveKey, detectiveJson);
  }

  Future<Detective?> loadDetective() async {
    final prefs = await SharedPreferences.getInstance();
    final detectiveJson = prefs.getString(_detectiveKey);
    
    if (detectiveJson != null) {
      final detectiveMap = json.decode(detectiveJson);
      return Detective.fromJson(detectiveMap);
    }
    
    return null;
  }

  // Dava kaydetme ve yükleme
  Future<void> saveCases(List<GameCase> cases) async {
    final prefs = await SharedPreferences.getInstance();
    final casesJson = json.encode(cases.map((c) => c.toJson()).toList());
    await prefs.setString(_casesKey, casesJson);
  }

  Future<List<GameCase>> loadCases() async {
    final prefs = await SharedPreferences.getInstance();
    final casesJson = prefs.getString(_casesKey);
    
    if (casesJson != null) {
      final casesList = json.decode(casesJson) as List;
      return casesList.map((c) => GameCase.fromJson(c)).toList();
    }
    
    return [];
  }

  // Ayarlar kaydetme ve yükleme
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = json.encode(settings);
    await prefs.setString(_settingsKey, settingsJson);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      return Map<String, dynamic>.from(json.decode(settingsJson));
    }
    
    return {
      'soundEnabled': true,
      'musicEnabled': true,
      'notificationsEnabled': true,
      'difficulty': 'medium',
    };
  }

  // Tek bir değer kaydetme ve yükleme
  Future<void> saveValue(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      // Kompleks objeler için JSON
      final jsonString = json.encode(value);
      await prefs.setString(key, jsonString);
    }
  }

  Future<T?> loadValue<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else {
      // Kompleks objeler için JSON
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as T?;
      }
    }
    
    return null;
  }

  // İstatistikler
  Future<void> saveGameStats(Map<String, dynamic> stats) async {
    await saveValue('game_stats', stats);
  }

  Future<Map<String, dynamic>> loadGameStats() async {
    final stats = await loadValue<Map<String, dynamic>>('game_stats');
    return stats ?? {
      'totalPlayTime': 0,
      'casesStarted': 0,
      'casesCompleted': 0,
      'averageCompletionTime': 0,
      'favoriteCase': '',
      'lastPlayDate': DateTime.now().toIso8601String(),
    };
  }

  // Son oyun durumunu kaydet
  Future<void> saveLastGameState(String caseId, Map<String, dynamic> state) async {
    await saveValue('last_game_state', {
      'caseId': caseId,
      'state': state,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> loadLastGameState() async {
    return await loadValue<Map<String, dynamic>>('last_game_state');
  }

  // Tümünü temizle
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Belirli anahtarları temizle
  Future<void> clearKeys(List<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  // Veri var mı kontrolü
  Future<bool> hasData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Tüm anahtarları listele
  Future<List<String>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList();
  }

  // Veri boyutunu hesapla (yaklaşık)
  Future<int> getDataSize() async {
    final prefs = await SharedPreferences.getInstance();
    int totalSize = 0;
    
    for (final key in prefs.getKeys()) {
      final value = prefs.get(key);
      if (value is String) {
        totalSize += value.length;
      } else {
        totalSize += value.toString().length;
      }
    }
    
    return totalSize;
  }

  // Veri yedekleme
  Future<Map<String, dynamic>> createBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final backup = <String, dynamic>{};
    
    for (final key in prefs.getKeys()) {
      backup[key] = prefs.get(key);
    }
    
    backup['backup_timestamp'] = DateTime.now().toIso8601String();
    backup['backup_version'] = '1.0.0';
    
    return backup;
  }

  // Veri geri yükleme
  Future<void> restoreBackup(Map<String, dynamic> backup) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Önce tümünü temizle
    await prefs.clear();
    
    // Yedeklenen verileri geri yükle (metadata hariç)
    for (final entry in backup.entries) {
      if (entry.key.startsWith('backup_')) continue;
      
      final value = entry.value;
      if (value is String) {
        await prefs.setString(entry.key, value);
      } else if (value is int) {
        await prefs.setInt(entry.key, value);
      } else if (value is double) {
        await prefs.setDouble(entry.key, value);
      } else if (value is bool) {
        await prefs.setBool(entry.key, value);
      }
    }
  }
}

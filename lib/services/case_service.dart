import '../models/game_case.dart';

class CaseService {
  // Örnek davalar (gerçek uygulamada API'dan gelecek)
  List<GameCase> getSampleCases() {
    return [
      _createParkMurderCase(),
      _createOfficePoisoningCase(),
      _createBankRobberyCase(),
    ];
  }

  GameCase _createParkMurderCase() {
    return GameCase(
      id: 'case_001',
      title: 'Parkta Cinayet',
      description: 'Şehir parkında bir ceset bulundu. Maktul 35 yaşında bir işadamıdır.',
      summary: 'Hakan Yılmaz adlı işadamı, Merkez Park\'ta bıçaklanarak öldürüldü.',
      difficulty: CaseDifficulty.easy,
      dateCreated: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Merkez Park',
      victimName: 'Hakan Yılmaz',
      rewardExperience: 100,
      requiredFocusPoints: 15,
      evidence: [
        Evidence(
          id: 'ev_001',
          name: 'Kanlı Bıçak',
          description: 'Parkta bulunan kanlı mutfak bıçağı. Üzerinde parmak izleri var.',
          type: 'Silah',
          location: 'Çalıların yanında',
        ),
        Evidence(
          id: 'ev_002',
          name: 'Ayak İzi',
          description: 'Çamurda erkek ayakkabı izi, 42 numara',
          type: 'İz',
          location: 'Cesedin yanında',
        ),
        Evidence(
          id: 'ev_003',
          name: 'Maktulün Cep Telefonu',
          description: 'Son aramalar listesinde şüpheli numaralar var',
          type: 'Dijital',
          location: 'Maktulün üzerinde',
        ),
      ],
      witnesses: [
        Witness(
          id: 'wit_001',
          name: 'Fatma Teyze',
          description: 'Park ziyaretçisi, olayı gören tek tanık',
          statement: 'Bir adam koşarak parktan çıkıyordu. Orta boylu ve esmer biriydi.',
          questions: [
            'Koşan kişiyi daha önce gördünüz mü?',
            'Hangi yöne koşuyordu?',
            'Üzerinde ne vardı?'
          ],
          answers: [
            'Hayır, ilk kez görüyordum',
            'Park çıkışına doğru koşuyordu',
            'Koyu renkli bir mont vardı üzerinde'
          ],
        ),
      ],
      suspects: [
        Suspect(
          id: 'sus_001',
          name: 'Mehmet Kaya',
          description: 'Maktulün eski iş ortağı',
          alibi: 'Evde televizyon izliyordum',
          relationship: 'Eski iş ortağı',
          motive: 'Para borcu 50.000 lira',
          suspicionLevel: 8,
          questions: [
            'Maktul ile aranızda problem var mıydı?',
            'O gece neredeydiniz?',
            'Borç konusu doğru mu?'
          ],
          answers: [
            'Evet, bana çok para borçluydu',
            'Evdeydim, kimse görmedi ama',
            'Tam 50.000 lira borcu vardı bana'
          ],
        ),
        Suspect(
          id: 'sus_002',
          name: 'Ayşe Demir',
          description: 'Maktulün eski sevgilisi',
          alibi: 'Arkadaşımla sinemadaydım',
          relationship: 'Eski sevgili',
          motive: 'Ayrılık sonrası kırgınlık',
          suspicionLevel: 3,
          questions: [
            'Ne zaman ayrıldınız?',
            'O gece neredeydiniz?',
            'Hâlâ görüşüyor muydunuz?'
          ],
          answers: [
            '6 ay önce ayrıldık',
            'Sinemadaydım, biletim var',
            'Hayır, hiç görüşmüyorduk'
          ],
        ),
      ],
      crimeSceneReport: CrimeSceneReport(
        id: 'csr_001',
        description: 'Maktul park içindeki bank yakınında yüzüstü yatar pozisyonda bulundu.',
        timeOfCrime: '20:30-21:00 arası',
        weatherConditions: 'Açık, 18°C, Hafif rüzgarlı',
        observations: 'Göğüs bölgesinde çoklu kesici alet yaraları var. Savunma yaraları yok. Olay yerinde kan izleri mevcut. Maktulün cüzdanı ve telefonu çalınmamış.',
        foundItems: [
          'Kan İzi',
          'Parmak İzi',
          'Ayak İzi'
        ],
        photographs: [
          'Genel olay yeri görüntüsü',
          'Maktulün pozisyonu',
          'Kan izleri detayı',
          'Bulunan deliller'
        ],
      ),
      autopsyReport: AutopsyReport(
        id: 'ar_001',
        victimName: 'Hakan Yılmaz',
        causeOfDeath: 'Göğüs bölgesine çoklu kesici alet yaraları',
        timeOfDeath: '27 Temmuz 2025, yaklaşık 20:30-21:00 arası',
        bodyCondition: 'Maktul sağlıklı bir bireydi',
        findings: [
          'Göğüs sol tarafında 4 adet derin kesik yara',
          'Kalp ve akciğerlere isabet',
          'Masif kan kaybı',
          'Sol pazı üzerinde hafif çizik'
        ],
        toxicologyResults: [
          'Kan ve idrar örneklerinde alkol tespit edilmedi',
          'Uyuşturucu madde tespit edilmedi'
        ],
      ),
      solution: 'Mehmet Kaya, Hakan Yılmaz\'a borçlu olduğu 50.000 lira yüzünden onu öldürdü.',
    );
  }

  GameCase _createOfficePoisoningCase() {
    return GameCase(
      id: 'case_002',
      title: 'Ofiste Zehirlenme',
      description: 'Bir muhasebe firmasında çalışan kadın, öğle yemeğinden sonra ofisinde ölü bulundu.',
      summary: 'Zeynep Aktaş adlı muhasebeci, ofisinde siyanür zehirlenmesinden öldü.',
      difficulty: CaseDifficulty.medium,
      dateCreated: DateTime.now().subtract(const Duration(hours: 6)),
      location: 'Centrum İş Merkezi',
      victimName: 'Zeynep Aktaş',
      rewardExperience: 150,
      requiredFocusPoints: 25,
      evidence: [
        Evidence(
          id: 'ev_004',
          name: 'Kahve Fincanı',
          description: 'Maktulün masasındaki kahve fincanında siyanür kalıntısı tespit edildi',
          type: 'Zehir',
          location: 'Maktulün masası',
        ),
        Evidence(
          id: 'ev_005',
          name: 'Güvenlik Kamerası Kaydı',
          description: '14:30-15:00 arası ofis koridoru görüntüleri',
          type: 'Dijital',
          location: 'Güvenlik odası',
        ),
        Evidence(
          id: 'ev_006',
          name: 'Siyanür Şişesi',
          description: 'Temizlik dolabında bulunan boş siyanür şişesi',
          type: 'Kimyasal',
          location: 'Temizlik dolabı',
        ),
      ],
      witnesses: [
        Witness(
          id: 'wit_002',
          name: 'Ahmet Bey',
          description: 'Komşu ofisten çalışan',
          statement: 'Temizlik görevlisinin öğle arası 5. kata çıktığını gördüm',
          questions: [
            'Temizlik arabasını gördiniz mi?',
            'Ne kadar süre kaldı yukarıda?',
            'Daha önce o saatte gelir miydi?'
          ],
          answers: [
            'Hayır, arabası yoktu yanında',
            'Yaklaşık 10-15 dakika',
            'Hayır, genelde öğle arası gelmezdi'
          ],
        ),
      ],
      suspects: [
        Suspect(
          id: 'sus_003',
          name: 'Kemal Özdemir',
          description: 'Maktul ile aynı pozisyonda çalışan muhasebeci',
          alibi: 'Toplantıdaydım, kayıtlar var',
          relationship: 'İş arkadaşı',
          motive: 'Terfi rekabeti',
          suspicionLevel: 4,
          questions: [
            'Maktul ile aranız nasıldı?',
            'Terfi konusunda rekabet var mıydı?',
            'O gün öğle arası neredeydiniz?'
          ],
          answers: [
            'İyi sayılırdı, çok konuşmazdık',
            'Evet, ikimiz de aynı pozisyon için yarışıyorduk',
            'Toplantı odasındaydım, müdürle konuşuyorduk'
          ],
        ),
        Suspect(
          id: 'sus_004',
          name: 'Hasan Kara',
          description: 'Temizlik görevlisi, siyanüre erişimi olan tek kişi',
          alibi: 'Alt katta temizlik yapıyordum',
          relationship: 'Tanımıyor',
          motive: 'Hırsızlığını gizlemek',
          suspicionLevel: 9,
          questions: [
            'Maktulü tanıyor muydunuz?',
            'Siyanürü ne için kullanıyorsunuz?',
            'O gün 5. kata çıktınız mı?'
          ],
          answers: [
            'Evet, beni hırsızlık yaparken görmüştü',
            'Böcek ilacı olarak kullanıyoruz',
            'Evet, temizlik yapmak için çıktım'
          ],
        ),
      ],
      crimeSceneReport: CrimeSceneReport(
        id: 'csr_002',
        description: 'Maktul ofis masasında sandalyede oturur pozisyonda bulundu.',
        timeOfCrime: '14:15-14:30 arası',
        weatherConditions: 'Kapalı, 22°C',
        observations: 'Masada yarım dolu kahve fincanı var. Bilgisayar açık durumda. Zehirlenme belirtileri mevcut. Dövüş ya da mücadele belirtisi yok.',
        foundItems: [
          'Kahve Fincanı',
          'Siyanür Kalıntısı',
          'Parmak İzi'
        ],
      ),
      autopsyReport: AutopsyReport(
        id: 'ar_002',
        victimName: 'Zeynep Aktaş',
        causeOfDeath: 'Siyanür zehirlenmesi',
        timeOfDeath: '28 Temmuz 2025, yaklaşık 14:15-14:30 arası',
        bodyCondition: 'Genel olarak sağlıklı',
        findings: [
          'Dış travma belirtisi yok',
          'Zehirlenmeye bağlı iç organ hasarı',
          'Kalp durması'
        ],
        toxicologyResults: [
          'Kan ve mide içeriğinde yüksek siyanür',
          'Kahve içerisinde alındığı belirlendi'
        ],
      ),
      solution: 'Hasan Kara, Zeynep Aktaş\'ı hırsızlığını ifşa etmemesi için öldürdü.',
    );
  }

  GameCase _createBankRobberyCase() {
    return GameCase(
      id: 'case_003',
      title: 'Banka Soygunu',
      description: 'Şehir merkezindeki bankaya silahlı soygun düzenlendi. Güvenlik görevlisi yaralandı.',
      summary: 'Maskeli soyguncu bankadan 200.000 lira çaldıktan sonra kaçtı.',
      difficulty: CaseDifficulty.hard,
      dateCreated: DateTime.now().subtract(const Duration(hours: 2)),
      location: 'Merkez Bankası',
      victimName: 'Güvenlik Görevlisi Ali Yıldız',
      rewardExperience: 200,
      requiredFocusPoints: 35,
      evidence: [
        Evidence(
          id: 'ev_007',
          name: 'Güvenlik Kamerası Kaydı',
          description: 'Soyguncunun bankaya giriş ve çıkış görüntüleri',
          type: 'Dijital',
          location: 'Güvenlik odası',
        ),
        Evidence(
          id: 'ev_008',
          name: 'Parmak İzi',
          description: 'Kasa üzerinde bulunan parmak izi',
          type: 'Biyolojik',
          location: 'Kasa',
        ),
        Evidence(
          id: 'ev_009',
          name: 'Düşen Cüzdan',
          description: 'Soyguncu kaçarken düşürdüğü cüzdan',
          type: 'Kişisel Eşya',
          location: 'Banka çıkışı',
        ),
      ],
      witnesses: [
        Witness(
          id: 'wit_003',
          name: 'Müşteri Ayşe Hanım',
          description: 'Soygun sırasında bankada bulunan müşteri',
          statement: 'Soyguncu tanıdık geldi, sanki daha önce görmüştüm',
          questions: [
            'Soyguncuyu nereden tanıyabilirsiniz?',
            'Sesini duydunuz mu?',
            'Kaç kişiydi?'
          ],
          answers: [
            'Komşumuzun oğluna benziyordu',
            'Evet, genç bir erkek sesiydi',
            'Tek kişiydi'
          ],
        ),
      ],
      suspects: [
        Suspect(
          id: 'sus_005',
          name: 'Emre Şahin',
          description: 'Eski banka çalışanı, işten çıkarılmış',
          alibi: 'Evdeydim, uyuyordum',
          relationship: 'Eski çalışan',
          motive: 'İşten çıkarılma intikamı',
          suspicionLevel: 7,
          questions: [
            'Bankadan neden ayrıldınız?',
            'Soygun saatinde neredeydiniz?',
            'Banka düzenini biliyor musunuz?'
          ],
          answers: [
            'Haksız yere işten çıkarıldım',
            'Evde uyuyordum, kimse görmedi',
            'Evet, 3 yıl çalıştım orada'
          ],
        ),
        Suspect(
          id: 'sus_006',
          name: 'Caner Demir',
          description: 'Mahalleli genç, maddi sıkıntısı var',
          alibi: 'Arkadaşlarımla kahvehanedeyim',
          relationship: 'Tanımıyor',
          motive: 'Maddi sıkıntı, borç',
          suspicionLevel: 8,
          questions: [
            'O gün neredeydiniz?',
            'Paraya ihtiyacınız var mıydı?',
            'Bankayı biliyor musunuz?'
          ],
          answers: [
            'Kahvehanedeyim, arkadaşlarım görür',
            'Evet, çok bordum vardı',
            'Evet, hep oradan geçerim'
          ],
        ),
      ],
      crimeSceneReport: CrimeSceneReport(
        id: 'csr_003',
        description: 'Banka içinde darmadağın, kasa açık, güvenlik görevlisi yerde.',
        timeOfCrime: '10:30 arası',
        weatherConditions: 'Güneşli, 25°C',
        observations: 'Kasa zorlanarak açılmış. Güvenlik görevlisi başından yaralı. Müşteriler korkudan titriyor. Soyguncu tek kişi.',
        foundItems: [
          'Parmak İzi',
          'Güvenlik Kamerası Kaydı',
          'Düşen Cüzdan'
        ],
      ),
      solution: 'Emre Şahin işten çıkarılma intikamı için bankayı soydu.',
    );
  }

  // Dava JSON dosyasından yükleme (ileride kullanılacak)
  Future<GameCase?> loadCaseFromAssets(String caseId) async {
    // TODO: assets/cases klasöründen JSON dosyası yükle
    return null;
  }

  // Dava verilerini doğrulama
  bool validateCase(GameCase gameCase) {
    if (gameCase.title.isEmpty) return false;
    if (gameCase.description.isEmpty) return false;
    if (gameCase.location.isEmpty) return false;
    if (gameCase.victimName.isEmpty) return false;
    if (gameCase.evidence.isEmpty) return false;
    if (gameCase.suspects.isEmpty) return false;
    
    return true;
  }

  // Dava zorluğuna göre filtreleme
  List<GameCase> getCasesByDifficulty(List<GameCase> cases, CaseDifficulty difficulty) {
    return cases.where((c) => c.difficulty == difficulty).toList();
  }

  // Tamamlanan davaları al
  List<GameCase> getCompletedCases(List<GameCase> cases) {
    return cases.where((c) => c.status == CaseStatus.completed).toList();
  }

  // Aktif davaları al
  List<GameCase> getActiveCases(List<GameCase> cases) {
    return cases.where((c) => c.isActive).toList();
  }
}

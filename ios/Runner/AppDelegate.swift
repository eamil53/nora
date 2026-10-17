import Flutter
import UIKit
import FamilyControls
import ManagedSettings
import SwiftUI
import Network
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@available(iOS 16.0, *)
struct AppPickerContentView: View {
  @Binding var selection: FamilyActivitySelection
  var onDismiss: () -> Void

  var body: some View {
    NavigationView {
      FamilyActivityPicker(headerText: "Engellenecek Mobil Uygulamaları Seçin", selection: $selection)
        .navigationTitle("Uygulama Engelleme")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Tamam") {
              onDismiss()
            }
            .fontWeight(.bold)
          }
        }
    }
  }
}

@available(iOS 16.0, *)
struct CustomDomainEntrySheet: View {
  var isTr: Bool = true
  var onSave: (String, String, Bool, String) -> Void
  var onDismiss: () -> Void

  @State private var domain: String = ""
  @State private var selectedCategory: String = ""
  @State private var enableWebKit: Bool = true
  @State private var enableRedirectShield: Bool = true
  @State private var notes: String = ""
  @State private var isDiscarding: Bool = false
  @FocusState private var isFieldFocused: Bool

  init(isTr: Bool = true, onSave: @escaping (String, String, Bool, String) -> Void, onDismiss: @escaping () -> Void) {
    self.isTr = isTr
    self.onSave = onSave
    self.onDismiss = onDismiss
    _selectedCategory = State(initialValue: isTr ? "Yasa Dışı Bahis & Casino" : "Illegal Betting & Casino")
  }

  private var categories: [String] {
    if isTr {
      return [
        "Yasa Dışı Bahis & Casino",
        "Slot & Canlı Casino",
        "Yasal Bahis Siteleri",
        "Kaldıraçlı Forex",
        "Özel Engelleme"
      ]
    } else {
      return [
        "Illegal Betting & Casino",
        "Slots & Live Casino",
        "Legal Betting Sites",
        "High-Risk Forex",
        "Custom Block"
      ]
    }
  }

  private var cleanDomain: String {
    domain.trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()
      .replacingOccurrences(of: "https://", with: "")
      .replacingOccurrences(of: "http://", with: "")
      .components(separatedBy: "/").first ?? ""
  }

  private var isValidDomain: Bool {
    let d = cleanDomain
    return d.count >= 3 && d.contains(".")
  }

  private var isDirty: Bool {
    !domain.isEmpty || !notes.isEmpty
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          HStack(spacing: 12) {
            Image(systemName: "globe")
              .foregroundColor(.accentColor)
              .font(.system(size: 18))
            TextField(isTr ? "Örn: betparibu.com" : "e.g. gambling-site.com", text: $domain)
              .textInputAutocapitalization(.never)
              .autocorrectionDisabled(true)
              .keyboardType(.URL)
              .focused($isFieldFocused)
          }
        } header: {
          Text(isTr ? "ALAN ADI" : "DOMAIN NAME")
        } footer: {
          Text(isTr
            ? "http:// veya https:// yazmanıza gerek yoktur. Nora girilen alan adını ve tüm yönlendirmelerini otomatik engeller."
            : "No need to enter http:// or https://. Nora automatically blocks the entered domain and all its redirects.")
            .font(.footnote)
        }

        Section {
          Picker(isTr ? "Kategori" : "Category", selection: $selectedCategory) {
            ForEach(categories, id: \.self) { cat in
              Text(cat).tag(cat)
            }
          }
          .pickerStyle(.menu)
        } header: {
          Text(isTr ? "ENGELLEME KATEGORİSİ" : "BLOCKING CATEGORY")
        }

        Section {
          Toggle(isOn: $enableWebKit) {
            VStack(alignment: .leading, spacing: 2) {
              Text(isTr ? "WebKit & Safari Kalkanı" : "WebKit & Safari Shield")
                .font(.body)
              Text(isTr ? "Safari ve tüm uygulama içi tarayıcılarda engelle" : "Block in Safari and all in-app browsers")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }

          Toggle(isOn: $enableRedirectShield) {
            VStack(alignment: .leading, spacing: 2) {
              Text(isTr ? "Yönlendirme Önleme" : "Redirect Shield")
                .font(.body)
              Text(isTr ? "Ayna ve klon adreslere geçişi engelle" : "Prevent navigation to mirror and clone URLs")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        } header: {
          Text(isTr ? "KORUMA DÜZEYİ" : "PROTECTION LEVEL")
        }

        Section {
          TextField(isTr
            ? "Tetikleyici siteler, neden engellediğiniz veya hedefleriniz..."
            : "Trigger domains, why you're blocking, or your recovery goals...", text: $notes, axis: .vertical)
            .lineLimit(3...5)
        } header: {
          Text(isTr ? "ENGELLEME GEREKÇESİ / NOT (İSTEĞE BAĞLI)" : "REASON / NOTE (OPTIONAL)")
        }
      }
      .navigationTitle(isTr ? "Web Sitesi Ekle" : "Add Website")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(isTr ? "Vazgeç" : "Cancel") {
            handleClose()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(isTr ? "Ekle" : "Add") {
            handleSave()
          }
          .fontWeight(.semibold)
          .disabled(!isValidDomain)
        }
      }
      .interactiveDismissDisabled(isDirty)
      .confirmationDialog(
        isTr ? "Değişiklikleri Sil" : "Discard Changes",
        isPresented: $isDiscarding,
        titleVisibility: .visible
      ) {
        Button(isTr ? "Değişiklikleri Sil" : "Discard Changes", role: .destructive) {
          onDismiss()
        }
        Button(isTr ? "Vazgeç" : "Cancel", role: .cancel) {}
      } message: {
        Text(isTr ? "Girdiğiniz alan adı kaydedilmeyecektir." : "The entered domain will not be saved.")
      }
    }
    .presentationDetents([.large])
    .presentationDragIndicator(.visible)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        isFieldFocused = true
      }
    }
  }

  private func handleClose() {
    isFieldFocused = false
    if isDirty {
      isDiscarding = true
    } else {
      onDismiss()
    }
  }

  private func handleSave() {
    guard isValidDomain else { return }
    let feedback = UIImpactFeedbackGenerator(style: .medium)
    feedback.impactOccurred()
    onSave(cleanDomain, selectedCategory, enableWebKit, notes)
  }
}

@available(iOS 16.0, *)
struct CustomJournalEntrySheet: View {
  var isTr: Bool = true
  var onSave: (String, Int, [String], String) -> Void
  var onDismiss: () -> Void

  @State private var selectedMood: String = ""
  @State private var cravingLevel: Int = 1
  @State private var selectedTriggers: Set<String> = []
  @State private var newTriggerInput: String = ""
  @State private var note: String = ""
  @State private var isDiscarding: Bool = false
  @FocusState private var isFieldFocused: Bool

  init(isTr: Bool = true, onSave: @escaping (String, Int, [String], String) -> Void, onDismiss: @escaping () -> Void) {
    self.isTr = isTr
    self.onSave = onSave
    self.onDismiss = onDismiss
    _selectedMood = State(initialValue: isTr ? "Sakin" : "Calm")
  }

  private var moods: [(name: String, icon: String, subtitle: String)] {
    if isTr {
      return [
        ("Harika", "sparkles", "Güçlü ve motivesin"),
        ("Sakin", "leaf.fill", "Dengeli ve huzurlusun"),
        ("Stresli", "bolt.fill", "Baskı altındasın"),
        ("Endişeli", "wind", "Tetiklenme hissediyorsun"),
        ("Zorlanıyor", "flame.fill", "Destek gerekebilir")
      ]
    } else {
      return [
        ("Great", "sparkles", "Strong and motivated"),
        ("Calm", "leaf.fill", "Balanced and peaceful"),
        ("Stressed", "bolt.fill", "Under pressure"),
        ("Anxious", "wind", "Feeling triggered"),
        ("Struggling", "flame.fill", "Support may be needed")
      ]
    }
  }

  private var quickTriggers: [String] {
    if isTr {
      return [
        "Stres",
        "Finansal Borç",
        "Sosyal Medya Reklamı",
        "Gece Yalnızlık",
        "Alkollü Ortam",
        "Yalnızlık",
        "Sıkıntı",
        "Kaybı Geri Kazanma Hırsı"
      ]
    } else {
      return [
        "Stress",
        "Financial Debt",
        "Social Media Ad",
        "Late Night Solitude",
        "Alcohol Environment",
        "Loneliness",
        "Boredom",
        "Chasing Losses"
      ]
    }
  }

  private var cravingTitle: String {
    if isTr {
      switch cravingLevel {
      case 1: return "1/5 - Sıfır Dürtü (Tam Kontrol)"
      case 2: return "2/5 - Hafif Dürtü (Yönetilebilir)"
      case 3: return "3/5 - Orta İstek (Dikkat Gerekli)"
      case 4: return "4/5 - Güçlü Kriz (Derin Nefes Al)"
      case 5: return "5/5 - Aşırı Kriz (Acil SOS Desteği)"
      default: return "\(cravingLevel)/5"
      }
    } else {
      switch cravingLevel {
      case 1: return "1/5 - Zero Urge (Full Control)"
      case 2: return "2/5 - Mild Urge (Manageable)"
      case 3: return "3/5 - Moderate Urge (Caution)"
      case 4: return "4/5 - Strong Urge (Deep Breaths)"
      case 5: return "5/5 - Extreme Urge (Emergency SOS)"
      default: return "\(cravingLevel)/5"
      }
    }
  }

  private var cravingColor: Color {
    switch cravingLevel {
    case 1: return Color.green
    case 2: return Color.mint
    case 3: return Color.yellow
    case 4: return Color.orange
    case 5: return Color.red
    default: return Color.blue
    }
  }

  private var defaultMood: String {
    isTr ? "Sakin" : "Calm"
  }

  private var isDirty: Bool {
    !note.isEmpty || !selectedTriggers.isEmpty || cravingLevel != 1 || selectedMood != defaultMood
  }

  var body: some View {
    NavigationStack {
      Form {
        // 1. Ruh Hali
        Section {
          Picker(isTr ? "Ruh Hali" : "Mood", selection: $selectedMood) {
            ForEach(moods, id: \.name) { m in
              Label(m.name, systemImage: m.icon).tag(m.name)
            }
          }
          .pickerStyle(.menu)

          HStack {
            if let current = moods.first(where: { $0.name == selectedMood }) {
              Image(systemName: current.icon)
                .foregroundColor(.accentColor)
                .font(.system(size: 16))
              Text(current.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
          }
        } header: {
          Text(isTr ? "ŞU AN NASIL HİSSEDİYORSUN?" : "HOW ARE YOU FEELING RIGHT NOW?")
        }

        // 2. İstek Şiddeti (Craving Level 1-5)
        Section {
          VStack(alignment: .leading, spacing: 12) {
            HStack {
              Text(isTr ? "İstek Düzeyi:" : "Urge Level:")
                .font(.subheadline)
                .foregroundColor(.secondary)
              Spacer()
              Text(cravingTitle)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(cravingColor)
            }

            Picker(isTr ? "İstek Seviyesi" : "Urge Level", selection: $cravingLevel) {
              Text("1").tag(1)
              Text("2").tag(2)
              Text("3").tag(3)
              Text("4").tag(4)
              Text("5").tag(5)
            }
            .pickerStyle(.segmented)
          }
          .padding(.vertical, 4)
        } header: {
          Text(isTr ? "KUMAR İSTEĞİ ŞİDDETİ" : "GAMBLING URGE INTENSITY")
        } footer: {
          Text(isTr
            ? "Dürtünün yükselip geçmesine izin ver. Yargılamadan seviyeni belirle."
            : "Allow the urge to rise and pass. Note your level without self-judgment.")
            .font(.footnote)
        }

        // 3. Tetikleyiciler
        Section {
          ForEach(quickTriggers, id: \.self) { trigger in
            HStack {
              Text(trigger)
              Spacer()
              if selectedTriggers.contains(trigger) {
                Image(systemName: "checkmark.circle.fill")
                  .foregroundColor(.accentColor)
              } else {
                Image(systemName: "circle")
                  .foregroundColor(.secondary.opacity(0.4))
              }
            }
            .contentShape(Rectangle())
            .onTapGesture {
              let feedback = UISelectionFeedbackGenerator()
              feedback.selectionChanged()
              if selectedTriggers.contains(trigger) {
                selectedTriggers.remove(trigger)
              } else {
                selectedTriggers.insert(trigger)
              }
            }
          }

          HStack {
            TextField(isTr ? "Özel tetikleyici yaz..." : "Type custom trigger...", text: $newTriggerInput)
            if !newTriggerInput.trimmingCharacters(in: .whitespaces).isEmpty {
              Button(isTr ? "Ekle" : "Add") {
                let trimmed = newTriggerInput.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                  selectedTriggers.insert(trimmed)
                  newTriggerInput = ""
                }
              }
              .buttonStyle(.borderedProminent)
              .controlSize(.small)
            }
          }
        } header: {
          Text(isTr ? "TETİKLEYİCİLER" : "TRIGGERS")
        } footer: {
          if !selectedTriggers.isEmpty {
            Text("\(isTr ? "Seçilenler:" : "Selected:") \(selectedTriggers.sorted().joined(separator: ", "))")
              .font(.footnote)
              .foregroundColor(.accentColor)
          }
        }

        // 4. Farkındalık / Şükran Notu
        Section {
          TextField(isTr
            ? "Bugün zihninden neler geçti? Seni ne zorladı veya güçlendirdi?..."
            : "What went through your mind today? What challenged or strengthened you?...", text: $note, axis: .vertical)
            .lineLimit(4...8)
            .focused($isFieldFocused)
        } header: {
          Text(isTr ? "FARKINDALIK & ŞÜKRAN NOTU" : "MINDFULNESS & REFLECTION NOTE")
        } footer: {
          Text(isTr
            ? "Düşüncelerini buraya dökmek, dürtü anında beynin mantık merkezini yeniden devreye sokar."
            : "Writing down your thoughts reactivates your rational prefrontal cortex during urges.")
            .font(.footnote)
        }
      }
      .navigationTitle(isTr ? "İrade Check-in" : "Willpower Check-in")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(isTr ? "Vazgeç" : "Cancel") {
            handleClose()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(isTr ? "Kaydet" : "Save") {
            handleSave()
          }
          .fontWeight(.semibold)
        }
      }
      .interactiveDismissDisabled(isDirty)
      .confirmationDialog(
        isTr ? "Değişiklikleri Sil" : "Discard Changes",
        isPresented: $isDiscarding,
        titleVisibility: .visible
      ) {
        Button(isTr ? "Değişiklikleri Sil" : "Discard Changes", role: .destructive) {
          onDismiss()
        }
        Button(isTr ? "Vazgeç" : "Cancel", role: .cancel) {}
      } message: {
        Text(isTr ? "Girdiğiniz check-in bilgileri kaydedilmeyecektir." : "Your check-in details will not be saved.")
      }
    }
    .presentationDetents([.large])
    .presentationDragIndicator(.visible)
  }

  private func handleClose() {
    isFieldFocused = false
    if isDirty {
      isDiscarding = true
    } else {
      onDismiss()
    }
  }

  private func handleSave() {
    let feedback = UIImpactFeedbackGenerator(style: .medium)
    feedback.impactOccurred()
    onSave(selectedMood, cravingLevel, Array(selectedTriggers), note)
  }
}


@main
@objc class AppDelegate: FlutterAppDelegate {
  @available(iOS 16.0, *)
  private static let storeName = ManagedSettingsStore.Name("com.kumaribirak.nora.store")
  
  private lazy var store: ManagedSettingsStore = {
    if #available(iOS 16.0, *) {
      return ManagedSettingsStore(named: Self.storeName)
    } else {
      return ManagedSettingsStore()
    }
  }()

  private let channelName = "com.nora.blocker/screentime"
  private let selectionStorageKey = "nora_family_activity_selection"
  private var isChannelSetup = false
  private let pathMonitor = NWPathMonitor()
  private var isPathMonitorVpnActive = false

  @available(iOS 16.0, *)
  private var activitySelection: FamilyActivitySelection {
    get {
      if let data = UserDefaults.standard.data(forKey: selectionStorageKey),
         let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
        return decoded
      }
      return FamilyActivitySelection()
    }
    set {
      if let encoded = try? JSONEncoder().encode(newValue) {
        UserDefaults.standard.set(encoded, forKey: selectionStorageKey)
      }
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    application.registerForRemoteNotifications()

    pathMonitor.pathUpdateHandler = { [weak self] path in
      let hasOther = path.usesInterfaceType(.other) || path.availableInterfaces.contains { $0.type == .other }
      self?.isPathMonitorVpnActive = (path.status == .satisfied && hasOther)
    }
    pathMonitor.start(queue: DispatchQueue.global(qos: .background))

    setupMethodChannelIfNeeded()
    restoreAppShieldingSelection()
    return result
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    #if DEBUG
    Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
    #else
    Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
    #endif
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    Messaging.messaging().appDidReceiveMessage(userInfo)

    var didUpdate = false
    if #available(iOS 15.0, *) {
      if let domains = userInfo["domains"] as? [String], !domains.isEmpty {
        self.updateWebFilters(domains: domains)
        didUpdate = true
        print("⚡ [AppDelegate] Silent Push updated \(domains.count) web filters directly.")
      } else if let domainStr = userInfo["domains"] as? String, !domainStr.isEmpty {
        let parts = domainStr.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        if !parts.isEmpty {
          self.updateWebFilters(domains: parts)
          didUpdate = true
          print("⚡ [AppDelegate] Silent Push updated \(parts.count) web filters from string.")
        }
      }
    }

    super.application(application, didReceiveRemoteNotification: userInfo) { result in
      completionHandler(didUpdate ? .newData : result)
    }
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ [AppDelegate] Failed to register for remote notifications: \(error.localizedDescription)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    setupMethodChannelIfNeeded()
    restoreAppShieldingSelection()
    if #available(iOS 15.0, *) {
      // Ensure App Store is never hidden
      store.application.denyAppInstallation = nil
    }
  }

  private func restoreAppShieldingSelection() {
    if #available(iOS 16.0, *) {
      applyAppShielding(selection: self.activitySelection)
    }
  }

  @available(iOS 16.0, *)
  private func applyAppShielding(selection: FamilyActivitySelection) {
    let hasApps = !selection.applicationTokens.isEmpty
    let hasCategories = !selection.categoryTokens.isEmpty
    let hasWebDomains = !selection.webDomainTokens.isEmpty

    if !hasApps && !hasCategories && !hasWebDomains {
      store.shield.applications = nil
      store.shield.applicationCategories = nil
      store.shield.webDomains = nil
    } else {
      store.shield.applications = hasApps ? selection.applicationTokens : nil
      store.shield.applicationCategories = hasCategories ? .specific(selection.categoryTokens) : nil
      store.shield.webDomains = hasWebDomains ? selection.webDomainTokens : nil
    }
  }

  private func setupMethodChannelIfNeeded() {
    guard !isChannelSetup else { return }
    guard let messenger = getBinaryMessenger() else { return }
    
    isChannelSetup = true
    let blockerChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    
    blockerChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      
      switch call.method {
      case "requestAuthorization":
        if #available(iOS 16.0, *) {
          Task {
            do {
              try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
              let status = AuthorizationCenter.shared.authorizationStatus
              DispatchQueue.main.async {
                if status == .approved {
                  result(true)
                } else {
                  result(false)
                }
              }
            } catch {
              print("[Nora] FamilyControls authorization failed: \(error.localizedDescription)")
              DispatchQueue.main.async {
                result(FlutterError(code: "AUTH_FAILED", message: error.localizedDescription, details: nil))
              }
            }
          }
        } else {
          result(FlutterError(code: "UNSUPPORTED", message: "iOS 16.0+ is required for Screen Time API", details: nil))
        }

      case "revokeAuthorization":
        if #available(iOS 16.0, *) {
          self.store.webContent.blockedByFilter = nil
          self.store.shield.applications = nil
          self.store.shield.applicationCategories = nil
          self.store.shield.webDomains = nil
          self.store.application.denyAppRemoval = nil
          self.store.application.denyAppInstallation = nil
          UserDefaults.standard.removeObject(forKey: self.selectionStorageKey)

          AuthorizationCenter.shared.revokeAuthorization { authResult in
            DispatchQueue.main.async {
              switch authResult {
              case .success:
                print("[Nora] FamilyControls authorization successfully revoked.")
                result(true)
              case .failure(let error):
                print("[Nora] FamilyControls revokeAuthorization failed: \(error.localizedDescription)")
                result(FlutterError(code: "REVOKE_FAILED", message: error.localizedDescription, details: nil))
              }
            }
          }
        } else if #available(iOS 15.0, *) {
          self.store.webContent.blockedByFilter = nil
          self.store.shield.applications = nil
          self.store.shield.applicationCategories = nil
          self.store.application.denyAppRemoval = nil
          self.store.application.denyAppInstallation = nil
          UserDefaults.standard.removeObject(forKey: self.selectionStorageKey)

          AuthorizationCenter.shared.revokeAuthorization { authResult in
            DispatchQueue.main.async {
              switch authResult {
              case .success:
                print("[Nora] FamilyControls authorization successfully revoked.")
                result(true)
              case .failure(let error):
                print("[Nora] FamilyControls revokeAuthorization failed: \(error.localizedDescription)")
                result(FlutterError(code: "REVOKE_FAILED", message: error.localizedDescription, details: nil))
              }
            }
          }
        } else {
          result(true)
        }

      case "checkAuthorizationStatus":
        if #available(iOS 16.0, *) {
          let status = AuthorizationCenter.shared.authorizationStatus
          switch status {
          case .approved:
            result("approved")
          case .denied:
            result("denied")
          case .notDetermined:
            result("notDetermined")
          @unknown default:
            result("unknown")
          }
        } else {
          result("unsupported")
        }

      case "selectAppsToBlock":
        if #available(iOS 16.0, *) {
          self.presentAppPicker(result: result)
        } else {
          result(FlutterError(code: "UNSUPPORTED", message: "iOS 16.0+ is required for App Shielding", details: nil))
        }

      case "presentAddDomainSheet":
        if #available(iOS 16.0, *) {
          let args = call.arguments as? [String: Any]
          let lang = (args?["languageCode"] as? String) ?? Locale.preferredLanguages.first ?? "en"
          let isTr = lang.lowercased().hasPrefix("tr")
          self.presentAddDomainSheet(isTr: isTr, result: result)
        } else {
          result(FlutterError(code: "UNSUPPORTED", message: "iOS 16.0+ is required for Add Domain Sheet", details: nil))
        }

      case "presentAddJournalEntrySheet":
        if #available(iOS 16.0, *) {
          let args = call.arguments as? [String: Any]
          let lang = (args?["languageCode"] as? String) ?? Locale.preferredLanguages.first ?? "en"
          let isTr = lang.lowercased().hasPrefix("tr")
          self.presentAddJournalEntrySheet(isTr: isTr, result: result)
        } else {
          result(FlutterError(code: "UNSUPPORTED", message: "iOS 16.0+ is required for Journal Entry Sheet", details: nil))
        }

      case "getShieldedAppInfo":
        if #available(iOS 16.0, *) {
          let sel = self.activitySelection
          let appsCount = sel.applicationTokens.count
          let catsCount = sel.categoryTokens.count
          let websCount = sel.webDomainTokens.count
          result([
            "appsCount": appsCount,
            "catsCount": catsCount,
            "webDomainsCount": websCount,
            "totalCount": appsCount + catsCount + websCount
          ])
        } else {
          result(["appsCount": 0, "catsCount": 0, "webDomainsCount": 0, "totalCount": 0])
        }

      case "setBlockedDomains":
        if #available(iOS 15.0, *) {
          guard let args = call.arguments as? [String: Any],
                let domains = args["domains"] as? [String] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Domains array required", details: nil))
            return
          }
          self.updateWebFilters(domains: domains)
          result(true)
        } else {
          result(true)
        }

      case "checkVpnStatus":
        let status = self.checkVpnStatus()
        result(status)

      case "setAntiBypassProtection":
        if #available(iOS 15.0, *) {
          let args = call.arguments as? [String: Any] ?? [:]
          let denyRemoval = args["denyAppRemoval"] as? Bool ?? true
          let denyInstallation = args["denyAppInstallation"] as? Bool ?? false
          self.setAntiBypassProtection(denyAppRemoval: denyRemoval, denyAppInstallation: denyInstallation)
          result(true)
        } else {
          result(true)
        }

      case "clearFilters":
        if #available(iOS 15.0, *) {
          self.store.webContent.blockedByFilter = nil
          self.store.shield.applications = nil
          self.store.shield.applicationCategories = nil
          self.store.application.denyAppRemoval = nil
          self.store.application.denyAppInstallation = nil
          if #available(iOS 16.0, *) {
            self.store.shield.webDomains = nil
          }
          UserDefaults.standard.removeObject(forKey: self.selectionStorageKey)
          result(true)
        } else {
          result(true)
        }

      case "scheduleAbandonedTrialNotification":
        let args = call.arguments as? [String: Any]
        let delaySeconds = (args?["delaySeconds"] as? Double) ?? 300.0
        let title = (args?["title"] as? String) ?? "🛡️ Nora Kalkanın Henüz Aktif Değil!"
        let body = (args?["body"] as? String) ?? "Kumar dürtüleri en savunmasız anında gelir. 0 ₺ ile 7 günlük ücretsiz denemeni hemen başlat, paranı ve sevdiklerini hemen güvenceye al."
        self.scheduleAbandonedTrialNotification(delaySeconds: delaySeconds, title: title, body: body)
        result(true)

      case "cancelAbandonedTrialNotification":
        self.cancelAbandonedTrialNotification()
        result(true)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  @available(iOS 16.0, *)
  private func presentAppPicker(result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard let rootVC = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first?.rootViewController else {
          result(FlutterError(code: "NO_VC", message: "Unable to find root view controller", details: nil))
          return
      }

      var currentSelection = self.activitySelection

      let pickerVC = UIHostingController(rootView: AppPickerContentView(
        selection: Binding(
          get: { currentSelection },
          set: { currentSelection = $0 }
        ),
        onDismiss: {
          rootVC.dismiss(animated: true) {
            self.activitySelection = currentSelection
            self.applyAppShielding(selection: currentSelection)
            let appsCount = currentSelection.applicationTokens.count
            let catsCount = currentSelection.categoryTokens.count
            let websCount = currentSelection.webDomainTokens.count
            result([
              "appsCount": appsCount,
              "catsCount": catsCount,
              "webDomainsCount": websCount,
              "totalCount": appsCount + catsCount + websCount
            ])
          }
        }
      ))

      pickerVC.modalPresentationStyle = .formSheet
      rootVC.present(pickerVC, animated: true, completion: nil)
    }
  }

  @available(iOS 16.0, *)
  private func presentAddDomainSheet(isTr: Bool, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard let rootVC = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first?.rootViewController else {
          result(FlutterError(code: "NO_VC", message: "Unable to find root view controller", details: nil))
          return
      }

      var sheetVC: UIHostingController<CustomDomainEntrySheet>?

      let sheetView = CustomDomainEntrySheet(
        isTr: isTr,
        onSave: { domain, category, enableWebKit, notes in
          sheetVC?.dismiss(animated: true) {
            result([
              "domain": domain,
              "category": category,
              "enableWebKit": enableWebKit,
              "notes": notes
            ])
          }
        },
        onDismiss: {
          sheetVC?.dismiss(animated: true) {
            result(nil)
          }
        }
      )

      sheetVC = UIHostingController(rootView: sheetView)
      sheetVC?.modalPresentationStyle = .pageSheet
      if let sheet = sheetVC?.sheetPresentationController {
        sheet.detents = [.large()]
        sheet.selectedDetentIdentifier = .large
        sheet.prefersGrabberVisible = true
      }

      var presenter = rootVC
      while let next = presenter.presentedViewController {
        presenter = next
      }
      presenter.present(sheetVC!, animated: true, completion: nil)
    }
  }

  @available(iOS 16.0, *)
  private func presentAddJournalEntrySheet(isTr: Bool, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard let rootVC = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first?.rootViewController else {
          result(FlutterError(code: "NO_VC", message: "Unable to find root view controller", details: nil))
          return
      }

      var sheetVC: UIHostingController<CustomJournalEntrySheet>?

      let sheetView = CustomJournalEntrySheet(
        isTr: isTr,
        onSave: { mood, cravingLevel, triggers, note in
          sheetVC?.dismiss(animated: true) {
            result([
              "mood": mood,
              "cravingLevel": cravingLevel,
              "triggers": triggers,
              "note": note,
              "timestamp": ISO8601DateFormatter().string(from: Date())
            ])
          }
        },
        onDismiss: {
          sheetVC?.dismiss(animated: true) {
            result(nil)
          }
        }
      )

      sheetVC = UIHostingController(rootView: sheetView)
      sheetVC?.modalPresentationStyle = .pageSheet
      if let sheet = sheetVC?.sheetPresentationController {
        sheet.detents = [.large()]
        sheet.selectedDetentIdentifier = .large
        sheet.prefersGrabberVisible = true
      }

      var presenter = rootVC
      while let next = presenter.presentedViewController {
        presenter = next
      }
      presenter.present(sheetVC!, animated: true, completion: nil)
    }
  }

  private func getBinaryMessenger() -> FlutterBinaryMessenger? {
    if let controller = window?.rootViewController as? FlutterViewController {
      return controller.binaryMessenger
    }
    if let registrar = self.registrar(forPlugin: "NoraScreenTimePlugin") {
      return registrar.messenger()
    }
    for scene in UIApplication.shared.connectedScenes {
      if let windowScene = scene as? UIWindowScene {
        for window in windowScene.windows {
          if let controller = window.rootViewController as? FlutterViewController {
            return controller.binaryMessenger
          }
        }
      }
    }
    return nil
  }

  @available(iOS 15.0, *)
  private func updateWebFilters(domains: [String]) {
    var uniqueDomains = [String]()
    var seen = Set<String>()
    
    for d in domains {
      var clean = d.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
      clean = clean.replacingOccurrences(of: "https://", with: "")
      clean = clean.replacingOccurrences(of: "http://", with: "")
      if let slashIdx = clean.firstIndex(of: "/") {
        clean = String(clean[..<slashIdx])
      }
      if clean.hasPrefix("www.") {
        clean = String(clean.dropFirst(4))
      }
      guard !clean.isEmpty, !seen.contains(clean) else { continue }
      seen.insert(clean)
      uniqueDomains.append(clean)
    }

    // Apple ManagedSettings .specific filter shields explicitly provided web domains (*.domain.com matching subdomains automatically).
    // System limit is around 50 domains for WebDomain objects.
    let cappedDomains = Array(uniqueDomains.prefix(50))
    let webDomains = Set(cappedDomains.compactMap { WebDomain(domain: $0) })
    
    if webDomains.isEmpty {
      store.webContent.blockedByFilter = nil
    } else {
      store.webContent.blockedByFilter = .specific(webDomains)
    }
  }

  private func checkVpnStatus() -> [String: Any] {
    var isVpn = isPathMonitorVpnActive
    var isProxy = false
    var detectedInterface = isVpn ? "VPN" : ""

    // 1. Direct real-time path check via NWPathMonitor
    let currentPath = pathMonitor.currentPath
    if currentPath.status == .satisfied {
      if currentPath.usesInterfaceType(.other) || currentPath.availableInterfaces.contains(where: { $0.type == .other }) {
        isVpn = true
        if let otherIface = currentPath.availableInterfaces.first(where: { $0.type == .other }) {
          detectedInterface = otherIface.name
        }
      }
    }

    // 2. Check System Proxy and scoped VPN tunnel interfaces
    if let dict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] {
      if let httpEnable = dict["HTTPEnable"] as? Int, httpEnable == 1 { isProxy = true }
      if let httpsEnable = dict["HTTPSEnable"] as? Int, httpsEnable == 1 { isProxy = true }
      if let pacEnable = dict["ProxyAutoConfigEnable"] as? Int, pacEnable == 1 { isProxy = true }
      if let scoped = dict["__SCOPED__"] as? [String: Any] {
        for key in scoped.keys {
          let lower = key.lowercased()
          // Only true VPN tunnel adapters in scoped routing table:
          if lower.hasPrefix("tap") || lower.hasPrefix("tun") || lower.hasPrefix("ppp") || lower.hasPrefix("ipsec") {
            isVpn = true
            if detectedInterface.isEmpty { detectedInterface = key }
            break
          }
        }
      }
    }

    return [
      "isVpnActive": isVpn,
      "isProxyActive": isProxy,
      "interface": detectedInterface
    ]
  }

  @available(iOS 15.0, *)
  private func setAntiBypassProtection(denyAppRemoval: Bool, denyAppInstallation: Bool) {
    // App Store must always remain visible and accessible
    store.application.denyAppInstallation = nil

    // Protect against app deletion when anti-bypass is enabled
    store.application.denyAppRemoval = denyAppRemoval ? true : nil
  }

  // --- Abandoned Trial Push Notification Trigger ---
  private func scheduleAbandonedTrialNotification(delaySeconds: Double, title: String, body: String) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["nora_abandoned_trial_5m"])

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.userInfo = ["screen": "paywall", "type": "abandoned_trial"]

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(delaySeconds, 1.0), repeats: false)
    let request = UNNotificationRequest(identifier: "nora_abandoned_trial_5m", content: content, trigger: trigger)

    center.add(request) { error in
      if let error = error {
        print("❌ [Nora] Failed to schedule abandoned trial notification: \(error.localizedDescription)")
      } else {
        print("✅ [Nora] Abandoned trial notification scheduled in \(delaySeconds)s: \"\(title)\"")
      }
    }
  }

  private func cancelAbandonedTrialNotification() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["nora_abandoned_trial_5m"])
    print("ℹ️ [Nora] Abandoned trial notification cancelled")
  }
}

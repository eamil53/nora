import Flutter
import UIKit
import FamilyControls
import ManagedSettings
import SwiftUI

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

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let store = ManagedSettingsStore()
  private let channelName = "com.nora.blocker/screentime"
  private let selectionStorageKey = "nora_family_activity_selection"
  private var isChannelSetup = false

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
    GeneratedPluginRegistrant.register(with: self)
    setupMethodChannelIfNeeded()
    restoreAppShieldingSelection()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    setupMethodChannelIfNeeded()
    restoreAppShieldingSelection()
  }

  private func restoreAppShieldingSelection() {
    if #available(iOS 16.0, *) {
      applyAppShielding(selection: self.activitySelection)
    }
  }

  @available(iOS 16.0, *)
  private func applyAppShielding(selection: FamilyActivitySelection) {
    if selection.applicationTokens.isEmpty && selection.categoryTokens.isEmpty {
      store.shield.applications = nil
      store.shield.applicationCategories = nil
    } else {
      store.shield.applications = selection.applicationTokens
      store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
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
              result(true)
            } catch {
              print("[Nora] FamilyControls authorization failed: \(error.localizedDescription)")
              result(FlutterError(code: "AUTH_FAILED", message: error.localizedDescription, details: nil))
            }
          }
        } else {
          result(FlutterError(code: "UNSUPPORTED", message: "iOS 16.0+ is required for Screen Time API", details: nil))
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

      case "getShieldedAppInfo":
        if #available(iOS 16.0, *) {
          let sel = self.activitySelection
          result([
            "appsCount": sel.applicationTokens.count,
            "catsCount": sel.categoryTokens.count,
            "totalCount": sel.applicationTokens.count + sel.categoryTokens.count
          ])
        } else {
          result(["appsCount": 0, "catsCount": 0, "totalCount": 0])
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

      case "clearFilters":
        if #available(iOS 15.0, *) {
          self.store.webContent.blockedByFilter = nil
          self.store.shield.applications = nil
          self.store.shield.applicationCategories = nil
          result(true)
        } else {
          result(true)
        }

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
            result([
              "appsCount": appsCount,
              "catsCount": catsCount,
              "totalCount": appsCount + catsCount
            ])
          }
        }
      ))

      pickerVC.modalPresentationStyle = .formSheet
      rootVC.present(pickerVC, animated: true, completion: nil)
    }
  }

  private func getBinaryMessenger() -> FlutterBinaryMessenger? {
    if let registrar = self.registrar(forPlugin: "NoraScreenTimePlugin") {
      return registrar.messenger()
    }
    if let controller = window?.rootViewController as? FlutterViewController {
      return controller.binaryMessenger
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
    var allDomains = Set<String>()
    
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
      guard !clean.isEmpty else { continue }
      
      allDomains.insert(clean)
      allDomains.insert("www." + clean)
      allDomains.insert("api." + clean)
      allDomains.insert("m." + clean)
      allDomains.insert("mobile." + clean)
      allDomains.insert("app." + clean)
      allDomains.insert("dms." + clean)
      allDomains.insert("ws." + clean)
      allDomains.insert("cdn." + clean)
      allDomains.insert("iddaa." + clean)
      allDomains.insert("live." + clean)
    }

    let webDomains = Set(allDomains.compactMap { WebDomain(domain: $0) })
    
    if webDomains.isEmpty {
      store.webContent.blockedByFilter = nil
    } else {
      store.webContent.blockedByFilter = .specific(webDomains)
    }
  }
}

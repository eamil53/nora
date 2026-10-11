//
//  ShieldConfigurationExtension.swift
//  NoraShieldConfiguration
//
//  Created by Enver Amil on 11.08.2026.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private func createNoraShield(title: String, subtitle: String) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterialDark,
            backgroundColor: UIColor(red: 11/255, green: 17/255, blue: 32/255, alpha: 0.95),
            title: ShieldConfiguration.Label(text: title, color: .white),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: UIColor(white: 0.75, alpha: 1.0)),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Koru ve Kapat", color: UIColor(red: 11/255, green: 17/255, blue: 32/255, alpha: 1.0)),
            primaryButtonBackgroundColor: UIColor(red: 0/255, green: 230/255, blue: 118/255, alpha: 1.0)
        )
    }

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return createNoraShield(
            title: "Nora Koruma Kalkanı",
            subtitle: "Bu uygulama Nora tarafından engellenmiştir. Sağlığınız ve hedefleriniz için güçlü kalın."
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        return createNoraShield(
            title: "Kategori Engellendi",
            subtitle: "Bu kategori kapsamındaki uygulamalar Nora koruma kalkanı ile kilitlenmiştir."
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return createNoraShield(
            title: "Erişim Engellendi",
            subtitle: "Bu web sitesi Nora kumar ve bahis engelleme filtresi tarafından kısıtlanmıştır."
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return createNoraShield(
            title: "Zararlı İçerik Engellendi",
            subtitle: "Bu kategoriye ait web sitesi Nora kalkanı tarafından engellenmiştir."
        )
    }
}

import SwiftUI
import UIKit

/// Brand colors copied from the Android app (OsdaColors), with light and dark values.
extension Color {
    static let osdaBackground = Color(light: 0xF7F5F2, dark: 0x121218)
    static let osdaSurface = Color(light: 0xFFFFFF, dark: 0x1B1B22)
    static let osdaBorder = Color(light: 0xEAE8E4, dark: 0x2E2E38)
    static let osdaPrimary = Color(light: 0x14123A, dark: 0xBFBFE5)
    static let osdaOnPrimary = Color(light: 0xFFFFFF, dark: 0x14123A)
    static let osdaPrimaryMuted = Color(light: 0xBFBFE5, dark: 0x3A3870)
    static let osdaHeading = Color(light: 0x1A1A2E, dark: 0xF2F1F7)
    static let osdaMuted = Color(light: 0x6D6D7F, dark: 0xA3A3B5)
    static let osdaError = Color(light: 0xC62828, dark: 0xFF8A80)

    init(light: UInt32, dark: UInt32) {
        self.init(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

private extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}

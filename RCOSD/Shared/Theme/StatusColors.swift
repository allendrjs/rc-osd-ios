import SwiftUI

/// Status colors from the Android app (OsdaTokens), light and dark.
extension Color {
    static let osdaGreen = Color(light: 0x1A7945, dark: 0x6FE3A0)
    static let osdaGreenBg = Color(light: 0xDCF5E3, dark: 0x123822)
    static let osdaAmber = Color(light: 0x916515, dark: 0xFFC65C)
    static let osdaAmberBg = Color(light: 0xFDF1D6, dark: 0x3A2E10)
    static let osdaRed = Color(light: 0xC22B2B, dark: 0xFF8A8A)
    static let osdaRedBg = Color(light: 0xFBDFDF, dark: 0x3A1414)
    static let osdaBlue = Color(light: 0x2B5FC2, dark: 0x7FAFFF)
    static let osdaBlueBg = Color(light: 0xDCE8FB, dark: 0x16233A)
}

enum StatusStyle {
    /// Offense record: RESOLVED/APPROVED green, PROCESSING blue, others amber.
    static func record(_ status: String) -> (fg: Color, bg: Color) {
        switch status.uppercased() {
        case "RESOLVED", "APPROVED": return (.osdaGreen, .osdaGreenBg)
        case "PROCESSING": return (.osdaBlue, .osdaBlueBg)
        default: return (.osdaAmber, .osdaAmberBg)
        }
    }

    /// Appeal: APPROVED green, DENIED red, others amber.
    static func appeal(_ status: String) -> (fg: Color, bg: Color) {
        switch status.uppercased() {
        case "APPROVED": return (.osdaGreen, .osdaGreenBg)
        case "DENIED": return (.osdaRed, .osdaRedBg)
        default: return (.osdaAmber, .osdaAmberBg)
        }
    }

    /// "UNDER_REVIEW" -> "Under review" (Android: toDisplayStatus)
    static func displayText(_ status: String) -> String {
        let lower = status.lowercased().replacingOccurrences(of: "_", with: " ")
        return lower.prefix(1).uppercased() + lower.dropFirst()
    }
}

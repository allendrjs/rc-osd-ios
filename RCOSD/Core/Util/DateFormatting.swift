import Foundation

/// One place for date display, matching the Android app:
/// dates `MM/dd/yyyy`, date-time `MM/dd/yyyy · h:mm a`.
enum DateFormatting {
    private static let posix = Locale(identifier: "en_US_POSIX")

    private static let dateOut: DateFormatter = {
        let f = DateFormatter()
        f.locale = posix
        f.dateFormat = "MM/dd/yyyy"
        return f
    }()

    private static let dateTimeOut: DateFormatter = {
        let f = DateFormatter()
        f.locale = posix
        f.dateFormat = "MM/dd/yyyy · h:mm a"
        return f
    }()

    /// Formats the backend may send: ISO-8601 with or without zone/fraction, or a plain date.
    private static let inputFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
        "yyyy-MM-dd'T'HH:mm:ssXXXXX",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd"
    ]

    private static let parsers: [DateFormatter] = inputFormats.map { format in
        let f = DateFormatter()
        f.locale = posix
        f.timeZone = TimeZone(identifier: "Asia/Manila")
        f.dateFormat = format
        return f
    }

    static func parse(_ raw: String?) -> Date? {
        guard let raw, !raw.isEmpty else { return nil }
        for parser in parsers {
            if let date = parser.date(from: raw) { return date }
        }
        return nil
    }

    /// "10/07/2026", or `fallback` when the value is missing or unreadable.
    static func date(_ raw: String?, fallback: String = "Not on file") -> String {
        guard let date = parse(raw) else { return fallback }
        return dateOut.string(from: date)
    }

    /// "10/07/2026 · 3:30 PM", or `fallback`.
    static func dateTime(_ raw: String?, fallback: String = "Not on file") -> String {
        guard let date = parse(raw) else { return fallback }
        return dateTimeOut.string(from: date)
    }
}

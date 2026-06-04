import SwiftUI

enum WWTypography {
    /// The Welcome splash brand lockup — the single largest type in the app.
    static let wordmark = Font.system(size: 56, weight: .bold, design: .rounded)
    /// Hero screen title (Home).
    static let display = Font.system(size: 42, weight: .semibold, design: .rounded)
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 24, weight: .bold, design: .rounded)
    /// Feed card intention — the one large headline that lives inside a card, not at screen top.
    static let cardTitle = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    /// Centered title inside a sheet or custom top bar.
    static let barTitle = Font.system(size: 15, weight: .semibold, design: .rounded)
    /// A larger, softer body for hero subtitles and taglines.
    static let lead = Font.system(size: 18, weight: .regular, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let caption = Font.system(size: 14, weight: .medium, design: .rounded)
    /// All-caps kicker above a title.
    static let eyebrow = Font.system(size: 12, weight: .semibold, design: .rounded)
}

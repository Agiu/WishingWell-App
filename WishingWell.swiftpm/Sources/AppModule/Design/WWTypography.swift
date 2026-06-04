import SwiftUI

/// The app's type scale.
///
/// Body- and label-level tokens are built on semantic `TextStyle`s so they scale
/// with the user's Dynamic Type setting (and re-render when it changes). Each style
/// was chosen so its default size matches the intended size, so the look is stable
/// at the default setting and grows for accessibility sizes.
///
/// The two brand display sizes (`wordmark`, `display`) stay fixed: there is no text
/// style near 42–56pt, and very large display type scaling tends to break layout.
enum WWTypography {
    /// The Welcome splash brand lockup — the single largest type in the app. Fixed.
    static let wordmark = Font.system(size: 56, weight: .bold, design: .rounded)
    /// Hero screen title (Home). Fixed.
    static let display = Font.system(size: 42, weight: .semibold, design: .rounded)

    /// Standard screen title (~34).
    static let largeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
    /// Section title (~22–24).
    static let title = Font.system(.title2, design: .rounded).weight(.bold)
    /// Feed card intention and hero statements — a large headline inside a card (~22–24).
    static let cardTitle = Font.system(.title2, design: .rounded).weight(.semibold)
    /// Lead body for hero subtitles and taglines (~18–20).
    static let lead = Font.system(.title3, design: .rounded).weight(.regular)
    /// Item and section labels (~17).
    static let headline = Font.system(.headline, design: .rounded)
    /// Default body text (~16–17).
    static let body = Font.system(.body)
    /// Centered title inside a sheet or custom top bar (~15).
    static let barTitle = Font.system(.subheadline, design: .rounded).weight(.semibold)
    /// Captions and metadata (~13–14).
    static let caption = Font.system(.footnote, design: .rounded).weight(.medium)
    /// All-caps kicker above a title (~12).
    static let eyebrow = Font.system(.caption, design: .rounded).weight(.semibold)
}

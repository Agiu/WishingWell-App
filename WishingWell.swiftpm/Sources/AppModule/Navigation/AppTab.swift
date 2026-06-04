import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case feed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "My Well"
        case .feed:
            return "Feed"
        }
    }

    var symbolName: String {
        switch self {
        case .home:
            return "drop.circle"
        case .feed:
            return "rectangle.stack"
        }
    }
}

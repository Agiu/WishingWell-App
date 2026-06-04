import SwiftUI

struct AppBackButton: View {
    static let size: CGFloat = 36

    let accessibilityLabel: String
    let action: () -> Void

    init(accessibilityLabel: String = "Back", action: @escaping () -> Void) {
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    var body: some View {
        GlassIconButton(
            systemImage: "chevron.left",
            accessibilityLabel: accessibilityLabel,
            action: action
        )
    }
}

struct AppBackButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AtmosphericBackground()
            AppBackButton {}
        }
    }
}

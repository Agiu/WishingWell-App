import SwiftUI

struct GlassIconButton: View {
    let systemImage: String
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(WWColor.deepWell.opacity(0.84))
                .frame(width: 36, height: 36)
                .appGlassCircle(fillOpacity: 0.22, strokeOpacity: 0.22, shadowOpacity: 0.07, shadowRadius: 8, shadowY: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

struct GlassIconButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AtmosphericBackground()
            GlassIconButton(systemImage: "water.waves", accessibilityLabel: "Ripples") {}
        }
    }
}

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(WWColor.deepWell)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [WWColor.warmIvory, Color.white],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.7), lineWidth: 0.8)
                }
                .shadow(color: WWColor.gold.opacity(0.28), radius: 22, y: 8)
                .shadow(color: WWColor.deepWell.opacity(0.22), radius: 10, y: 4)
                .clipShape(Capsule())
        }
        .buttonStyle(PrimaryButtonStyle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

/// Gives the primary action a tactile press: a gentle scale and dimming.
private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Cast a Wish", systemImage: "sparkles") {}
            .padding()
            .background(WWColor.deepWell)
    }
}

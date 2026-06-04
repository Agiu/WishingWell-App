import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(WWColor.luminousText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background {
                    Capsule()
                        .fill(WWColor.deepWell.opacity(0.62))
                }
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.18), lineWidth: 0.8)
                }
                .shadow(color: .black.opacity(0.10), radius: 14, y: 7)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Cast a Wish", systemImage: "sparkles") {}
            .padding()
    }
}

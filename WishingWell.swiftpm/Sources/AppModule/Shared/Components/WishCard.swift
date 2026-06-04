import SwiftUI

struct WishCard: View {
    let wish: Wish

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(alignment: .firstTextBaseline) {
                Text(wish.title)
                    .font(WWTypography.headline)
                    .foregroundStyle(WWColor.luminousText)

                Spacer()

                StatusBadge(status: wish.status)
            }

            Text(wish.intention)
                .font(WWTypography.body)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                .lineLimit(3)
        }
        .padding(AppSpacing.md)
        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
    }
}

private struct StatusBadge: View {
    let status: Wish.Status

    var body: some View {
        Text(status.rawValue)
            .font(WWTypography.caption)
            .foregroundStyle(WWColor.luminousText)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 5)
            .background(color.opacity(0.24), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.46), lineWidth: 1)
            )
    }

    private var color: Color {
        switch status {
        case .planted:
            return WWColor.mint
        case .rippling:
            return WWColor.mistLavender
        case .blooming:
            return WWColor.gold
        }
    }
}

struct WishCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AtmosphericBackground()
            WishCard(wish: Wish.samples[0])
                .padding()
        }
    }
}

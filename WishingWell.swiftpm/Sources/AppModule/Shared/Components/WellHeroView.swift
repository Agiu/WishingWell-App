import SwiftUI

struct WellHeroView: View {
    var body: some View {
        ZStack {
            Color.clear
                .appGlassHeroSurface()

            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                RipplePortalView()
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("A quiet place for what wants to become real.")
                        .font(WWTypography.caption)
                        .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                        .textCase(.uppercase)

                    Text("What are you ready to place into motion?")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(WWColor.luminousText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(AppSpacing.lg)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 292)
    }
}

private struct RipplePortalView: View {
    var body: some View {
        ZStack {
            Ellipse()
                .fill(WWColor.deepWell.opacity(0.38))
                .frame(width: 218, height: 76)
                .blur(radius: 18)
                .offset(y: 34)

            ForEach(0..<4) { index in
                Ellipse()
                    .stroke(rippleColor(for: index), lineWidth: index == 0 ? 1.8 : 1)
                    .frame(width: CGFloat(92 + index * 34), height: CGFloat(30 + index * 14))
                    .offset(y: CGFloat(index * 4))
            }

            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            WWColor.warmIvory.opacity(0.82),
                            WWColor.gold.opacity(0.42),
                            WWColor.deepWell.opacity(0.12)
                        ],
                        center: .center,
                        startRadius: 6,
                        endRadius: 76
                    )
                )
                .frame(width: 126, height: 42)
                .overlay(
                    Ellipse()
                        .stroke(.white.opacity(0.55), lineWidth: 1)
                )

            Image(systemName: "sparkle")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(WWColor.gold)
                .offset(x: 82, y: -40)

            Image(systemName: "sparkle")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(WWColor.warmIvory.opacity(0.85))
                .offset(x: -74, y: -24)
        }
        .frame(height: 128)
    }

    private func rippleColor(for index: Int) -> Color {
        switch index {
        case 0:
            return WWColor.warmIvory.opacity(0.76)
        case 1:
            return WWColor.gold.opacity(0.38)
        case 2:
            return WWColor.mint.opacity(0.34)
        default:
            return WWColor.mistLavender.opacity(0.30)
        }
    }
}

struct WellHeroView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AtmosphericBackground()
            WellHeroView()
                .padding()
        }
    }
}

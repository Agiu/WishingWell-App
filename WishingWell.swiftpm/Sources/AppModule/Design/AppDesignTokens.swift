import SwiftUI

enum AppRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 18
    static let large: CGFloat = 26
    static let xlarge: CGFloat = 32
    static let pill: CGFloat = 999
}

enum AppSpacing {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 10
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum AppOpacity {
    static let glassLight: CGFloat = 0.12
    static let glassMedium: CGFloat = 0.16
    static let border: CGFloat = 0.20
    static let secondaryText: CGFloat = 0.68
}

extension View {
    func appGlassSurface(
        radius: CGFloat,
        fillOpacity: CGFloat = 0.14,
        strokeOpacity: CGFloat = 0.18,
        shadowOpacity: CGFloat = 0.10,
        shadowRadius: CGFloat = 18,
        shadowY: CGFloat = 8
    ) -> some View {
        background {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(.white.opacity(fillOpacity))
        }
        .overlay {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(.white.opacity(strokeOpacity), lineWidth: 0.8)
        }
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: shadowRadius,
            x: 0,
            y: shadowY
        )
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }

    func glassPanel(
        radius: CGFloat = AppRadius.large,
        tintOpacity: CGFloat = AppOpacity.glassLight,
        borderOpacity: CGFloat = AppOpacity.border,
        shadowOpacity: CGFloat = 0.10
    ) -> some View {
        appGlassSurface(
            radius: radius,
            fillOpacity: tintOpacity,
            strokeOpacity: borderOpacity,
            shadowOpacity: shadowOpacity,
            shadowRadius: 18,
            shadowY: 8
        )
    }

    func appGlassCircle(
        fillOpacity: CGFloat = 0.16,
        strokeOpacity: CGFloat = 0.20,
        shadowOpacity: CGFloat = 0.08,
        shadowRadius: CGFloat = 10,
        shadowY: CGFloat = 4
    ) -> some View {
        background {
            Circle()
                .fill(.white.opacity(fillOpacity))
        }
        .overlay {
            Circle()
                .stroke(.white.opacity(strokeOpacity), lineWidth: 0.8)
        }
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: shadowRadius,
            x: 0,
            y: shadowY
        )
        .clipShape(Circle())
    }

    func appGlassCapsule(
        fillOpacity: CGFloat = 0.14,
        strokeOpacity: CGFloat = 0.18,
        shadowOpacity: CGFloat = 0.10,
        shadowRadius: CGFloat = 18,
        shadowY: CGFloat = 8
    ) -> some View {
        background {
            Capsule()
                .fill(.white.opacity(fillOpacity))
        }
        .overlay {
            Capsule()
                .stroke(.white.opacity(strokeOpacity), lineWidth: 0.8)
        }
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: shadowRadius,
            x: 0,
            y: shadowY
        )
        .clipShape(Capsule())
    }

    func appSelectedCapsule() -> some View {
        background {
            Capsule()
                .fill(.white.opacity(0.16))
        }
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.20), lineWidth: 0.8)
        }
        .clipShape(Capsule())
    }

    func appGlassHeroSurface() -> some View {
        background {
            RoundedRectangle(cornerRadius: AppRadius.xlarge, style: .continuous)
                .fill(.white.opacity(0.14))
        }
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xlarge, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            WWColor.warmIvory.opacity(0.14),
                            WWColor.mistLavender.opacity(0.08),
                            WWColor.deepWell.opacity(0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xlarge, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 0.8)
        }
        .shadow(color: .black.opacity(0.10), radius: 20, x: 0, y: 10)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xlarge, style: .continuous))
    }
}

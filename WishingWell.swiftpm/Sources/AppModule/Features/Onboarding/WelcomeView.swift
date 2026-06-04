import SwiftUI

struct WelcomeView: View {
    let onComplete: () -> Void

    @State private var isAnimating = false
    @State private var showContent = false
    @State private var isLoading = true

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            if isLoading {
                LoadingWellView {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        isLoading = false
                    }
                }
            } else {
                welcomeContent
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .onAppear {
            isAnimating = true
        }
    }

    private var welcomeContent: some View {
        VStack(spacing: 0) {
            Spacer()

            RippleWellMark()
                .frame(width: 196, height: 196)
                .scaleEffect(showContent ? 1 : 0.86)
                .opacity(showContent ? 1 : 0)
                .padding(.bottom, AppSpacing.xl)

            Text("Wishing Well")
                .font(WWTypography.wordmark)
                .foregroundStyle(WWColor.luminousText)
                .accessibilityAddTraits(.isHeader)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 18)

            Text("Cast an intention, return to it gently, and watch what starts to ripple.")
                .font(WWTypography.lead)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .foregroundStyle(WWColor.luminousText.opacity(0.78))
                .padding(.horizontal, 40)
                .padding(.top, AppSpacing.md)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 18)

            Spacer()

            PrimaryButton(title: "Get Started", systemImage: "arrow.right") {
                onComplete()
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 18)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.75).delay(0.1)) {
                showContent = true
            }
        }
    }
}

/// The brand mark for Wishing Well: a luminous core ringed by a well rim,
/// with ripples that emanate outward like a drop meeting water, all gently breathing.
private struct RippleWellMark: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var ripple = false
    @State private var breathe = false

    var body: some View {
        ZStack {
            // Ambient glow that breathes behind the mark.
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            WWColor.warmIvory.opacity(0.30),
                            WWColor.gold.opacity(0.10),
                            .clear
                        ],
                        center: .center,
                        startRadius: 2,
                        endRadius: 152
                    )
                )
                .frame(width: 300, height: 300)
                .scaleEffect(breathe ? 1.08 : 0.92)
                .opacity(breathe ? 0.95 : 0.68)
                .blur(radius: 4)

            // Ripples emanating outward, staggered so they read as continuous.
            // Motion-driven and decorative, so they are omitted when Reduce Motion is on.
            if !reduceMotion {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(WWColor.luminousText.opacity(0.32), lineWidth: 1.3)
                        .frame(width: 124, height: 124)
                        .scaleEffect(ripple ? 1.95 : 0.52)
                        .opacity(ripple ? 0 : 0.55)
                        .animation(
                            .easeOut(duration: 3.4)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 1.13),
                            value: ripple
                        )
                }
            }

            // The steady well rim.
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.50),
                            WWColor.gold.opacity(0.24),
                            .white.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.6
                )
                .frame(width: 120, height: 120)
                .scaleEffect(breathe ? 1.04 : 1.0)

            // The wish light at the center: a warm amber halo, kept dimmer in the
            // middle so the white sparkle reads with contrast against it.
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            WWColor.gold.opacity(0.50),
                            WWColor.gold.opacity(0.30),
                            WWColor.gold.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 1,
                        endRadius: 60
                    )
                )
                .frame(width: 112, height: 112)
                .scaleEffect(breathe ? 1.06 : 0.94)
                .blendMode(.screen)

            // The wish itself: a crisp white sparkle, lifted off the halo with a dark
            // edge and a warm glow so it stays high-contrast and twinkles with the breath.
            Image(systemName: "sparkles")
                .font(.system(size: 48, weight: .medium))
                .foregroundStyle(Color.white)
                .shadow(color: WWColor.deepWell.opacity(0.40), radius: 4)
                .shadow(color: WWColor.gold.opacity(0.65), radius: 12)
                .scaleEffect(breathe ? 1.05 : (reduceMotion ? 1.0 : 0.95))
        }
        .onAppear {
            guard !reduceMotion else { return }
            ripple = true
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                breathe = true
            }
        }
        .accessibilityHidden(true)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView {}
    }
}

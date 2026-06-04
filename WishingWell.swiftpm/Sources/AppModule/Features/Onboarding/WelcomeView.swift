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

            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 104, height: 104)
                    .overlay(
                        Circle()
                            .stroke(WWColor.glassStroke, lineWidth: 1)
                    )
                    .shadow(color: WWColor.deepWell.opacity(0.18), radius: 16, y: 8)

                Image(systemName: "sparkles")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(WWColor.gold)
            }
            .scaleEffect(showContent ? 1 : 0.86)
            .opacity(showContent ? 1 : 0)
            .padding(.bottom, 30)

            Text("Wishing Well")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(WWColor.luminousText)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 18)

            Text("Cast an intention, return to it gently, and watch what starts to ripple.")
                .font(WWTypography.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
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

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView {}
    }
}

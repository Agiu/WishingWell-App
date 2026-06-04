import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject private var store: ManifestationStore
    @Binding var selectedTab: AppTab
    @State private var showingCreateWish = false
    @State private var submittedManifestation: Wish?
    @State private var isActivatingCoin = false
    @State private var coinFlipAngle: Double = 0

    var body: some View {
        TopActionsContainer {
            ZStack {
                AtmosphericBackground()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        HomeHeader()

                        NavigationLink {
                            PastReflectionsView()
                        } label: {
                            WellHeroView(reflectionCount: store.personalFeed.count)
                        }
                        .buttonStyle(.plain)

                        ManifestationCoinEntry(
                            isActivating: isActivatingCoin,
                            flipAngle: coinFlipAngle,
                            action: activateManifestationCoin
                        )
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, 92)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: Wish.ID.self) { id in
                WishDetailView(wishID: id)
            }
            .fullScreenCover(isPresented: $showingCreateWish) {
                NavigationStack {
                    CreateWishView { manifestation in
                        submittedManifestation = manifestation
                    }
                }
            }
            .alert("Manifestation placed", isPresented: showingSubmissionConfirmation) {
                Button("View Feed") {
                    selectedTab = .feed
                    submittedManifestation = nil
                }
                Button("Stay Here", role: .cancel) {
                    submittedManifestation = nil
                }
            } message: {
                Text("Your manifestation is in motion. It now appears in your feed.")
            }
        }
    }

    private func activateManifestationCoin() {
        guard !isActivatingCoin else { return }

        UIImpactFeedbackGenerator(style: .soft).impactOccurred()

        isActivatingCoin = true
        withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
            coinFlipAngle = 28
        }

        withAnimation(.easeInOut(duration: 0.62).delay(0.04)) {
            coinFlipAngle = 180
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            showingCreateWish = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) {
            coinFlipAngle = 0
            isActivatingCoin = false
        }
    }

    private var showingSubmissionConfirmation: Binding<Bool> {
        Binding(
            get: { submittedManifestation != nil },
            set: { isPresented in
                if !isPresented {
                    submittedManifestation = nil
                }
            }
        )
    }
}

private struct HomeHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("TODAY, WISH GENTLY")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))

            Text("My Wishing Well")
                .font(.system(size: 42, weight: .semibold, design: .rounded))
                .foregroundStyle(WWColor.luminousText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, AppSpacing.md)
        .padding(.trailing, 66)
    }
}

private struct ManifestationCoinEntry: View {
    let isActivating: Bool
    let flipAngle: Double
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                ManifestationCoin(isActivating: isActivating, flipAngle: flipAngle)
                    .frame(width: 126, height: 126)

                Text("Begin a manifestation")
                    .font(WWTypography.headline)
                    .foregroundStyle(WWColor.luminousText)
                    .padding(.top, AppSpacing.md)

                Text("Tap the coin to enter the ritual.")
                    .font(WWTypography.caption)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    .padding(.top, AppSpacing.xs)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Begin a manifestation")
        .accessibilityHint("Opens the manifestation creation flow")
    }
}

private struct ManifestationCoin: View {
    let isActivating: Bool
    let flipAngle: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(WWColor.warmIvory.opacity(0.10))
                .frame(width: 154, height: 154)
                .blur(radius: 18)
                .opacity(isActivating ? 0.82 : 0.56)
                .scaleEffect(isActivating ? 1.18 : 1.0)

            Circle()
                .stroke(.white.opacity(isActivating ? 0.18 : 0.10), lineWidth: 1)
                .frame(width: isActivating ? 156 : 132, height: isActivating ? 156 : 132)
                .opacity(isActivating ? 0.0 : 1.0)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            WWColor.warmIvory.opacity(0.34),
                            WWColor.mistLavender.opacity(0.20),
                            WWColor.deepWell.opacity(0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.46),
                                    WWColor.gold.opacity(0.22),
                                    .white.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.2
                        )
                }
                .shadow(color: .black.opacity(0.14), radius: 18, y: 10)

            RippleRings()

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            WWColor.warmIvory.opacity(0.48),
                            WWColor.gold.opacity(0.16),
                            .clear
                        ],
                        center: .center,
                        startRadius: 4,
                        endRadius: 58
                    )
                )
                .frame(width: 94, height: 94)
                .blendMode(.screen)

            Image(systemName: "sparkles")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(WWColor.warmIvory.opacity(0.86))
                .rotationEffect(.degrees(isActivating ? 12 : 0))
        }
        .frame(width: 126, height: 126)
        .rotation3DEffect(
            .degrees(flipAngle),
            axis: (x: 0.0, y: 1.0, z: 0.0),
            perspective: 0.58
        )
        .scaleEffect(isActivating ? 1.08 : 1.0)
        .offset(y: isActivating ? -4 : 0)
        .animation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: isActivating)
    }
}

private struct RippleRings: View {
    var body: some View {
        ZStack {
            ForEach(0..<4) { index in
                Circle()
                    .stroke(.white.opacity(ringOpacity(for: index)), lineWidth: ringWidth(for: index))
                    .frame(
                        width: CGFloat(44 + index * 18),
                        height: CGFloat(44 + index * 18)
                    )
            }

            Circle()
                .stroke(WWColor.gold.opacity(0.22), lineWidth: 0.8)
                .frame(width: 104, height: 104)
        }
    }

    private func ringOpacity(for index: Int) -> CGFloat {
        [0.28, 0.20, 0.15, 0.10][index]
    }

    private func ringWidth(for index: Int) -> CGFloat {
        index == 0 ? 1.1 : 0.8
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(selectedTab: .constant(.home))
                .environmentObject(ManifestationStore())
        }
    }
}

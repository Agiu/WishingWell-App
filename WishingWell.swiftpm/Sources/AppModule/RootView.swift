import SwiftUI

struct RootView: View {
    @State private var selectedTab: AppTab = .home
    @State private var hasSeenWelcome = false
    @StateObject private var store = ManifestationStore()

    var body: some View {
        Group {
            if hasSeenWelcome {
                AppTabView(selectedTab: $selectedTab)
            } else {
                WelcomeView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        hasSeenWelcome = true
                    }
                }
            }
        }
        .tint(WWColor.accent)
        .environmentObject(store)
    }
}

private struct AppTabView: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        NavigationStack {
            screen(for: selectedTab)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    FloatingTabBar(selectedTab: $selectedTab)
                        .padding(.horizontal, 44)
                        .padding(.top, AppSpacing.sm)
                        .padding(.bottom, AppSpacing.md)
                        .background(Color.clear)
                }
        }
    }

    @ViewBuilder
    private func screen(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView(selectedTab: $selectedTab)
        case .feed:
            FeedView()
        }
    }
}

private struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.symbolName)
                            .font(.system(size: 17, weight: .regular))
                            .symbolRenderingMode(.hierarchical)
                        Text(tab.title)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(selectedTab == tab ? WWColor.deepWell.opacity(0.84) : WWColor.deepWell.opacity(0.52))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background {
                        if selectedTab == tab {
                            Capsule(style: .continuous)
                                .fill(.white.opacity(0.40))
                                .overlay {
                                    Capsule(style: .continuous)
                                        .stroke(.white.opacity(0.22), lineWidth: 0.7)
                                }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .frame(height: 64)
        .background(.regularMaterial)
        .background(WWColor.warmIvory.opacity(0.18))
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.28), lineWidth: 0.8)
        }
        .shadow(color: .black.opacity(0.11), radius: 18, y: 8)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

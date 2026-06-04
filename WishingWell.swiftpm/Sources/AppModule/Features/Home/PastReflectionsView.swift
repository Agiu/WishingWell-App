import SwiftUI

struct PastReflectionsView: View {
    @EnvironmentObject private var store: ManifestationStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    HStack {
                        AppBackButton {
                            dismiss()
                        }

                        Spacer()
                    }
                    .padding(.top, 56)

                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Past Reflections")
                            .font(WWTypography.largeTitle)
                            .foregroundStyle(WWColor.luminousText)

                        Text("Everything you have placed in your well, gathered softly.")
                            .font(WWTypography.body)
                            .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    }

                    if store.personalFeed.isEmpty {
                        emptyState
                    } else {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            ForEach(store.personalFeed) { wish in
                                NavigationLink {
                                    WishDetailView(wishID: wish.id)
                                } label: {
                                    WishCard(wish: wish)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Image(systemName: "tray")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(WWColor.gold)

            Text("Nothing in the well yet")
                .font(WWTypography.title)
                .foregroundStyle(WWColor.luminousText)

            Text("Your manifestations will appear here after you place them.")
                .font(WWTypography.body)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
    }
}

struct PastReflectionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PastReflectionsView()
                .environmentObject(ManifestationStore())
        }
    }
}

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var store: ManifestationStore

    var body: some View {
        TopActionsContainer {
            ZStack {
                AtmosphericBackground()
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: AppSpacing.md) {
                        FeedHeader()

                        ForEach(store.socialFeed) { wish in
                            NavigationLink(value: wish.id) {
                                FeedManifestationCard(wish: wish)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(AppSpacing.lg)
                    .padding(.bottom, 92)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: Wish.ID.self) { id in
                WishDetailView(wishID: id)
            }
        }
    }
}

private struct FeedHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Feed")
                .font(WWTypography.largeTitle)
                .foregroundStyle(WWColor.luminousText)

            Text("Wishes from your circle, held softly.")
                .font(WWTypography.body)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 86)
        .padding(.bottom, AppSpacing.xs)
    }
}

private struct FeedManifestationCard: View {
    let wish: Wish

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(AppSpacing.md)

            visualPanel

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(spacing: 10) {
                    Label("Affirm", systemImage: "heart")
                    Label("Comment", systemImage: "bubble.right")
                    Spacer()
                    Image(systemName: wish.visibility == .privateOnly ? "lock" : "person.2")
                }
                .font(WWTypography.caption)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))

                Text(wish.comments.isEmpty ? "Be the first to leave a supportive note." : "\(wish.comments.count) supportive note\(wish.comments.count == 1 ? "" : "s")")
                    .font(WWTypography.caption)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
            }
            .padding(AppSpacing.md)
        }
        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.14)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(accentColor)
                .frame(width: 42, height: 42)
                .overlay {
                    Text(String(wish.authorName.prefix(1)))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(wish.authorName)
                    .font(WWTypography.headline)
                    .foregroundStyle(WWColor.luminousText)
                Text(wish.authorHandle)
                    .font(WWTypography.caption)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
            }

            Spacer()

            VisibilityPill(visibility: wish.visibility)
        }
    }

    private var visualPanel: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [accentColor.opacity(0.62), WWColor.deepWell.opacity(0.42)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 250)

            VStack(alignment: .leading, spacing: 12) {
                Text(wish.feedbackType.rawValue)
                    .font(WWTypography.caption)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))

                Text(wish.intention)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .foregroundStyle(WWColor.luminousText)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(6)
            }
            .padding(AppSpacing.lg)
        }
        .padding(.horizontal, AppSpacing.md)
    }

    private var accentColor: Color {
        if wish.isMine {
            return WWColor.accent
        }

        switch wish.authorName.first {
        case "M":
            return WWColor.rose
        case "K":
            return WWColor.mint
        default:
            return WWColor.gold
        }
    }
}

struct VisibilityPill: View {
    let visibility: ManifestationVisibility

    var body: some View {
        Text(visibility.rawValue)
            .font(WWTypography.caption)
            .foregroundStyle(WWColor.luminousText)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 5)
            .background(WWColor.warmIvory.opacity(AppOpacity.glassMedium), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(WWColor.glassStroke, lineWidth: 1)
            )
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeedView()
                .environmentObject(ManifestationStore())
        }
    }
}

import SwiftUI
import UIKit

struct FeedView: View {
    @EnvironmentObject private var store: ManifestationStore
    var onCreate: () -> Void = {}

    var body: some View {
        TopActionsContainer {
            ZStack {
                AtmosphericBackground()
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: AppSpacing.md) {
                        FeedHeader()

                        FeedComposerButton(action: onCreate)

                        ForEach(store.socialFeed) { wish in
                            FeedManifestationCard(wish: wish)
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
                .accessibilityAddTraits(.isHeader)

            Text("Wishes from your circle, held softly.")
                .font(WWTypography.lead)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 86)
        .padding(.bottom, AppSpacing.xs)
    }
}

/// The always-present way to start a manifestation from the social home, styled
/// like a composer so creating reads as the core action, not a hidden one.
private struct FeedComposerButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(WWColor.gold)

                Text("Cast a wish...")
                    .font(WWTypography.headline)
                    .foregroundStyle(WWColor.luminousText.opacity(0.82))

                Spacer()

                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(WWColor.deepWell)
                    .frame(width: 30, height: 30)
                    .background(WWColor.warmIvory, in: Circle())
            }
            .padding(.vertical, AppSpacing.sm)
            .padding(.leading, AppSpacing.md)
            .padding(.trailing, AppSpacing.sm)
            .frame(maxWidth: .infinity)
            .glassPanel(radius: AppRadius.pill, tintOpacity: 0.16, shadowOpacity: 0.12)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Cast a wish")
        .accessibilityHint("Create a new manifestation")
    }
}

/// A live affirm toggle: a heart that fills and pops, with a running count.
struct AffirmButton: View {
    let isAffirmed: Bool
    let count: Int
    let action: () -> Void

    @State private var pop = false

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            pop = true
            withAnimation(.spring(response: 0.3, dampingFraction: 0.62)) {
                action()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                pop = false
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isAffirmed ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(isAffirmed ? WWColor.rose : WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    .scaleEffect(pop ? 1.3 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: pop)
                Text("\(count)")
                    .font(WWTypography.caption)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isAffirmed ? "Affirmed" : "Affirm")
        .accessibilityValue("\(count) affirmation\(count == 1 ? "" : "s")")
        .accessibilityAddTraits(isAffirmed ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint("Sends quiet support to this manifestation")
    }
}

private struct FeedManifestationCard: View {
    @EnvironmentObject private var store: ManifestationStore
    let wish: Wish

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Only the content area navigates, so the action bar's buttons stay live.
            NavigationLink(value: wish.id) {
                VStack(alignment: .leading, spacing: 0) {
                    header
                        .padding(AppSpacing.md)
                    visualPanel
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityDescription)
            .accessibilityHint("Opens this manifestation")

            actionBar
                .padding(AppSpacing.md)
        }
        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.14)
    }

    private var actionBar: some View {
        HStack(spacing: AppSpacing.lg) {
            AffirmButton(isAffirmed: wish.isAffirmed, count: wish.affirmationCount) {
                store.toggleAffirmation(for: wish.id)
            }

            NavigationLink(value: wish.id) {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 15, weight: .regular))
                    Text("\(wish.comments.count)")
                        .font(WWTypography.caption)
                }
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Comment")
            .accessibilityValue(wish.comments.isEmpty ? "No responses yet" : "\(wish.comments.count) response\(wish.comments.count == 1 ? "" : "s")")
            .accessibilityHint("Opens this manifestation to respond")

            Spacer()

            Image(systemName: wish.visibility == .privateOnly ? "lock" : "person.2")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                .accessibilityHidden(true)
        }
    }

    /// One clean spoken summary for the navigable content, so VoiceOver hears the
    /// post as a single "opens manifestation" element separate from the action bar.
    private var accessibilityDescription: String {
        let notes = wish.comments.isEmpty
            ? "No supportive notes yet"
            : "\(wish.comments.count) supportive note\(wish.comments.count == 1 ? "" : "s")"
        return "\(wish.authorName)'s manifestation: \(wish.intention). Seeking \(wish.feedbackType.rawValue). \(notes)."
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
                    .font(WWTypography.cardTitle)
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

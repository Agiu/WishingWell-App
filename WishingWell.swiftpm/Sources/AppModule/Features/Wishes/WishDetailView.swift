import SwiftUI

struct WishDetailView: View {
    @EnvironmentObject private var store: ManifestationStore
    let wishID: Wish.ID

    @State private var showingCommentSheet = false
    @State private var showingCommentConfirmation = false

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            Group {
                if let wish = store.manifestation(with: wishID) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppSpacing.lg) {
                            StatusHeader(wish: wish)

                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text(wish.intention)
                                    .font(WWTypography.largeTitle)
                                    .foregroundStyle(WWColor.luminousText)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text(wish.feedbackType.rawValue)
                                    .font(WWTypography.caption)
                                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                            }

                            supportiveActions

                            commentsSection(wish: wish)
                        }
                        .padding(AppSpacing.lg)
                    }
                } else {
                    VStack(spacing: AppSpacing.sm) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(WWColor.gold)
                        Text("Manifestation not found")
                            .font(WWTypography.title)
                            .foregroundStyle(WWColor.luminousText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle("Manifestation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(WWColor.luminousText)
        .sheet(isPresented: $showingCommentSheet) {
            NavigationStack {
                CommentInputView { message in
                    store.addComment(to: wishID, message: message)
                    showingCommentConfirmation = true
                }
            }
        }
        .alert("Beautifully said", isPresented: $showingCommentConfirmation) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("Your affirmation was added. Little kindnesses count.")
        }
    }

    private var supportiveActions: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Support this manifestation")
                .font(WWTypography.title)
                .foregroundStyle(WWColor.luminousText)

            HStack(spacing: AppSpacing.sm) {
                Button {
                    showingCommentSheet = true
                } label: {
                    Label("Comment", systemImage: "bubble.right")
                        .font(WWTypography.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background {
                            Capsule()
                                .fill(WWColor.deepWell.opacity(0.62))
                        }
                        .foregroundStyle(WWColor.luminousText)
                        .overlay {
                            Capsule()
                                .stroke(.white.opacity(0.18), lineWidth: 0.8)
                        }
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Button {} label: {
                    Image(systemName: "heart")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(WWColor.rose)
                        .frame(width: 52, height: 52)
                        .background(WWColor.rose.opacity(AppOpacity.glassMedium), in: Circle())
                        .overlay(
                            Circle()
                                .stroke(WWColor.glassStroke, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Affirm")
            }
        }
        .padding(AppSpacing.md)
        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
    }

    private func commentsSection(wish: Wish) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Affirming responses")
                .font(WWTypography.title)
                .foregroundStyle(WWColor.luminousText)

            if wish.comments.isEmpty {
                Text("No responses yet. A simple note of belief is a good place to start.")
                    .font(WWTypography.body)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
            } else {
                ForEach(wish.comments) { comment in
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(comment.authorName)
                            .font(WWTypography.headline)
                            .foregroundStyle(WWColor.luminousText)
                        Text(comment.message)
                            .font(WWTypography.body)
                            .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    }
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
                }
            }
        }
    }
}

private struct StatusHeader: View {
    let wish: Wish

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "water.waves")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(WWColor.gold)
                .frame(width: 44, height: 44)
                .background(WWColor.warmIvory.opacity(AppOpacity.glassMedium), in: Circle())
                .overlay(
                    Circle()
                        .stroke(WWColor.glassStroke, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(wish.authorName)
                    .font(WWTypography.headline)
                    .foregroundStyle(WWColor.luminousText)
                Text("\(wish.status.rawValue) - \(wish.visibility.rawValue)")
                    .font(WWTypography.caption)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
            }

            Spacer()

            if wish.isMine {
                Text("Mine")
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
        .padding(AppSpacing.md)
        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
    }
}

private struct CommentInputView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    let onSubmit: (String) -> Void

    @State private var message = ""

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                commentTopBar

                Text("Write an affirming response")
                    .font(WWTypography.largeTitle)
                    .foregroundStyle(WWColor.luminousText)

                Text("Keep it supportive, specific, and easy to receive.")
                    .font(WWTypography.body)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $message)
                        .focused($isFocused)
                        .font(WWTypography.body)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(WWColor.deepWell)
                        .padding(AppSpacing.sm)

                    if trimmedMessage.isEmpty {
                        Text("I believe this is already beginning...")
                            .font(WWTypography.body)
                            .foregroundStyle(WWColor.deepWell.opacity(AppOpacity.secondaryText))
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.md)
                            .allowsHitTesting(false)
                    }
                }
                .frame(minHeight: 170)
                .glassPanel(radius: AppRadius.large, tintOpacity: 0.72, shadowOpacity: 0.12)

                PrimaryButton(title: "Submit Comment", systemImage: "paperplane") {
                    onSubmit(trimmedMessage)
                    dismiss()
                }
                .disabled(trimmedMessage.isEmpty)
                .opacity(trimmedMessage.isEmpty ? 0.55 : 1)

                Spacer()
            }
            .padding(AppSpacing.lg)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            isFocused = true
        }
    }

    private var commentTopBar: some View {
        HStack {
            AppBackButton(accessibilityLabel: "Leave comment") {
                dismiss()
            }

            Spacer()

            Text("Comment")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(WWColor.luminousText)

            Spacer()

            Color.clear
                .frame(width: AppBackButton.size, height: AppBackButton.size)
        }
    }

    private var trimmedMessage: String {
        message.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct WishDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WishDetailView(wishID: Wish.friendSamples[0].id)
                .environmentObject(ManifestationStore())
        }
    }
}

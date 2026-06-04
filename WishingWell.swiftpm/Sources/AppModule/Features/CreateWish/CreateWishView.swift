import SwiftUI

struct CreateWishView: View {
    @EnvironmentObject private var store: ManifestationStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool

    let onSubmit: (Wish) -> Void

    @State private var intention = ""
    @State private var feedbackType: ManifestationFeedbackType = .emotionalSupport
    @State private var visibility: ManifestationVisibility = .closeCircle

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    creationTopBar
                    header
                    feedbackIntentSection
                    inputArea
                    visibilitySelector

                    PrimaryButton(title: "Place in the Well", systemImage: "sparkles") {
                        submit()
                    }
                    .disabled(trimmedIntention.isEmpty)
                    .opacity(trimmedIntention.isEmpty ? 0.55 : 1)
                }
                .padding(AppSpacing.lg)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            isInputFocused = true
        }
    }

    private var creationTopBar: some View {
        HStack {
            AppBackButton(accessibilityLabel: "Leave new manifestation") {
                dismiss()
            }

            Spacer()

            Text("New Manifestation")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(WWColor.luminousText)

            Spacer()

            Color.clear
                .frame(width: AppBackButton.size, height: AppBackButton.size)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("What are you calling in?")
                .font(WWTypography.largeTitle)
                .foregroundStyle(WWColor.luminousText)

            Text("Write freely, then choose the kind of response that would feel most helpful.")
                .font(WWTypography.body)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
        }
    }

    private var feedbackIntentSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("What kind of feedback do you want?")
                .font(WWTypography.headline)
                .foregroundStyle(WWColor.luminousText)

            VStack(spacing: AppSpacing.sm) {
                ForEach(ManifestationFeedbackType.allCases) { option in
                    Button {
                        feedbackType = option
                    } label: {
                        HStack(spacing: AppSpacing.sm) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(option.rawValue)
                                    .font(WWTypography.headline)
                                    .foregroundStyle(WWColor.luminousText)

                                Text(option.description)
                                    .font(WWTypography.caption)
                                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                            }

                            Spacer()

                            Image(systemName: feedbackType == option ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(feedbackType == option ? WWColor.gold : WWColor.luminousText.opacity(0.48))
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .appGlassSurface(
                            radius: AppRadius.medium,
                            fillOpacity: feedbackType == option ? 0.18 : 0.11,
                            strokeOpacity: feedbackType == option ? 0.28 : 0.16,
                            shadowOpacity: 0.05,
                            shadowRadius: 8,
                            shadowY: 3
                        )
                        .contentShape(
                            RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(
                        feedbackType == option ? [.isButton, .isSelected] : .isButton
                    )
                    .accessibilityLabel("\(option.rawValue). \(option.description)")
                }
            }
        }
    }

    private var inputArea: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Manifestation")
                .font(WWTypography.headline)
                .foregroundStyle(WWColor.luminousText)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $intention)
                    .focused($isInputFocused)
                    .frame(minHeight: 180)
                    .scrollContentBackground(.hidden)
                    .font(WWTypography.body)
                    .foregroundStyle(WWColor.deepWell)
                    .padding(AppSpacing.sm)

                if trimmedIntention.isEmpty {
                    Text("Manifest something exciting")
                        .font(WWTypography.body)
                        .foregroundStyle(WWColor.deepWell.opacity(AppOpacity.secondaryText))
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.md)
                        .allowsHitTesting(false)
                }
            }
            .glassPanel(radius: AppRadius.large, tintOpacity: 0.72, borderOpacity: AppOpacity.border, shadowOpacity: 0.12)
        }
    }

    private var visibilitySelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Visibility")
                .font(WWTypography.headline)
                .foregroundStyle(WWColor.luminousText)

            VStack(spacing: AppSpacing.sm) {
                ForEach(ManifestationVisibility.allCases) { option in
                    Button {
                        visibility = option
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: visibility == option ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(visibility == option ? WWColor.gold : WWColor.luminousText.opacity(AppOpacity.secondaryText))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(option.rawValue)
                                    .font(WWTypography.headline)
                                    .foregroundStyle(WWColor.luminousText)
                                Text(option.description)
                                    .font(WWTypography.caption)
                                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                            }

                            Spacer()
                        }
                        .padding(AppSpacing.md)
                        .appGlassSurface(
                            radius: AppRadius.medium,
                            fillOpacity: visibility == option ? 0.18 : 0.12,
                            strokeOpacity: visibility == option ? 0.28 : 0.18,
                            shadowOpacity: 0.06,
                            shadowRadius: 10,
                            shadowY: 4
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var trimmedIntention: String {
        intention.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func submit() {
        let manifestation = store.addManifestation(
            intention: trimmedIntention,
            feedbackType: feedbackType,
            visibility: visibility
        )
        dismiss()
        onSubmit(manifestation)
    }
}

struct CreateWishView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateWishView { _ in }
                .environmentObject(ManifestationStore())
        }
    }
}

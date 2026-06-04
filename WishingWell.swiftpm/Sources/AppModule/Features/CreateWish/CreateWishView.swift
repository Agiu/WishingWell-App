import SwiftUI

struct CreateWishView: View {
    @EnvironmentObject private var store: ManifestationStore
    @FocusState private var isInputFocused: Bool

    let isOnboarding: Bool
    let onCancel: () -> Void
    let onSubmit: (Wish) -> Void

    init(
        isOnboarding: Bool = false,
        onCancel: @escaping () -> Void = {},
        onSubmit: @escaping (Wish) -> Void
    ) {
        self.isOnboarding = isOnboarding
        self.onCancel = onCancel
        self.onSubmit = onSubmit
    }

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

                    // Prompt and field read as one unit, set tighter together.
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        header
                        inputArea
                    }

                    refinementsSection

                    VStack(spacing: AppSpacing.xs) {
                        PrimaryButton(title: "Place in the Well", systemImage: "sparkles") {
                            submit()
                        }
                        .disabled(trimmedIntention.isEmpty)
                        .opacity(trimmedIntention.isEmpty ? 0.55 : 1)
                        .accessibilityHint(trimmedIntention.isEmpty ? "Write your manifestation first" : "")

                        if isOnboarding {
                            Button(action: onCancel) {
                                Text("Explore the feed first")
                                    .font(WWTypography.caption)
                                    .foregroundStyle(WWColor.luminousText.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, AppSpacing.sm)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Skip creating for now and go to the feed")
                        }
                    }
                    .padding(.top, AppSpacing.xs)
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
            // During first-run onboarding there is nowhere to go "back" to, so the
            // leading slot stays empty and the skip lives under the primary button.
            if isOnboarding {
                Color.clear
                    .frame(width: AppBackButton.size, height: AppBackButton.size)
            } else {
                AppBackButton(accessibilityLabel: "Leave new manifestation", action: onCancel)
            }

            Spacer()

            Text(isOnboarding ? "Your first wish" : "New wish")
                .font(WWTypography.barTitle)
                .foregroundStyle(WWColor.luminousText)

            Spacer()

            Color.clear
                .frame(width: AppBackButton.size, height: AppBackButton.size)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("What do you want to manifest?")
                .font(WWTypography.largeTitle)
                .foregroundStyle(WWColor.luminousText)
                .accessibilityAddTraits(.isHeader)

            Text("Write it freely. You can set who sees it and the support you want just below.")
                .font(WWTypography.lead)
                .lineSpacing(3)
                .foregroundStyle(WWColor.luminousText.opacity(0.78))
        }
    }

    // The two refinements sit quietly under the writing. They start with sensible
    // defaults, so a first manifestation can be one sentence and one tap.
    private var refinementsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("DETAILS")
                .font(WWTypography.eyebrow)
                .tracking(1.4)
                .foregroundStyle(WWColor.luminousText.opacity(0.55))
                .accessibilityAddTraits(.isHeader)
                .padding(.leading, AppSpacing.xs)
                .padding(.bottom, 2)

            CompactSelectorRow(
                icon: "heart.text.square",
                label: "Support",
                value: feedbackType.rawValue,
                caption: feedbackType.description
            ) {
                ForEach(ManifestationFeedbackType.allCases) { option in
                    Button {
                        feedbackType = option
                    } label: {
                        if feedbackType == option {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            }

            CompactSelectorRow(
                icon: visibilityIcon,
                label: "Who sees this",
                value: visibility.rawValue,
                caption: visibility.description
            ) {
                ForEach(ManifestationVisibility.allCases) { option in
                    Button {
                        visibility = option
                    } label: {
                        if visibility == option {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            }
        }
    }

    private var visibilityIcon: String {
        switch visibility {
        case .everyone:
            return "globe.americas"
        case .closeCircle:
            return "person.2"
        case .privateOnly:
            return "lock"
        }
    }

    private var inputArea: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $intention)
                .focused($isInputFocused)
                .frame(minHeight: 200)
                .scrollContentBackground(.hidden)
                .font(WWTypography.lead)
                .foregroundStyle(WWColor.deepWell)
                .padding(AppSpacing.sm)
                .accessibilityLabel("Manifestation")
                .accessibilityHint("Write the intention you want to place in the well")

            if trimmedIntention.isEmpty {
                Text("I'm calling in...")
                    .font(WWTypography.lead)
                    .foregroundStyle(WWColor.deepWell.opacity(AppOpacity.secondaryText))
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.md)
                    .allowsHitTesting(false)
            }
        }
        .glassPanel(radius: AppRadius.large, tintOpacity: 0.72, borderOpacity: AppOpacity.border, shadowOpacity: 0.12)
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
        // The presenter decides where to go next (dismiss the sheet and show the
        // feed, or advance out of onboarding), so we don't dismiss ourselves here.
        onSubmit(manifestation)
    }
}

/// A compact, defaulted refinement: a labelled glass row whose whole surface opens
/// a menu of choices. Replaces a full-height list of radio cards with one line.
private struct CompactSelectorRow<MenuContent: View>: View {
    let icon: String
    let label: String
    let value: String
    let caption: String
    @ViewBuilder var menu: () -> MenuContent

    var body: some View {
        Menu {
            menu()
        } label: {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(WWColor.gold.opacity(0.92))
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(WWTypography.headline)
                        .foregroundStyle(WWColor.luminousText)
                    Text(caption)
                        .font(WWTypography.caption)
                        .foregroundStyle(WWColor.luminousText.opacity(0.74))
                        .lineLimit(1)
                }

                Spacer(minLength: AppSpacing.sm)

                HStack(spacing: 5) {
                    Text(value)
                        .font(WWTypography.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(WWColor.luminousText)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(WWColor.luminousText.opacity(0.6))
                }
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, 7)
                .appSelectedCapsule()
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .appGlassSurface(
                radius: AppRadius.medium,
                fillOpacity: 0.11,
                strokeOpacity: 0.16,
                shadowOpacity: 0.05,
                shadowRadius: 8,
                shadowY: 3
            )
            .contentShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value). \(caption)")
        .accessibilityHint("Double tap to change")
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

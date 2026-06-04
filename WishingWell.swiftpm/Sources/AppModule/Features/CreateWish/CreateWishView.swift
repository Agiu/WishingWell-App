import SwiftUI

struct CreateWishView: View {
    @EnvironmentObject private var store: ManifestationStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool

    let onSubmit: (Wish) -> Void

    @State private var intention = ""
    @State private var selectedPrompt = "I want..."
    @State private var visibility: ManifestationVisibility = .closeCircle

    private let prompts = [
        "I want...",
        "I will...",
        "Next month, I'm going to..."
    ]

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    creationTopBar
                    header
                    promptSuggestions
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

            Text("Start with a prompt or write freely. Keep it honest and kind to your future self.")
                .font(WWTypography.body)
                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
        }
    }

    private var promptSuggestions: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Prompts")
                .font(WWTypography.headline)
                .foregroundStyle(WWColor.luminousText)

            FlowLayout(spacing: 8) {
                ForEach(prompts, id: \.self) { prompt in
                    Button {
                        selectedPrompt = prompt
                        if trimmedIntention.isEmpty {
                            intention = prompt + " "
                        }
                        isInputFocused = true
                    } label: {
                        Text(prompt)
                            .font(WWTypography.caption)
                            .foregroundStyle(selectedPrompt == prompt ? WWColor.luminousText : WWColor.luminousText.opacity(AppOpacity.secondaryText))
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, 8)
                            .background(
                                selectedPrompt == prompt ? WWColor.deepWell.opacity(0.56) : WWColor.warmIvory.opacity(AppOpacity.glassLight),
                                in: Capsule()
                            )
                            .overlay(
                                Capsule()
                                    .stroke(WWColor.glassStroke, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
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
            prompt: selectedPrompt,
            visibility: visibility
        )
        dismiss()
        onSubmit(manifestation)
    }
}

private struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

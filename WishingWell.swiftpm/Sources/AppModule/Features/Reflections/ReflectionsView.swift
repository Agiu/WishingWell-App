import SwiftUI

struct ReflectionsView: View {
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

                    Text("Ripples")
                        .font(WWTypography.largeTitle)
                        .foregroundStyle(WWColor.luminousText)
                        .accessibilityAddTraits(.isHeader)

                    ForEach(reflections, id: \.title) { reflection in
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(reflection.title)
                                .font(WWTypography.headline)
                                .foregroundStyle(WWColor.luminousText)
                            Text(reflection.body)
                                .font(WWTypography.body)
                                .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                        }
                        .padding(AppSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.lg)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var reflections: [(title: String, body: String)] {
        [
            ("This week", "Two wishes moved from planted to rippling."),
            ("Prompt", "What changed after you named what you wanted?"),
            ("Tiny proof", "One small action is enough evidence to keep going.")
        ]
    }
}

struct ReflectionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReflectionsView()
        }
    }
}

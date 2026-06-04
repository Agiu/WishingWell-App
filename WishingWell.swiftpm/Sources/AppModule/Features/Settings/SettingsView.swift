import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dailyReminder = true
    @State private var quietMode = false

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
                        Text("Settings")
                            .font(WWTypography.largeTitle)
                            .foregroundStyle(WWColor.luminousText)

                        Text("Small adjustments for how Wishing Well supports your rhythm.")
                            .font(WWTypography.body)
                            .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    }

                    VStack(spacing: AppSpacing.sm) {
                        Toggle("Daily reminder", isOn: $dailyReminder)
                        Toggle("Quiet mode", isOn: $quietMode)
                    }
                    .font(WWTypography.body)
                    .foregroundStyle(WWColor.luminousText)
                    .padding(AppSpacing.md)
                    .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)

                    VStack(spacing: AppSpacing.sm) {
                        LabeledContent("Version", value: "1.0")
                        LabeledContent("Bundle", value: "com.kaelub.WishingWell")
                    }
                    .font(WWTypography.body)
                    .foregroundStyle(WWColor.luminousText)
                    .padding(AppSpacing.md)
                    .glassPanel(radius: AppRadius.large, tintOpacity: AppOpacity.glassLight, shadowOpacity: 0.12)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.lg)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .tint(WWColor.luminousText)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}

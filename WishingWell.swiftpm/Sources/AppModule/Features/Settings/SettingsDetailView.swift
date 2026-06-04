import SwiftUI

struct SettingsDetailView: View {
    let title: String
    let detailText: String

    var body: some View {
        ZStack {
            AtmosphericBackground()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text(title)
                    .font(WWTypography.largeTitle)
                    .foregroundStyle(WWColor.luminousText)

                Text(detailText)
                    .font(WWTypography.body)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))

                Spacer()
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(WWColor.luminousText)
    }
}

struct SettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsDetailView(title: "Privacy", detailText: "Choose what the feed can see.")
        }
    }
}

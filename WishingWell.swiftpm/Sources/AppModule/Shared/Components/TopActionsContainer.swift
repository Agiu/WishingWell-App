import SwiftUI

struct TopActionsContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            // Placed as a manual overlay rather than toolbar items so the system
            // doesn't wrap them in a grouped glass "pill" background.
            .overlay(alignment: .topTrailing) {
                HStack(spacing: AppSpacing.sm) {
                    NavigationLink {
                        ReflectionsView()
                    } label: {
                        topActionIcon("water.waves")
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Ripples")

                    NavigationLink {
                        SettingsView()
                    } label: {
                        topActionIcon("line.3.horizontal")
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Settings")
                }
                .padding(.trailing, AppSpacing.lg)
                .padding(.top, AppSpacing.sm)
            }
    }

    /// White glyph on a dark frosted circle so the icon reads with contrast over
    /// the bright top of the atmospheric background.
    private func topActionIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 19, weight: .medium))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(WWColor.luminousText)
            .frame(width: 42, height: 42)
            .background(WWColor.deepWell.opacity(0.5), in: Circle())
            .background(.ultraThinMaterial, in: Circle())
            .overlay {
                Circle().stroke(.white.opacity(0.22), lineWidth: 0.8)
            }
            .shadow(color: .black.opacity(0.18), radius: 8, y: 3)
    }
}

struct TopActionsContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TopActionsContainer {
                Text("Preview")
                    .navigationTitle("My Well")
            }
        }
    }
}

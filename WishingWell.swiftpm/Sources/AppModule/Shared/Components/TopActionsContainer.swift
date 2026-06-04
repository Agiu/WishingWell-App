import SwiftUI

struct TopActionsContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ReflectionsView()
                    } label: {
                        Image(systemName: "water.waves")
                            .font(.system(size: 16, weight: .regular))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(WWColor.deepWell.opacity(0.76))
                            .frame(width: 36, height: 36)
                            .appGlassCircle(fillOpacity: 0.22, strokeOpacity: 0.22, shadowOpacity: 0.07, shadowRadius: 8, shadowY: 3)
                    }
                    .accessibilityLabel("Ripples")

                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 16, weight: .regular))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(WWColor.deepWell.opacity(0.76))
                            .frame(width: 36, height: 36)
                            .appGlassCircle(fillOpacity: 0.22, strokeOpacity: 0.22, shadowOpacity: 0.07, shadowRadius: 8, shadowY: 3)
                    }
                    .accessibilityLabel("Settings")
                }
            }
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

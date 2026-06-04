import SwiftUI

struct AtmosphericBackground: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                WWColor.deepWell

                // Deep base wash: bright dawn at the very top, falling quickly into a rich, deep well.
                LinearGradient(
                    stops: [
                        .init(color: WWColor.dawnPeach.opacity(0.64), location: 0.00),
                        .init(color: WWColor.mistLavender.opacity(0.58), location: 0.20),
                        .init(color: WWColor.duskIndigo.opacity(0.98), location: 0.50),
                        .init(color: WWColor.deepWell, location: 0.76),
                        .init(color: WWColor.deepWell, location: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Bottom vignette: anchors the composition and keeps the deep well deep.
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.24),
                        .init(color: WWColor.deepWell.opacity(0.62), location: 1.00)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .saturation(1.22)
            .frame(width: size.width, height: size.height)
            .clipped()
        }
        .background(WWColor.deepWell)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct AtmosphericBackground_Previews: PreviewProvider {
    static var previews: some View {
        AtmosphericBackground()
    }
}

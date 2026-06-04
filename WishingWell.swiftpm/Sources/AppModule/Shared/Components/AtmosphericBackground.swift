import SwiftUI

struct AtmosphericBackground: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                WWColor.deepWell

                LinearGradient(
                    stops: [
                        .init(color: WWColor.dawnPeach.opacity(0.94), location: 0.00),
                        .init(color: WWColor.mistLavender.opacity(0.86), location: 0.28),
                        .init(color: WWColor.duskIndigo.opacity(0.96), location: 0.68),
                        .init(color: WWColor.deepWell, location: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                RadialGradient(
                    stops: [
                        .init(color: WWColor.gold.opacity(0.32), location: 0.00),
                        .init(color: WWColor.dawnPeach.opacity(0.18), location: 0.36),
                        .init(color: .clear, location: 1.00)
                    ],
                    center: UnitPoint(x: 0.12, y: 0.05),
                    startRadius: 8,
                    endRadius: max(size.width, size.height) * 0.72
                )

                RadialGradient(
                    stops: [
                        .init(color: WWColor.mint.opacity(0.22), location: 0.00),
                        .init(color: WWColor.mistLavender.opacity(0.14), location: 0.42),
                        .init(color: .clear, location: 1.00)
                    ],
                    center: UnitPoint(x: 0.86, y: 0.42),
                    startRadius: 12,
                    endRadius: max(size.width, size.height) * 0.78
                )

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.40),
                        .init(color: WWColor.deepWell.opacity(0.32), location: 1.00)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: size.width, height: size.height)
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

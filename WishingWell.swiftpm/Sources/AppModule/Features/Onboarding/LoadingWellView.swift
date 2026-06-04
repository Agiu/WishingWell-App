import SwiftUI

struct LoadingWellView: View {
    let onFinished: () -> Void

    @State private var ropeLength: CGFloat = 0
    @State private var bucketRotation: Double = -8

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack(spacing: -10) {
                    Color.clear
                        .frame(width: 1, height: ropeLength)

                    Image(systemName: "bucket")
                        .font(.system(size: 86, weight: .regular))
                        .foregroundStyle(WWColor.luminousText)
                        .shadow(color: WWColor.deepWell.opacity(0.18), radius: 12, y: 10)
                }
                .rotationEffect(.degrees(bucketRotation), anchor: .top)

                Text("Lowering the manifestation bucket...")
                    .font(WWTypography.headline)
                    .foregroundStyle(WWColor.luminousText.opacity(AppOpacity.secondaryText))
                    .position(x: proxy.size.width / 2, y: proxy.size.height * 0.72)
                    .opacity(ropeLength > proxy.size.height * 0.2 ? 1 : 0)
                    .animation(.easeIn(duration: 0.5), value: ropeLength)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                await runAnimation(screenHeight: proxy.size.height)
            }
        }
        .ignoresSafeArea()
    }

    @MainActor
    private func runAnimation(screenHeight: CGFloat) async {
        withAnimation(.easeInOut(duration: 2.8)) {
            ropeLength = screenHeight * 0.42
        }

        withAnimation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true)) {
            bucketRotation = 8
        }

        try? await Task.sleep(nanoseconds: 3_250_000_000)

        withAnimation(.easeIn(duration: 0.55)) {
            ropeLength = screenHeight + 200
        }

        try? await Task.sleep(nanoseconds: 600_000_000)
        onFinished()
    }
}

struct LoadingWellView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingWellView {}
    }
}

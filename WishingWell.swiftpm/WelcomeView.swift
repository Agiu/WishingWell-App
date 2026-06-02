import SwiftUI

struct WelcomeView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Dynamic Background
            LinearGradient(
                colors: [Color(hex: "0B0B1A"), Color(hex: "1F1A38"), Color(hex: "351F5B")],
                startPoint: isAnimating ? .topLeading : .bottomTrailing,
                endPoint: isAnimating ? .bottomTrailing : .topLeading
            )
            .hueRotation(.degrees(isAnimating ? 45 : 0))
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: isAnimating)
            
            // Decorative elements (blur orbs)
            GeometryReader { proxy in
                Circle()
                    .fill(Color(hex: "6A2B86").opacity(0.6))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(x: isAnimating ? proxy.size.width * 0.5 : -50,
                            y: isAnimating ? -50 : proxy.size.height * 0.3)
                    .animation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Circle()
                    .fill(Color(hex: "3485FF").opacity(0.5))
                    .frame(width: 200, height: 200)
                    .blur(radius: 60)
                    .offset(x: isAnimating ? -50 : proxy.size.width * 0.6,
                            y: isAnimating ? proxy.size.height * 0.6 : proxy.size.height * 0.9)
                    .animation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true), value: isAnimating)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Icon / Logo Placeholder
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 100, height: 100)
                        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 44, weight: .light))
                        .foregroundStyle(
                            LinearGradient(colors: [.white, Color(hex: "E0E0FF")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)
                .padding(.bottom, 32)
                
                // Title
                Text("Wishing Well")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                // Subtitle
                Text("Throw your dreams into the digital well and watch them ripple into reality.")
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 40)
                    .padding(.top, 16)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    // Feedback on press
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white.opacity(0.15))
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.15), radius: 15, y: 5)
                        .scaleEffect(isPressed ? 0.97 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(.easeOut(duration: 0.1)) {
                                isPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.easeOut(duration: 0.2)) {
                                isPressed = false
                            }
                        }
                )
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            }
        }
        .onAppear {
            isAnimating = true
            
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

// Helper for Hex Colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .preferredColorScheme(.dark)
    }
}

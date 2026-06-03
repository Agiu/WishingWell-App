import SwiftUI

struct WelcomeView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var isPressed = false
    
    // Loading Animation States
    @State private var isLoading = true
    @State private var ropeLength: CGFloat = 0
    @State private var bucketRotation: Double = -8
    
    var body: some View {
        ZStack {
            // Dynamic Background
            Color.white
                .ignoresSafeArea()
            
            // Decorative elements (blur orbs)
            GeometryReader { proxy in
                // small glowing gradients
                Circle()
                    .fill(Color(hex: "FFB6C1").opacity(0.4)) // soft pink
                    .frame(width: 150, height: 150)
                    .blur(radius: 60)
                    .offset(x: isAnimating ? proxy.size.width * 0.7 : 20,
                            y: isAnimating ? 40 : proxy.size.height * 0.2)
                    .animation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Circle()
                    .fill(Color(hex: "ADD8E6").opacity(0.4)) // soft blue
                    .frame(width: 120, height: 120)
                    .blur(radius: 50)
                    .offset(x: isAnimating ? 30 : proxy.size.width * 0.8,
                            y: isAnimating ? proxy.size.height * 0.8 : proxy.size.height * 0.7)
                    .animation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true), value: isAnimating)
            }
            .ignoresSafeArea()
            
            if isLoading {
                GeometryReader { proxy in
                    ZStack(alignment: .top) {
                        Color.clear // Ensure the ZStack fills the GeometryReader
                        
                        VStack(spacing: -10) {
                            Rectangle()
                                .fill(Color(hex: "8B4513")) // Rope color
                                .frame(width: 6, height: ropeLength)
                            
                            Text("🪣")
                                .font(.system(size: 120))
                                .shadow(color: .black.opacity(0.2), radius: 10, y: 15)
                        }
                        // Anchor the rotation at the very top of the VStack (pinned to the top of the screen)
                        .rotationEffect(.degrees(bucketRotation), anchor: .top)
                        
                        Text("Lowering the manifestation bucket...")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.black.opacity(0.7))
                            // Position it near the bottom of the screen
                            .position(x: proxy.size.width / 2, y: proxy.size.height * 0.7)
                            .opacity(ropeLength > proxy.size.height * 0.2 ? 1 : 0)
                            .animation(.easeIn(duration: 0.8), value: ropeLength)
                    }
                    .onAppear {
                        // Descend the bucket slowly and calmly
                        withAnimation(.easeInOut(duration: 4.0)) {
                            ropeLength = proxy.size.height * 0.4 // Lower to mid-screen
                        }
                        
                        // Add a slow, gentle wobbly swinging effect
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            bucketRotation = 8
                        }
                        
                        // Finish loading after the slow descent completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                            // Drop it into the well
                            withAnimation(.easeIn(duration: 0.8)) {
                                ropeLength = proxy.size.height + 200
                            }
                            
                            // Transition to main welcome screen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    isLoading = false
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
            } else {
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
                                LinearGradient(colors: [Color(hex: "8A2BE2"), Color(hex: "4169E1")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    }
                    .scaleEffect(showContent ? 1 : 0.8)
                    .opacity(showContent ? 1 : 0)
                    .padding(.bottom, 32)
                    
                    // Title
                    Text("Wishing Well")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    // Subtitle
                    Text("Throw your dreams into the digital well and watch them ripple into reality.")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.6))
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
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.black.opacity(0.03))
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
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
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                        showContent = true
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
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

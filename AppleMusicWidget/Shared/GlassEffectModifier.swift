//
//  GlassEffectModifier.swift
//  AppleMusicWidget
//
//  Glass morphism effect for modern UI design
//

import SwiftUI

struct GlassEffectModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var blurRadius: CGFloat = 10
    var opacity: Double = 0.7

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Blur background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .opacity(opacity)

                    // Gradient overlay for depth
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Border for glass effect
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

extension View {
    func glassEffect(cornerRadius: CGFloat = 20, blurRadius: CGFloat = 10, opacity: Double = 0.7) -> some View {
        self.modifier(GlassEffectModifier(cornerRadius: cornerRadius, blurRadius: blurRadius, opacity: opacity))
    }
}

// Control Button Style with Glass Effect
struct GlassButtonStyle: ButtonStyle {
    var size: CGFloat = 50
    var isMain: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: isMain ? 24 : 20))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)

                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(configuration.isPressed ? 0.4 : 0.3),
                                    Color.white.opacity(configuration.isPressed ? 0.1 : 0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Circle()
                        .strokeBorder(
                            Color.white.opacity(0.5),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.3), radius: configuration.isPressed ? 5 : 10, x: 0, y: configuration.isPressed ? 2 : 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

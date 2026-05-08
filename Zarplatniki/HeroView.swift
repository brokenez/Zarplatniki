import SwiftUI

struct HeroView: View {
    var config: ParticleConfig
    @State private var motion = MotionManager()
    private let tiltStrength: Double = 18
    private let coinSize: CGFloat = 180

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let centerY: CGFloat = 120

            ZStack {
                Image("ellipse365")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .blur(radius: 32)
                    .opacity(0.6)
                    .position(x: w / 2, y: centerY)

                ParticleSystemView(
                    coinCenter: CGPoint(x: w / 2, y: centerY),
                    bounds: geo.size,
                    config: config
                )

                coinGlow
                    .position(x: w / 2, y: centerY)

                Image("coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: coinSize, height: coinSize)
                    .rotation3DEffect(
                        .degrees(clamped(motion.pitch * tiltStrength, to: -16...16)),
                        axis: (x: 1, y: 0, z: 0),
                        perspective: 0.55
                    )
                    .rotation3DEffect(
                        .degrees(clamped(-motion.roll * tiltStrength, to: -16...16)),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.55
                    )
                    .animation(.interpolatingSpring(stiffness: 60, damping: 12), value: motion.roll)
                    .animation(.interpolatingSpring(stiffness: 60, damping: 12), value: motion.pitch)
                    .position(x: w / 2, y: centerY)
            }
        }
        .frame(height: 240)
    }

    private var coinGlow: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(config.glowBrightness * 0.24))
                .frame(width: 210, height: 210)
                .blur(radius: 34)

            Circle()
                .fill(.white.opacity(config.glowBrightness * 0.16))
                .frame(width: 150, height: 150)
                .blur(radius: 18)
        }
        .blendMode(.screen)
        .allowsHitTesting(false)
    }

    private func clamped(_ value: Double, to range: ClosedRange<Double>) -> Double {
        min(max(value, range.lowerBound), range.upperBound)
    }
}

#Preview {
    ZStack {
        Color.black
        HeroView(config: ParticleConfig())
    }
}

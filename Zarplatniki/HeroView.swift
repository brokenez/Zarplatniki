import SwiftUI

private extension Color {
    static let heroAction = Color(red: 0.341, green: 0.545, blue: 0.976)
}

struct HeroView: View {
    var config: ParticleConfig
    var onCoinTap: () -> Void = {}
    @State private var motion = MotionManager()
    @State private var rippleStart = Date.distantPast
    @State private var rippleSeed = 0
    @State private var flashVisible = false
    private let tiltStrength: Double = 21.6
    private let coinSize: CGFloat = 180

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let centerY: CGFloat = 120

            TimelineView(.animation) { timeline in
                let rippleAge = timeline.date.timeIntervalSince(rippleStart)
                let rippleProgress = min(max(rippleAge / 0.9, 0), 1)
                let rippleAmplitude = max(0, 1 - rippleProgress) * config.rippleDistortion
                let rippleSize = max(config.rippleSize, 0.1)
                let rippleWavelength = max(config.rippleWavelength, 1)

                ZStack {
                    rippleWave(progress: rippleProgress, size: rippleSize, wavelength: rippleWavelength)
                        .position(x: w / 2, y: centerY)
                        .opacity(rippleAge < 0.9 ? 1 : 0)

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

                    Button(action: triggerRipple) {
                        Image("coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: coinSize, height: coinSize)
                            .distortionEffect(
                                ShaderLibrary.coinRipple(
                                    .float2(Float(coinSize / 2), Float(coinSize / 2)),
                                    .float(Float(rippleAge)),
                                    .float(Float(rippleAmplitude)),
                                    .float(Float(rippleWavelength)),
                                    .float(Float(250 * rippleSize))
                                ),
                                maxSampleOffset: CGSize(width: 56, height: 56)
                            )
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
                            .scaleEffect(flashVisible ? 1.04 : 1)
                            .shadow(color: .white.opacity(flashVisible ? 0.9 : 0), radius: flashVisible ? 34 : 0)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Монета")
                    .accessibilityHint("Запускает волну и вспышку")
                    .position(x: w / 2, y: centerY)
                }
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

    private func rippleWave(progress: Double, size: Double, wavelength: Double) -> some View {
        let waveScale = CGFloat(size)
        let softness = CGFloat(wavelength / 24)

        return ZStack {
            Circle()
                .stroke(.white.opacity(0.42 * (1 - progress)), lineWidth: 2)
                .frame(width: (120 + 240 * progress) * waveScale, height: (120 + 240 * progress) * waveScale)
                .blur(radius: 1.2 * softness)

            Circle()
                .stroke(Color.heroAction.opacity(0.48 * (1 - progress)), lineWidth: 10)
                .frame(width: (90 + 180 * progress) * waveScale, height: (90 + 180 * progress) * waveScale)
                .blur(radius: 12 * softness)
                .blendMode(.screen)

            Circle()
                .fill(.white.opacity(0.18 * (1 - progress)))
                .frame(width: (70 + 120 * progress) * waveScale, height: (70 + 120 * progress) * waveScale)
                .blur(radius: 22 * softness)
                .blendMode(.screen)
        }
        .id(rippleSeed)
        .allowsHitTesting(false)
    }

    private func triggerRipple() {
        rippleSeed += 1
        rippleStart = Date()
        onCoinTap()

        withAnimation(.easeOut(duration: 0.16)) {
            flashVisible = true
        } completion: {
            withAnimation(.easeOut(duration: 0.55)) {
                flashVisible = false
            }
        }
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

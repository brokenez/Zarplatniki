import SwiftUI

struct ParticleData {
    let angle: Double
    let speed: CGFloat
    let size: CGFloat
    let maxDist: CGFloat
    let baseAlpha: Double
    let disappearAt: CGFloat
    let fadeOutLength: CGFloat
    let distOffset: CGFloat
}

struct ParticleSystemView: View {
    let coinCenter: CGPoint
    let bounds: CGSize
    var config: ParticleConfig

    @State private var particles: [ParticleData] = []
    @State private var startDate = Date()
    @State private var lastCount: Int = 0

    var body: some View {
        TimelineView(.animation) { ctx in
            let elapsed = CGFloat(ctx.date.timeIntervalSince(startDate))
            Canvas { context, size in
                for p in particles {
                    let raw = p.distOffset + elapsed * p.speed * 28
                    let dist = raw.truncatingRemainder(dividingBy: p.maxDist)

                    let x = coinCenter.x + cos(p.angle) * dist
                    let y = coinCenter.y + sin(p.angle) * dist

                    guard x >= 0, x <= size.width, y >= 0, y <= size.height else { continue }

                    let progress = dist / p.maxDist
                    let fadeIn = min(progress / 0.12, 1)
                    let fadeOut = max(min((p.disappearAt - progress) / p.fadeOutLength, 1), 0)
                    let alpha = p.baseAlpha * config.opacity * Double(fadeIn * fadeOut)

                    let rect = CGRect(x: x - p.size / 2, y: y - p.size / 2, width: p.size, height: p.size)
                    var ctx2 = context
                    ctx2.opacity = alpha
                    ctx2.fill(Path(ellipseIn: rect), with: .color(.white))
                }
            }
        }
        .onChange(of: Int(config.count)) { _, newCount in
            regenerate(count: newCount)
        }
        .onChange(of: config.size) { _, _ in regenerate(count: Int(config.count)) }
        .onChange(of: config.speed) { _, _ in regenerate(count: Int(config.count)) }
        .onChange(of: config.maxDistance) { _, _ in regenerate(count: Int(config.count)) }
        .onAppear { regenerate(count: Int(config.count)) }
    }

    private func regenerate(count: Int) {
        guard count > 0 else { particles = []; return }
        let maxDist = max(config.maxDistance, 10)
        let baseSize = max(config.size, 0.5)
        let baseSpeed = max(config.speed, 0.05)

        startDate = Date()
        particles = (0..<count).map { i in
            let baseAngle = Double(i) * (2 * .pi / Double(count))
            let jitter = Double.random(in: -0.25...0.25)
            let distLow = min(55, maxDist * 0.3)
            let maxD = CGFloat.random(in: distLow...maxDist)
            let sizeSpread = baseSize * 0.5
            let speedSpread = baseSpeed * 0.6
            return ParticleData(
                angle: baseAngle + jitter,
                speed: CGFloat.random(in: max(baseSpeed - speedSpread, 0.01)...(baseSpeed + speedSpread)),
                size: CGFloat.random(in: max(baseSize - sizeSpread, 0.3)...(baseSize + sizeSpread)),
                maxDist: maxD,
                baseAlpha: Double.random(in: 0.45...1.0),
                disappearAt: CGFloat.random(in: 0.55...0.98),
                fadeOutLength: CGFloat.random(in: 0.05...0.18),
                distOffset: CGFloat.random(in: 0...maxD)
            )
        }
    }
}

import SwiftUI

struct ParticleData {
    let angle: Double
    let speed: CGFloat
    let size: CGFloat
    let maxDist: CGFloat
    let flickerRate: Double
    let phase: Double
    let baseAlpha: Double
    let distOffset: CGFloat
}

struct ParticleSystemView: View {
    let coinCenter: CGPoint
    let bounds: CGSize

    @State private var particles: [ParticleData] = []
    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation) { ctx in
            let elapsed = CGFloat(ctx.date.timeIntervalSince(startDate))
            Canvas { context, _ in
                for p in particles {
                    let raw = p.distOffset + elapsed * p.speed * 28
                    let dist = raw.truncatingRemainder(dividingBy: p.maxDist)

                    let x = coinCenter.x + cos(p.angle) * dist
                    let y = coinCenter.y + sin(p.angle) * dist

                    let flicker = 0.35 + 0.65 * abs(sin(Double(elapsed) * p.flickerRate + p.phase))
                    let progress = dist / p.maxDist
                    let fade: Double = progress < 0.12 ? Double(progress / 0.12) : (progress > 0.78 ? Double((1 - progress) / 0.22) : 1.0)
                    let alpha = p.baseAlpha * 0.65 * flicker * fade

                    let rect = CGRect(x: x - p.size / 2, y: y - p.size / 2, width: p.size, height: p.size)
                    var ctx2 = context
                    ctx2.opacity = alpha
                    ctx2.fill(Path(ellipseIn: rect), with: .color(.white))
                }
            }
        }
        .onAppear { spawnParticles() }
    }

    private func spawnParticles() {
        startDate = Date()
        let count = 55
        particles = (0..<count).map { i in
            let baseAngle = Double(i) * (2 * .pi / Double(count))
            let jitter = Double.random(in: -0.25...0.25)
            let maxD = CGFloat.random(in: 55...160)
            return ParticleData(
                angle: baseAngle + jitter,
                speed: CGFloat.random(in: 0.25...1.0),
                size: CGFloat.random(in: 1.5...4.5),
                maxDist: maxD,
                flickerRate: Double.random(in: 1.2...5.5),
                phase: Double(i) * 0.618,
                baseAlpha: Double.random(in: 0.45...1.0),
                distOffset: CGFloat.random(in: 0...maxD)
            )
        }
    }
}

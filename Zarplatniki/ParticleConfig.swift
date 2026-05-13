import SwiftUI

struct ParticleConfig: Equatable {
    var count: Double = 55
    var size: Double = 3.0
    var speed: Double = 0.6
    var maxDistance: Double = 160
    var opacity: Double = 0.65

    var gradientR: Double = 0.04
    var gradientG: Double = 0.28
    var gradientB: Double = 0.31
    var glowBrightness: Double = 0.55

    var rippleSize: Double = 1.0
    var rippleDistortion: Double = 22
    var rippleWavelength: Double = 24

    var heroGradientColor: Color {
        Color(red: gradientR, green: gradientG, blue: gradientB)
    }
}

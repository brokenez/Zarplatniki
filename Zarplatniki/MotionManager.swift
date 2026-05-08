import SwiftUI
import Observation
#if os(iOS)
import CoreMotion

@Observable
final class MotionManager {
    var roll: Double = 0
    var pitch: Double = 0

    private let manager = CMMotionManager()

    init() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion else { return }
            self?.roll = motion.attitude.roll
            self?.pitch = motion.attitude.pitch
        }
    }

    deinit {
        manager.stopDeviceMotionUpdates()
    }
}
#else
@Observable
final class MotionManager {
    var roll: Double = 0
    var pitch: Double = 0
}
#endif

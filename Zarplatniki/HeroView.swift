import SwiftUI

struct HeroView: View {
    @State private var motion = MotionManager()
    private let parallaxStrength: CGFloat = 14

    var body: some View {
        ZStack {
            Image("ellipse365")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .blur(radius: 32)
                .opacity(0.6)

            Image("particles_bg")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .offset(
                    x: CGFloat(motion.roll) * parallaxStrength,
                    y: CGFloat(motion.pitch) * -parallaxStrength
                )
                .animation(.interpolatingSpring(stiffness: 60, damping: 12), value: motion.roll)
                .animation(.interpolatingSpring(stiffness: 60, damping: 12), value: motion.pitch)
        }
        .frame(height: 220)
    }
}

#Preview {
    ZStack {
        Color.black
        HeroView()
    }
}

import SwiftUI

struct DebugPanel: View {
    @Binding var config: ParticleConfig
    @Binding var isOpen: Bool

    var body: some View {
        VStack(spacing: 0) {
            handle
            if isOpen {
                controls
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 12)
        .animation(.spring(duration: 0.35), value: isOpen)
    }

    private var handle: some View {
        Button {
            isOpen.toggle()
        } label: {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 14, weight: .semibold))
                Text("Particles")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Image(systemName: isOpen ? "chevron.down" : "chevron.up")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    private var controls: some View {
        ScrollView {
            VStack(spacing: 16) {
                paramSection("Particles") {
                    sliderRow("Count", value: $config.count, range: 5...200, step: 1)
                    sliderRow("Size", value: $config.size, range: 0.5...10)
                    sliderRow("Speed", value: $config.speed, range: 0.05...3)
                    sliderRow("Distance", value: $config.maxDistance, range: 20...300)
                }

                paramSection("Gradient RGB") {
                    colorSlider("R", value: $config.gradientR, tint: .red)
                    colorSlider("G", value: $config.gradientG, tint: .green)
                    colorSlider("B", value: $config.gradientB, tint: .blue)
                    sliderRow("Glow", value: $config.glowBrightness, range: 0...1)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(config.heroGradientColor)
                        .frame(height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(maxHeight: 340)
    }

    private func paramSection(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white.opacity(0.5))
                .textCase(.uppercase)
            content()
        }
    }

    private func sliderRow(_ label: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double = 0.01) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: 90, alignment: .leading)
            Slider(value: value, in: range, step: step)
                .tint(.white.opacity(0.5))
            Text(step >= 1 ? String(format: "%.0f", value.wrappedValue) : String(format: "%.2f", value.wrappedValue))
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 40, alignment: .trailing)
        }
    }

    private func colorSlider(_ label: String, value: Binding<Double>, tint: Color) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 20, alignment: .leading)
            Slider(value: value, in: 0...1)
                .tint(tint)
            Text(String(format: "%.2f", value.wrappedValue))
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 40, alignment: .trailing)
        }
    }
}

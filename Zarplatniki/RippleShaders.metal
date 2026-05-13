#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] float2 coinRipple(float2 position, float2 center, float time, float amplitude, float wavelength, float maxRadius) {
    if (time < 0.0 || time > 0.9 || amplitude <= 0.0) {
        return position;
    }

    float2 delta = position - center;
    float distanceFromCenter = length(delta);
    if (distanceFromCenter < 0.001) {
        return position;
    }

    float waveRadius = 34.0 + time * maxRadius;
    float waveWidth = max(wavelength, 1.0);
    float distanceFromWave = abs(distanceFromCenter - waveRadius);
    float waveFalloff = smoothstep(waveWidth, 0.0, distanceFromWave);
    float decay = 1.0 - smoothstep(0.0, 0.9, time);
    float waveFrequency = 4.1 / waveWidth;
    float wave = sin(distanceFromCenter * waveFrequency - time * 22.0) * amplitude * waveFalloff * decay;

    return position + normalize(delta) * wave;
}

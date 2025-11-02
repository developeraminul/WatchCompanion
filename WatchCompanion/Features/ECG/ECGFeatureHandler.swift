//
//  ECGFeatureHandler.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import SwiftUI

class ECGFeatureHandler: WatchFeatureHandler {
    typealias FeatureType = ECGMonitoring
    
    func handleFeatureUpdate(_ feature: ECGMonitoring, for device: WatchDevice) {
        print("ECG update from \(device.displayName): \(feature.rhythmType)")
        
        NotificationCenter.default.post(
            name: .ecgDataDidUpdate,
            object: nil,
            userInfo: ["device": device, "feature": feature]
        )
    }
    
    func createSwiftUIView(for feature: ECGMonitoring) -> AnyView {
        return AnyView(ECGMonitoringView(feature: feature))
    }
}

struct ECGMonitoringView: View {
    let feature: ECGMonitoring
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(.green)
                Text("ECG")
                    .font(.headline)
            }
            
            // Simulated ECG waveform
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.1))
                    .frame(height: 60)
                
                Path { path in
                    let points = generateECGWaveform()
                    path.move(to: CGPoint(x: 0, y: 30))
                    for point in points {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.green, lineWidth: 2)
            }
            .cornerRadius(8)
            
            Text(feature.rhythmType)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4)
    }
    
    private func generateECGWaveform() -> [CGPoint] {
        var points: [CGPoint] = []
        for x in stride(from: 0, to: 100, by: 2) {
            let y = 30 + 10 * sin(Double(x) * 0.2) + 5 * sin(Double(x) * 0.5)
            points.append(CGPoint(x: Double(x), y: y))
        }
        return points
    }
}

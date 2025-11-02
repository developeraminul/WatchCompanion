//
//  BloodOxygenFeatureHandler.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import SwiftUI

class BloodOxygenFeatureHandler: WatchFeatureHandler {
    typealias FeatureType = BloodOxygenMonitoring
    
    func handleFeatureUpdate(_ feature: BloodOxygenMonitoring, for device: WatchDevice) {
        print("Blood oxygen update from \(device.displayName): \(feature.spo2Level)%")
        
        NotificationCenter.default.post(
            name: .bloodOxygenDidUpdate,
            object: nil,
            userInfo: ["device": device, "feature": feature]
        )
    }
    
    func createSwiftUIView(for feature: BloodOxygenMonitoring) -> AnyView {
        return AnyView(BloodOxygenView(feature: feature))
    }
}

struct BloodOxygenView: View {
    let feature: BloodOxygenMonitoring
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "o.circle.fill")
                .foregroundColor(getOxygenColor())
                .font(.title2)
            
            Text("\(Int(feature.spo2Level))%")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(getOxygenColor())
            
            Text("SpO2")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120) // FIX: Consistent sizing
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4)
    }
    
    private func getOxygenColor() -> Color {
        switch feature.spo2Level {
        case 95...100:
            return .green
        case 90..<95:
            return .orange
        case ..<90:
            return .red
        default:
            return .blue
        }
    }
}

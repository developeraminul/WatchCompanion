//
//  HeartRateFeatureHandler.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import SwiftUI

class HeartRateFeatureHandler: WatchFeatureHandler {
    typealias FeatureType = HeartRateMonitoring
    
    func handleFeatureUpdate(_ feature: HeartRateMonitoring, for device: WatchDevice) {
        print("Heart rate update from \(device.displayName): \(feature.currentBPM) BPM")
        
        // Notify observers
        NotificationCenter.default.post(
            name: .heartRateDidUpdate,
            object: nil,
            userInfo: ["device": device, "feature": feature]
        )
    }
    
    func createSwiftUIView(for feature: HeartRateMonitoring) -> AnyView {
        return AnyView(HeartRateView(feature: feature))
    }
}

struct HeartRateView: View {
    let feature: HeartRateMonitoring
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .foregroundColor(getHeartRateColor())
                .font(.title2)
            
            Text("\(feature.currentBPM)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(getHeartRateColor())
            
            Text("BPM")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120) // FIX: Consistent sizing
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4)
    }
    
    private func getHeartRateColor() -> Color {
        switch feature.currentBPM {
        case 60...100:
            return .green
        case 101...120:
            return .orange
        case 121...:
            return .red
        default:
            return .blue
        }
    }
}

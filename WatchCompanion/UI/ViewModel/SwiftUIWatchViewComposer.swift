import SwiftUI
import Combine

// FIX: Create an identifiable wrapper for feature placeholders
struct FeaturePlaceholder: Identifiable {
    let id = UUID()
    let view: AnyView
    let featureIdentifier: String
}

class SwiftUIWatchViewComposer: ObservableObject {
    @Published private(set) var featurePlaceholders: [FeaturePlaceholder] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        WatchConnectionManager.shared.$currentDevice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.updateFeaturePlaceholders(for: device)
            }
            .store(in: &cancellables)
    }
    
    private func updateFeaturePlaceholders(for device: (any WatchDevice)?) {
        featurePlaceholders.removeAll()
        
        guard let device = device,
              let supportedFeatures = getSupportedFeatures(for: device.model) else {
            return
        }
        
        for featureType in supportedFeatures {
            let placeholder = createPlaceholderView(for: featureType)
            featurePlaceholders.append(placeholder)
        }
    }
    
    private func getSupportedFeatures(for model: String) -> [any WatchFeature.Type]? {
        return WatchDeviceRegistry.shared.getSupportedFeatures(for: model)
    }
    
    private func createPlaceholderView(for featureType: any WatchFeature.Type) -> FeaturePlaceholder {
        let identifier = featureType.featureIdentifier
        let displayName = identifier.replacingOccurrences(of: "_", with: " ").capitalized
        
        let view = VStack {
            Image(systemName: getIconName(for: identifier))
                .foregroundColor(.secondary)
                .font(.title2)
            
            Text(displayName)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Waiting for data...")
                .font(.caption2)
                .foregroundColor(.orange)
        }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        
        return FeaturePlaceholder(
            view: AnyView(view),
            featureIdentifier: identifier
        )
    }
    
    private func getIconName(for featureIdentifier: String) -> String {
        switch featureIdentifier {
        case "heart_rate_monitoring":
            return "heart"
        case "ecg_monitoring":
            return "waveform.path.ecg"
        case "blood_oxygen_monitoring":
            return "o.circle"
        case "step_counting":
            return "figure.walk"
        default:
            return "questionmark.circle"
        }
    }
}

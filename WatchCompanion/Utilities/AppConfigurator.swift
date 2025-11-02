import Foundation

class AppConfigurator {
    static func setupWatchApp() {
        registerDeviceFactories()
        registerFeatureHandlers()
        // FIX: Remove duplicate delegate setup since it's now in WatchConnectionManager init
        print("✅ App configuration completed")
    }
    
    private static func registerDeviceFactories() {
        let registry = WatchDeviceRegistry.shared
        
        registry.registerDeviceFactory(FitnessWatchFactory(), for: "FitnessX")
        registry.registerDeviceFactory(SmartWatchProFactory(), for: "SmartPro")
        registry.registerDeviceFactory(FutureWatchFactory(), for: "FutureX")
        
        print("✅ Device factories registered")
    }
    
    private static func registerFeatureHandlers() {
        let registry = WatchDeviceRegistry.shared
        
        registry.registerFeatureHandler(HeartRateFeatureHandler(), for: "heart_rate_monitoring")
        registry.registerFeatureHandler(ECGFeatureHandler(), for: "ecg_monitoring")
        registry.registerFeatureHandler(BloodOxygenFeatureHandler(), for: "blood_oxygen_monitoring")
        
        print("✅ Feature handlers registered")
    }
}

class AppConnectionDelegate: WatchConnectionDelegate {
    func deviceDidConnect(_ device: WatchDevice) {
        print("📱 Device connected: \(device.displayName)")
        
        // Notify UI
        NotificationCenter.default.post(
            name: .deviceDidConnect,
            object: nil,
            userInfo: ["device": device]
        )
    }
    
    func deviceDidDisconnect(_ device: WatchDevice) {
        print("📱 Device disconnected: \(device.displayName)")
        
        NotificationCenter.default.post(
            name: .deviceDidDisconnect,
            object: nil,
            userInfo: ["device": device]
        )
    }
    
    func device(_ device: WatchDevice, didUpdate feature: WatchFeature) {
        print("📱 Feature update from \(device.displayName): \(type(of: feature).featureIdentifier)")
        
        // FIX: Use type(of: feature).featureIdentifier instead of feature.featureIdentifier
        let featureIdentifier = type(of: feature).featureIdentifier
        
        // Route to appropriate feature handler
        if let handler: HeartRateFeatureHandler = WatchDeviceRegistry.shared.getFeatureHandler(for: featureIdentifier),
           let heartRateFeature = feature as? HeartRateMonitoring {
            print("❤️ Routing to HeartRateFeatureHandler")
            handler.handleFeatureUpdate(heartRateFeature, for: device)
        } else if let handler: ECGFeatureHandler = WatchDeviceRegistry.shared.getFeatureHandler(for: featureIdentifier),
                  let ecgFeature = feature as? ECGMonitoring {
            print("📊 Routing to ECGFeatureHandler")
            handler.handleFeatureUpdate(ecgFeature, for: device)
        } else if let handler: BloodOxygenFeatureHandler = WatchDeviceRegistry.shared.getFeatureHandler(for: featureIdentifier),
                  let bloodOxygenFeature = feature as? BloodOxygenMonitoring {
            print("💧 Routing to BloodOxygenFeatureHandler")
            handler.handleFeatureUpdate(bloodOxygenFeature, for: device)
        } else if let stepFeature = feature as? StepCounting {
            // Handle step counting directly or add a handler
            print("🚶 Routing Step Counting")
            NotificationCenter.default.post(
                name: Notification.Name("stepCountDidUpdate"),
                object: nil,
                userInfo: ["device": device, "feature": stepFeature]
            )
        } else {
            print("❌ No handler found for feature: \(featureIdentifier)")
        }
    }
}

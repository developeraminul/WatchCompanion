import Foundation

class FitnessWatchFactory: WatchDeviceFactory {
    func createDevice(connectionData: Any) -> WatchDevice {
        let model = (connectionData as? [String: Any])?["model"] as? String ?? "FitnessX"
        let firmware = (connectionData as? [String: Any])?["firmware"] as? String ?? "1.0"
        return FitnessWatch(model: model, firmwareVersion: firmware)
    }
    
    // FIX: Update return type
    func supportedFeatures() -> [any WatchFeature.Type] {
        return [HeartRateMonitoring.self, StepCounting.self]
    }
}

class SmartWatchProFactory: WatchDeviceFactory {
    func createDevice(connectionData: Any) -> WatchDevice {
        let model = (connectionData as? [String: Any])?["model"] as? String ?? "SmartPro"
        let firmware = (connectionData as? [String: Any])?["firmware"] as? String ?? "2.0"
        return SmartWatchPro(model: model, firmwareVersion: firmware)
    }
    
    // FIX: Update return type
    func supportedFeatures() -> [any WatchFeature.Type] {
        return [HeartRateMonitoring.self, ECGMonitoring.self, BloodOxygenMonitoring.self, StepCounting.self]
    }
}

class FutureWatchFactory: WatchDeviceFactory {
    func createDevice(connectionData: Any) -> WatchDevice {
        let model = (connectionData as? [String: Any])?["model"] as? String ?? "FutureX"
        let firmware = (connectionData as? [String: Any])?["firmware"] as? String ?? "3.0"
        return FutureWatchModel(model: model, firmwareVersion: firmware)
    }
    
    // FIX: Update return type
    func supportedFeatures() -> [any WatchFeature.Type] {
        return [HeartRateMonitoring.self, ECGMonitoring.self, BloodOxygenMonitoring.self, StepCounting.self]
    }
}

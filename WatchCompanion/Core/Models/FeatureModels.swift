import Foundation

// MARK: - Feature Definitions
struct HeartRateMonitoring: WatchFeature {
    // FIX: Change to static property
    static let featureIdentifier: String = "heart_rate_monitoring"
    let currentBPM: Int
    let timestamp: Date
    
    init(currentBPM: Int, timestamp: Date = Date()) {
        self.currentBPM = currentBPM
        self.timestamp = timestamp
    }
    
    func isSupported(by device: WatchDevice) -> Bool {
        return true // All devices support heart rate
    }
}

struct ECGMonitoring: WatchFeature {
    // FIX: Change to static property
    static let featureIdentifier: String = "ecg_monitoring"
    let reading: Data
    let rhythmType: String
    let timestamp: Date
    
    init(reading: Data, rhythmType: String, timestamp: Date = Date()) {
        self.reading = reading
        self.rhythmType = rhythmType
        self.timestamp = timestamp
    }
    
    func isSupported(by device: WatchDevice) -> Bool {
        return device.model.contains("Pro") || device.model.contains("Future")
    }
}

struct BloodOxygenMonitoring: WatchFeature {
    // FIX: Change to static property
    static let featureIdentifier: String = "blood_oxygen_monitoring"
    let spo2Level: Double
    let timestamp: Date
    
    init(spo2Level: Double, timestamp: Date = Date()) {
        self.spo2Level = spo2Level
        self.timestamp = timestamp
    }
    
    func isSupported(by device: WatchDevice) -> Bool {
        return device.model.contains("Pro") || device.model.contains("Future")
    }
}

struct StepCounting: WatchFeature {
    // FIX: Change to static property
    static let featureIdentifier: String = "step_counting"
    let stepCount: Int
    let timestamp: Date
    let distance: Double
    
    init(stepCount: Int, distance: Double, timestamp: Date = Date()) {
        self.stepCount = stepCount
        self.distance = distance
        self.timestamp = timestamp
    }
    
    func isSupported(by device: WatchDevice) -> Bool {
        return true // All devices support step counting
    }
}

import Foundation
import Combine

class WatchConnectionManager: ObservableObject {
    static let shared = WatchConnectionManager()
    
    @Published private(set) var connectedDevices: [any WatchDevice] = []
    @Published private(set) var currentDevice: (any WatchDevice)?
    
    private var delegate: WatchConnectionDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Set self as delegate for demo purposes
        self.delegate = AppConnectionDelegate()
    }
    
    func connectToDevice(with data: Any) {
        // In real implementation, this would parse connection data
        // For demo, we'll simulate connection
        let model = extractModel(from: data) ?? "FitnessX"
        
        guard let device = WatchDeviceRegistry.shared.createDevice(for: model, connectionData: data) else {
            print("Failed to create device for model: \(model)")
            return
        }
        
        connectedDevices.append(device)
        currentDevice = device
        delegate?.deviceDidConnect(device)
        
        objectWillChange.send()
    }
    
    func switchToDevice(_ device: any WatchDevice) {
        currentDevice = device
        objectWillChange.send()
    }
    
    func disconnectDevice(_ device: any WatchDevice) {
        connectedDevices.removeAll { $0.id == device.id }
        if currentDevice?.id == device.id {
            currentDevice = connectedDevices.first
        }
        delegate?.deviceDidDisconnect(device)
        objectWillChange.send()
    }
    
    // FIX: Improved feature simulation that properly routes through handlers
    func simulateFeatureUpdate(_ feature: any WatchFeature) {
        guard let device = currentDevice else {
            print("❌ No device connected to simulate feature")
            return
        }
        
        print("🎯 Simulating feature: \(type(of: feature).featureIdentifier) for device: \(device.displayName)")
        delegate?.device(device, didUpdate: feature)
    }
    
    // FIX: Add specific simulation methods for better control
    func simulateHeartRate() {
        guard currentDevice != nil else { return }
        let heartRate = Int.random(in: 60...120)
        let feature = HeartRateMonitoring(currentBPM: heartRate)
        simulateFeatureUpdate(feature)
    }
    
    func simulateECG() {
        guard currentDevice != nil else { return }
        let rhythms = ["Sinus Rhythm", "Atrial Fibrillation", "Normal Sinus Rhythm"]
        let randomRhythm = rhythms.randomElement() ?? "Sinus Rhythm"
        let feature = ECGMonitoring(reading: Data(), rhythmType: randomRhythm)
        simulateFeatureUpdate(feature)
    }
    
    func simulateBloodOxygen() {
        guard currentDevice != nil else { return }
        let spo2 = Double.random(in: 85...100)
        let feature = BloodOxygenMonitoring(spo2Level: spo2)
        simulateFeatureUpdate(feature)
    }
    
    func simulateSteps() {
        guard currentDevice != nil else { return }
        let steps = Int.random(in: 0...15000)
        let distance = Double(steps) * 0.000762 // Approximate km per step
        let feature = StepCounting(stepCount: steps, distance: distance)
        simulateFeatureUpdate(feature)
    }
    
    // Demo method to simulate device connection
    func simulateDeviceConnection() {
        let demoData = ["model": "FitnessX", "firmware": "1.0"]
        connectToDevice(with: demoData)
        
        // Simulate another device
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let proData = ["model": "SmartPro", "firmware": "2.0"]
            self.connectToDevice(with: proData)
        }
    }
    
    private func extractModel(from data: Any) -> String? {
        if let dict = data as? [String: Any] {
            return dict["model"] as? String
        }
        return nil
    }
    
    func setDelegate(_ delegate: WatchConnectionDelegate) {
        self.delegate = delegate
    }
}

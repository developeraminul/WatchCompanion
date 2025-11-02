import SwiftUI
import Combine

class WatchFeatureObservable: ObservableObject {
    @Published var heartRate: HeartRateMonitoring?
    @Published var ecg: ECGMonitoring?
    @Published var bloodOxygen: BloodOxygenMonitoring?
    @Published var steps: StepCounting?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        // Heart Rate Observer
        NotificationCenter.default.publisher(for: .heartRateDidUpdate)
            .compactMap { $0.userInfo?["feature"] as? HeartRateMonitoring }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feature in
                self?.heartRate = feature
            }
            .store(in: &cancellables)
        
        // ECG Observer
        NotificationCenter.default.publisher(for: .ecgDataDidUpdate)
            .compactMap { $0.userInfo?["feature"] as? ECGMonitoring }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feature in
                self?.ecg = feature
            }
            .store(in: &cancellables)
        
        // Blood Oxygen Observer
        NotificationCenter.default.publisher(for: .bloodOxygenDidUpdate)
            .compactMap { $0.userInfo?["feature"] as? BloodOxygenMonitoring }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feature in
                self?.bloodOxygen = feature
            }
            .store(in: &cancellables)
        
        // Step Count Observer
        NotificationCenter.default.publisher(for: Notification.Name("stepCountDidUpdate"))
            .compactMap { $0.userInfo?["feature"] as? StepCounting }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feature in
                self?.steps = feature
            }
            .store(in: &cancellables)
    }
}

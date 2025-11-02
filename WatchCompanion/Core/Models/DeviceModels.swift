//
//  DeviceModels.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import Foundation

// MARK: - Base Device Implementation
class BaseWatchDevice: WatchDevice {
    let id: UUID
    let model: String
    let firmwareVersion: String
    var displayName: String { model }
    
    init(id: UUID = UUID(), model: String, firmwareVersion: String) {
        self.id = id
        self.model = model
        self.firmwareVersion = firmwareVersion
    }
}

// MARK: - Specific Device Models
class FitnessWatch: BaseWatchDevice {
    let maxHeartRate: Int = 200
    
    override init(id: UUID = UUID(), model: String, firmwareVersion: String) {
        super.init(id: id, model: model, firmwareVersion: firmwareVersion)
    }
}

class SmartWatchPro: BaseWatchDevice {
    let hasECG: Bool = true
    let hasBloodOxygen: Bool = true
    
    override init(id: UUID = UUID(), model: String, firmwareVersion: String) {
        super.init(id: id, model: model, firmwareVersion: firmwareVersion)
    }
}

class FutureWatchModel: BaseWatchDevice {
    let hasNewFeature: Bool = true
    
    override init(id: UUID = UUID(), model: String, firmwareVersion: String) {
        super.init(id: id, model: model, firmwareVersion: firmwareVersion)
    }
}

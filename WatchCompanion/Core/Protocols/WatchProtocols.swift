import SwiftUI

// MARK: - Core Protocols
protocol WatchDevice: Identifiable {
    var id: UUID { get }
    var model: String { get }
    var firmwareVersion: String { get }
    var displayName: String { get }
}

// FIX: Add initializer requirement to the protocol
protocol WatchFeature {
    static var featureIdentifier: String { get }
    var timestamp: Date { get }
    func isSupported(by device: WatchDevice) -> Bool
}

protocol WatchConnectionDelegate: AnyObject {
    func deviceDidConnect(_ device: WatchDevice)
    func deviceDidDisconnect(_ device: WatchDevice)
    func device(_ device: WatchDevice, didUpdate feature: WatchFeature)
}

protocol WatchDeviceFactory {
    func createDevice(connectionData: Any) -> WatchDevice
    func supportedFeatures() -> [any WatchFeature.Type]
}

protocol WatchFeatureHandler {
    associatedtype FeatureType: WatchFeature
    func handleFeatureUpdate(_ feature: FeatureType, for device: WatchDevice)
    func createSwiftUIView(for feature: FeatureType) -> AnyView
}

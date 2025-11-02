import Foundation

class WatchDeviceRegistry {
    static let shared = WatchDeviceRegistry()
    
    private var deviceFactories: [String: any WatchDeviceFactory] = [:]
    private var featureHandlers: [String: Any] = [:]
    
    private init() {}
    
    func registerDeviceFactory(_ factory: any WatchDeviceFactory, for model: String) {
        deviceFactories[model] = factory
    }
    
    func registerFeatureHandler<Handler: WatchFeatureHandler>(_ handler: Handler, for feature: String) {
        featureHandlers[feature] = handler
    }
    
    func createDevice(for model: String, connectionData: Any) -> (any WatchDevice)? {
        return deviceFactories[model]?.createDevice(connectionData: connectionData)
    }
    
    func getFeatureHandler<T>(for feature: String) -> T? {
        return featureHandlers[feature] as? T
    }
    
    // FIX: Update return type
    func getSupportedFeatures(for model: String) -> [any WatchFeature.Type] {
        return deviceFactories[model]?.supportedFeatures() ?? []
    }
}

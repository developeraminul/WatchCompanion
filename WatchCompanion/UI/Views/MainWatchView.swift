import SwiftUI

struct MainWatchView: View {
    @EnvironmentObject var viewComposer: SwiftUIWatchViewComposer
    @EnvironmentObject var connectionManager: WatchConnectionManager
    @EnvironmentObject var featureObserver: WatchFeatureObservable
    
    @State private var showingDevicePicker = false
    @State private var showingFeatureSimulator = false
    @State private var showConnectionAlert = false
    
    var body: some View {
        NavigationView {
            // FIX: Enhanced ScrollView with better configuration
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 20) { // Use LazyVStack for better performance with many items
                    // Device Header - Always visible at top
                    deviceHeaderView
                    
                    // Connection alert when no device is connected
                    if connectionManager.currentDevice == nil {
                        connectionAlertView
                    } else {
                        // Only show content when device is connected
                        connectedDeviceContent
                    }
                    
                    // Bottom spacing to ensure all content is accessible
                    Color.clear
                        .frame(height: 50) // Extra space at bottom
                }
                .padding(.vertical) // Vertical padding for the entire content
            }
            .background(Color(.systemGroupedBackground)) // Better background for scroll view
            .navigationTitle("Watch Companion")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: navBarButtons)
            .sheet(isPresented: $showingDevicePicker) {
                DevicePickerView()
            }
            .sheet(isPresented: $showingFeatureSimulator) {
                FeatureSimulatorView()
            }
            .alert("No Device Connected", isPresented: $showConnectionAlert) {
                Button("Connect Device") {
                    showingDevicePicker = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please connect a device to use demo features.")
            }
        }
    }
    
    // FIX: Extract connected device content to separate view for better organization
    private var connectedDeviceContent: some View {
        Group {
            // Health Features Section - Dynamic grid that can scroll
            healthFeaturesSection
            
            // Status Section
            statusSection
            
            // Quick Actions Section - Always visible at bottom
            quickActionsSection
        }
    }
    
    private var healthFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Health Features")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(activeFeaturesCount) active")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // FIX: SCROLL VIEW WITH DYNAMIC CONTENT HEIGHT
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 16)
                    ],
                    spacing: 16,
                    pinnedViews: [.sectionHeaders]
                ) {
                    Section {
                        // Real-time feature views
                        if let heartRate = featureObserver.heartRate {
                            HeartRateView(feature: heartRate)
                        }
                        
                        if let ecg = featureObserver.ecg {
                            ECGMonitoringView(feature: ecg)
                        }
                        
                        if let bloodOxygen = featureObserver.bloodOxygen {
                            BloodOxygenView(feature: bloodOxygen)
                        }
                        
                        if let steps = featureObserver.steps {
                            StepCountView(feature: steps)
                        }
                        
                        // Placeholder views for supported features
                        ForEach(viewComposer.featurePlaceholders) { placeholder in
                            placeholder.view
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            .shadow(color: .gray.opacity(0.1), radius: 2)
            // FIX: DYNAMIC HEIGHT BASED ON CONTENT (with maximum limit)
            .frame(maxHeight: min(CGFloat((activeFeaturesCount + viewComposer.featurePlaceholders.count) * 150), 600))
        }
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Device Status")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            connectionStatusView
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Quick Actions")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // FIX: Add a button to show full simulator
                Button("More") {
                    showingFeatureSimulator = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            // FIX: Improved grid layout for quick actions
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 12)
                ],
                spacing: 12
            ) {
                QuickActionButton(
                    title: "Heart Rate",
                    icon: "heart.fill",
                    color: .red,
                    action: { connectionManager.simulateHeartRate() }
                )
                
                QuickActionButton(
                    title: "ECG",
                    icon: "waveform.path.ecg",
                    color: .green,
                    action: { connectionManager.simulateECG() }
                )
                
                QuickActionButton(
                    title: "Blood O₂",
                    icon: "o.circle.fill",
                    color: .blue,
                    action: { connectionManager.simulateBloodOxygen() }
                )
                
                QuickActionButton(
                    title: "Steps",
                    icon: "figure.walk",
                    color: .purple,
                    action: { connectionManager.simulateSteps() }
                )
                
                // FIX: Add more quick actions if needed
                QuickActionButton(
                    title: "All Features",
                    icon: "slider.horizontal.3",
                    color: .orange,
                    action: { showingFeatureSimulator = true }
                )
            }
            .padding(.horizontal)
        }
    }
    
    // FIX: Compute active features count
    private var activeFeaturesCount: Int {
        var count = 0
        if featureObserver.heartRate != nil { count += 1 }
        if featureObserver.ecg != nil { count += 1 }
        if featureObserver.bloodOxygen != nil { count += 1 }
        if featureObserver.steps != nil { count += 1 }
        return count
    }
    
    private var deviceHeaderView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(connectionManager.currentDevice?.displayName ?? "No Device Connected")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if let device = connectionManager.currentDevice {
                    Text("Firmware: \(device.firmwareVersion)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "applewatch")
                .font(.largeTitle)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(color: .gray.opacity(0.2), radius: 4)
    }
    
    private var connectionAlertView: some View {
        VStack(spacing: 16) {
            Image(systemName: "applewatch.slash")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("No Device Connected")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Connect a device to view health features and access quick actions")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Connect Device Now") {
                showingDevicePicker = true
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var connectionStatusView: some View {
        HStack {
            // Connection indicator
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(connectionManager.currentDevice != nil ? .green : .red)
                        .font(.caption)
                    
                    Text(connectionManager.currentDevice != nil ? "Connected" : "Disconnected")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Text("\(connectionManager.connectedDevices.count) device(s) available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Connection quality indicator
            if connectionManager.currentDevice != nil {
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        ForEach(0..<4, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.green)
                                .frame(width: 3, height: [6, 10, 14, 18][index])
                        }
                    }
                    Text("Strong")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var navBarButtons: some View {
        HStack(spacing: 16) {
            // Feature Simulator Button
            Button(action: {
                if connectionManager.currentDevice != nil {
                    showingFeatureSimulator.toggle()
                } else {
                    showConnectionAlert = true
                }
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.body)
                    .foregroundColor(connectionManager.currentDevice != nil ? .blue : .gray)
            }
            .disabled(connectionManager.currentDevice == nil)
            
            // Device Picker Button
            Button(action: {
                showingDevicePicker.toggle()
            }) {
                Image(systemName: "list.bullet")
                    .font(.body)
            }
        }
    }
}

// FIX: New component for quick action buttons
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.15), radius: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Keep the existing DemoControlButton for backward compatibility
struct DemoControlButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DemoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

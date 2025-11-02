import SwiftUI

struct FeatureSimulatorView: View {
    @EnvironmentObject var connectionManager: WatchConnectionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Health Features") {
                    SimulatorButton(
                        title: "Simulate Heart Rate",
                        icon: "heart.fill",
                        color: .red
                    ) {
                        connectionManager.simulateHeartRate()
                    }
                    
                    SimulatorButton(
                        title: "Simulate ECG",
                        icon: "waveform.path.ecg",
                        color: .green
                    ) {
                        connectionManager.simulateECG()
                    }
                    
                    SimulatorButton(
                        title: "Simulate Blood Oxygen",
                        icon: "o.circle.fill",
                        color: .blue
                    ) {
                        connectionManager.simulateBloodOxygen()
                    }
                    
                    SimulatorButton(
                        title: "Simulate Steps",
                        icon: "figure.walk",
                        color: .purple
                    ) {
                        connectionManager.simulateSteps()
                    }
                }
                
                Section("Device Management") {
                    Button("Disconnect Current Device") {
                        if let device = connectionManager.currentDevice {
                            connectionManager.disconnectDevice(device)
                        }
                        dismiss()
                    }
                    .foregroundColor(.red)
                    
                    Button("Simulate Auto-Connection") {
                        connectionManager.simulateDeviceConnection()
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Feature Simulator")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct SimulatorButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                
                Spacer()
            }
        }
    }
}

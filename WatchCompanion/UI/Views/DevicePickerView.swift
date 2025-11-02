//
//  DevicePickerView.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import SwiftUI

struct DevicePickerView: View {
    @EnvironmentObject var viewComposer: SwiftUIWatchViewComposer
    @EnvironmentObject var connectionManager: WatchConnectionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Connected Devices") {
                    if connectionManager.connectedDevices.isEmpty {
                        Text("No devices connected")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(connectionManager.connectedDevices, id: \.id) { device in
                            DeviceRow(
                                device: device,
                                isCurrent: connectionManager.currentDevice?.id == device.id
                            )
                            .onTapGesture {
                                connectionManager.switchToDevice(device)
                                dismiss()
                            }
                        }
                    }
                }
                
                Section("Available Models") {
                    Button("Connect Fitness Watch") {
                        connectDevice(model: "FitnessX")
                    }
                    
                    Button("Connect Smart Watch Pro") {
                        connectDevice(model: "SmartPro")
                    }
                    
                    Button("Connect Future Watch") {
                        connectDevice(model: "FutureX")
                    }
                }
            }
            .navigationTitle("Select Device")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
    
    private func connectDevice(model: String) {
        let connectionData = ["model": model, "firmware": "1.0"]
        connectionManager.connectToDevice(with: connectionData)
    }
}

struct DeviceRow: View {
    let device: any WatchDevice
    let isCurrent: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(device.displayName)
                    .fontWeight(.medium)
                
                Text(device.firmwareVersion)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isCurrent {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
    }
}

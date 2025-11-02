//
//  WatchCompanionApp.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import SwiftUI

@main
struct WatchCompanionApp: App {
    @StateObject private var viewComposer = SwiftUIWatchViewComposer()
    @StateObject private var connectionManager = WatchConnectionManager.shared
    @StateObject private var featureObserver = WatchFeatureObservable()
    
    var body: some Scene {
        WindowGroup {
            MainWatchView()
                .environmentObject(viewComposer)
                .environmentObject(connectionManager)
                .environmentObject(featureObserver)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        AppConfigurator.setupWatchApp()
        
        // Simulate device connection for demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            connectionManager.simulateDeviceConnection()
        }
    }
}


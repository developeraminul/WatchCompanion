//
//  AppDelegate.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppConfigurator.setupWatchApp()
        return true
    }
}


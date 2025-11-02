//
//  NotificationNames.swift
//  WatchCompanion
//
//  Created by Md. Aminul Islam on 1/11/25.
//
import Foundation

extension Notification.Name {
    static let heartRateDidUpdate = Notification.Name("heartRateDidUpdate")
    static let ecgDataDidUpdate = Notification.Name("ecgDataDidUpdate")
    static let bloodOxygenDidUpdate = Notification.Name("bloodOxygenDidUpdate")
    static let deviceDidConnect = Notification.Name("deviceDidConnect")
    static let deviceDidDisconnect = Notification.Name("deviceDidDisconnect")
}

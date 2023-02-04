//
//  NotificationPermissionProviding.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import Foundation
import UserNotifications

public protocol NotificationPermissionProviding {
    func requestPermission() async -> NotificationPermissionProvider.NotificationResult
}

public protocol NotificationPermissionGranter {
    func requestAuthorization() async throws -> Bool
}

extension UNUserNotificationCenter: NotificationPermissionGranter {
    public func requestAuthorization() async throws -> Bool {
        return try await self.requestAuthorization(options: [.alert, .badge, .sound])
    }
}

public struct NotificationPermissionProvider: NotificationPermissionProviding {
    private let notificationCentre: NotificationPermissionGranter

    public init(
        notificationCentre: NotificationPermissionGranter = UNUserNotificationCenter.current()
    ) {
        self.notificationCentre = notificationCentre
    }

    @MainActor
    @discardableResult
    public func requestPermission() async -> NotificationResult {
        do {
            _ = try await notificationCentre.requestAuthorization()
            return .success
        } catch {
            return .failure(error)
        }
    }

    public enum NotificationResult {
        case success, failure(Error)
    }
}

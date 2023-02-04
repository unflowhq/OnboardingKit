//
//  AuthService.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import Foundation

public protocol AuthService {
    func sendValidationEmail(to email: String) async -> Bool
    func sendValidationCode(to phoneNumber: String) async -> String?
}

public struct PlaceholderAuthService: AuthService {
    public init() { }

    @discardableResult
    public func sendValidationEmail(to email: String) async -> Bool {
        // Task: Add an email service into this logic instead of just sleeping and then firing off a hard coded success/fail.
        try? await Task.sleep(nanoseconds: UInt64(2_000_000_000))
        print("AuthService: Email Sent!")
        // False indicates an error
        return true
    }

    @discardableResult
    public func sendValidationCode(to phoneNumber: String) async -> String? {
        // Task: Add a code service into this logic instead of just sleeping and then firing off a hard coded success/fail.
        try? await Task.sleep(nanoseconds: UInt64(2_000_000_000))
        print("AuthService: Phone Code Sent!")
        // Nil indicates an error
        return "198913"
    }
}

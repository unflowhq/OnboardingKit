//
//  UserService.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import Foundation
import SwiftUI

public protocol UserService {
    func store(email: String?)
    func store(phoneNumber: String?)
    func clear()
}

public struct AppStorageUserService: UserService {
    // Task: These should ideally be in the keychain
    @AppStorage("login_email") private var email: String?
    @AppStorage("login_phone") private var phoneNumber: String?

    public init() { }

    public func store(email: String?) {
        self.email = email
    }

    public func store(phoneNumber: String?) {
        self.phoneNumber = phoneNumber
    }

    public func clear() {
        self.email = nil
        self.phoneNumber = nil
    }
}

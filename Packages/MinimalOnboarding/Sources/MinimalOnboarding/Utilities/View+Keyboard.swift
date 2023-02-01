//
//  View+Keyboard.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import Foundation
import SwiftUI
import Combine

/// Publisher to read keyboard changes.
extension View {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

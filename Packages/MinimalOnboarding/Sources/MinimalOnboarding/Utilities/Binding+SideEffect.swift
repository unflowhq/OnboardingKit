//
//  Binding+SideEffect.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import Foundation
import SwiftUI

extension Binding {
    func sideEffect(
        onSet: @escaping ((Value, Transaction) -> Void)
    ) -> Binding<Value> {
        .init(
            get: { self.wrappedValue },
            set: { newValue, transaction in
                onSet(newValue, transaction)
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }
}

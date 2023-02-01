//
//  Transition.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var headerTransition: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.7))
    }
}

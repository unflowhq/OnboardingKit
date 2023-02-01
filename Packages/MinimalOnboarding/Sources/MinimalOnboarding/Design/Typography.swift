//
//  Typography.swift
//  
//
//  Created by Alex Logan on 01/02/2023.
//

import Foundation
import SwiftUI
import DesignHelpKit

enum Typography {
    case title, body, button, field

    var font: Font {
        switch self {
        case .title:
            return MinimalFont.Manrope.bold.font(size: 32, relativeTo: .largeTitle)
        case .body:
            return MinimalFont.Manrope.regular.font(size: 16, relativeTo: .body)
        case .button:
            return MinimalFont.Inter.semiBold.font(size: 16, relativeTo: .headline)
        case .field:
            return MinimalFont.Inter.regular.font(size: 16, relativeTo: .body)
        }
    }
}

extension View {
    func typeStyle(_ style: Typography) -> some View {
        self.font(style.font)
    }
}

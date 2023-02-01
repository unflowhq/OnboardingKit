//
//  MinimalFont.swift
//
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI
import DesignHelpKit

enum MinimalFont {
    enum Inter: CaseIterable, FontDisplayable {
        case regular, semiBold

        var name: String {
            let baseName = "Inter-"
            switch self {
            case .regular:
                return baseName+"Regular"
            case .semiBold:
                return baseName+"SemiBold"
            }
        }
    }

    enum Manrope: CaseIterable, FontDisplayable {
        case regular, semiBold, extraBold, bold

        var name: String {
            let baseName = "Manrope-"
            switch self {
            case .regular:
                return baseName+"Regular"
            case .semiBold:
                return baseName+"SemiBold"
            case .extraBold:
                return baseName+"ExtraBold"
            case .bold:
                return baseName+"Bold"
            }
        }
    }
}

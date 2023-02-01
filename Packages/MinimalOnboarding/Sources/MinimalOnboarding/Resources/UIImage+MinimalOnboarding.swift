//
//  UIImage+MinimalOnboarding.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import DesignHelpKit
import UIKit

/// Convenience wrapper to get an image from the current package and displaying a warning triangle when it fails
public extension UIImage {
    static func fromPackage(named name: String) -> UIImage {
        return .fromPackage(named: name, bundle: .module)
    }
}

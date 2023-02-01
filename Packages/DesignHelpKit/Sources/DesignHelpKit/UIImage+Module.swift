//
//  UIImage+Module.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import Foundation
import UIKit

/// Convenience wrapper to get an image from the current package and displaying a warning triangle when it fails
public extension UIImage {
    static func fromPackage(named name: String, bundle: Bundle) -> UIImage {
        return .init(packageImageName: name, bundle: bundle) ?? UIImage(systemName: "exclamationmark.triangle.fill") ?? UIImage()
    }

    convenience init?(packageImageName: String, bundle: Bundle) {
        self.init(named: packageImageName, in: bundle, with: nil)
    }
}

//
//  Color.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI

extension Color {
    static var text: Color {
        Color(UIColor(named: "Text", in: .module, compatibleWith: nil) ?? .label)
    }

    static var primaryBackground: Color {
        Color(UIColor(named: "Background", in: .module, compatibleWith: nil) ?? .systemGroupedBackground)
    }

    static var secondaryBackground: Color {
        Color(UIColor(named: "SecondaryBackground", in: .module, compatibleWith: nil) ?? .systemGroupedBackground)
    }
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            preview(for: .text)
            preview(for: .primaryBackground)
            preview(for: .secondaryBackground)
        }
    }

    private static func preview(for color: Color) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 64, height: 64)
            .foregroundColor(color)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: -2)
                    .foregroundColor(Color(UIColor.opaqueSeparator))
            )
    }
}

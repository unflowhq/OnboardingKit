//
//  Header.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import SwiftUI

struct Header: View {
    let text: String
    let image: String?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
            if let image = image {
                Image(uiImage: UIImage.fromPackage(named: image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 160, alignment: .center)
            }
            Title(text: text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.opacity)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            Header(text: "Your login link is on the way!", image: "CoupleWithMoon")
                .previewDisplayName("Header with image")
            Header(text: "Hey hey", image: nil)
                .previewDisplayName("Header without image")
        }
        .padding()
    }
}

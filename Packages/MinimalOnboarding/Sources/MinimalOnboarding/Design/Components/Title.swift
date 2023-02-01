//
//  Title.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI

struct Title: View {
    let text: String

    var body: some View {
        Text(text)
            .typeStyle(.title)
            .foregroundColor(.text)
    }
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            Title(text: "OnboardingKit")
        }
    }
}

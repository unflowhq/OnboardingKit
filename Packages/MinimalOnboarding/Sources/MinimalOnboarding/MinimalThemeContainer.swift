//
//  MinimalThemeContainer.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI
import DesignHelpKit

struct MinimalThemeContainer<Content: View>: View {
    @StateObject private var model: ContainerModel = ContainerModel()
    private let content: () -> (Content)

    init(@ViewBuilder content: @escaping () -> (Content)) {
        self.content = content
    }

    var body: some View {
        content()
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .accentColor(Color.text)
    }
}

private class ContainerModel: ObservableObject {
    init() {
        fontUrls(bundle: .module).forEach { fontUrl in
            UIFont.register(from: fontUrl)
        }
    }

    func fontUrls(bundle: Bundle) -> [URL] {
        let filenames = MinimalFont.Inter.allCases.map { $0.name } + MinimalFont.Manrope.allCases.map { $0.name }
        return filenames.compactMap {
            bundle.url(forResource: $0, withExtension: "ttf")
        }
    }
}

struct Container_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            Text("Manrope")
                .font(Font.custom("Manrope-ExtraBold", size: 16))
        }
    }
}

//
//  IntroView.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI

struct IntroPage: View {
    let actionHandler: ((IntroPage.Action) -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
            Title(text: "Boost your business risk free")
                .padding(.top, DesignConstants.Padding.headerPaddingWihoutNavigationBar)
                .padding(.horizontal)
                .minimumScaleFactor(0.6)

            OffsetImageStack(
                bottomLeadingImageName: "IntroImageOne",
                topTrailingimageName: "IntroImageTwo"
            )
            .accessibilityHidden(true)

            VStack(spacing: DesignConstants.Spacing.compactStack) {
                MinimalButton(
                    text: "Sign Up",
                    style: .primary,
                    prominence: .regular,
                    action: {
                        actionHandler(.signUp)
                    }
                )
                MinimalButton(
                    text: "Log In",
                    style: .secondary,
                    prominence: .regular,
                    action: {
                        actionHandler(.signIn)
                    }
                )
            }
            .padding([.horizontal, .top])
            .padding(.bottom, DesignConstants.Spacing.doubleCompactStack)
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    enum Action {
        case signIn, signUp
    }
}

/// Double image stack that shows two images, one at the bottom leading edge and one at the top trailing
/// If the user has large type sizes enabled, we only show one image, the one provided as bottomLeadingImage
private struct OffsetImageStack: View {
    @Environment(\.sizeCategory) var sizeCategory
    let bottomLeadingImageName: String
    let topTrailingimageName: String

    var isRegularSizes: Bool {
        sizeCategory < .extraLarge
    }

    var stackAligmment: VerticalAlignment {
        isRegularSizes ? .top : .center
    }

    var body: some View {
        HStack(alignment: stackAligmment, spacing: DesignConstants.Spacing.doubleCompactStack) {
            Image(uiImage: .fromPackage(named: bottomLeadingImageName))
                .resizable()
                .aspectRatio(0.6, contentMode: .fit)
                .alignmentGuide(.top) { context in
                    return context[.top] - context.height / 2
                }

            if isRegularSizes {
                Image(uiImage: .fromPackage(named: topTrailingimageName))
                    .resizable()
                    .aspectRatio(0.6, contentMode: .fit)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity // Cap to stop the view from ever going outside the bounds of the page
        )
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            IntroPage(actionHandler: { _ in })
        }
    }
}

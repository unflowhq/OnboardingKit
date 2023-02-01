//
//  SetupConfirmationPage.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import SwiftUI

struct SetupConfirmationPage: View {
    var handler: (Action) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.compactStack) {
            Header(text: "You're all set up!", image: "Flowers")
                .padding(.top, DesignConstants.Padding.headerPaddingWihoutNavigationBar)
            Text("From now on you can use your phone number to identify yourself, when you log in or confirm transactions.")
                .typeStyle(.body)
            Spacer()
            MinimalButton(
                text: "Great",
                style: .primary,
                prominence: .regular,
                action: {
                    handler(.done)
                })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarBackButtonHidden(true)
    }

    enum Action {
        case done
    }
}

struct SetupConfirmationPage_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            SetupConfirmationPage(handler: { _ in })
        }
    }
}
